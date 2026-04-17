# Function to simulate evolutionary game dynamics on a dynamic network
#
# Input:
# w: N × N × L array of adjacency matrices of the static counterparts
# u: Mutation rate
# q: L × L transition matrix of network states
# delta: Selection intensity
# maxLoop: Number of independent simulation runs
# maxIter: Number of iterations in each simulation run
# A: n × n payoff matrix
#
# Output:
# frequency: 1 × n array of stationary strategy frequencies estimated from simulation
function game_on_dynamic_network(w, u, q, delta, maxLoop, maxIter, A)

    N, _, L = size(w)
    n, _ = size(A)

    frequency = zeros(Float64, 1, n)

    reward = zeros(Float64, N)
    fecundity = zeros(Float64, N)
    state = zeros(Int, N)

    network_state = 1

    for loop = 1:maxLoop

        for i = 1:N
            state[i] = rand(1:n)
        end

        network_state = 1

        reward .= 0.0
        for i = 1:N
            for j = 1:N
                reward[i] += w[i, j, network_state] * A[state[i], state[j]]
            end
        end

        fecundity .= exp.(delta .* reward)

        for iter = 1:maxIter

            death = rand(1:N)

            birth_candidates = Int[]
            birth_weights = Float64[]

            for i = 1:N
                if w[death, i, network_state] > 0
                    push!(birth_candidates, i)
                    push!(birth_weights, w[death, i, network_state] * fecundity[i])
                end
            end

            birth_weights ./= sum(birth_weights)
            cumulative_birth_weights = cumsum(birth_weights)

            p = rand()
            birth = birth_candidates[end]
            for idx = 1:length(cumulative_birth_weights)
                if cumulative_birth_weights[idx] > p
                    birth = birth_candidates[idx]
                    break
                end
            end

            state_changed = 0
            if state[birth] != state[death]
                state_changed = 1
            end

            state[death] = state[birth]

            if rand() < u
                state[death] = rand(1:n)
                state_changed = 1
            end

            network_changed = 0

            network_transition_probabilities = collect(q[network_state, :])
            network_transition_probabilities ./= sum(network_transition_probabilities)
            cumulative_network_transition_probabilities = cumsum(network_transition_probabilities)

            p = rand()
            for new_network_state = 1:L
                if cumulative_network_transition_probabilities[new_network_state] > p
                    if network_state != new_network_state
                        network_changed = 1
                    end
                    network_state = new_network_state
                    break
                end
            end

            if network_changed == 1

                for i = 1:N
                    reward[i] = 0.0
                    for j = 1:N
                        reward[i] += w[i, j, network_state] * A[state[i], state[j]]
                    end
                    fecundity[i] = exp(delta * reward[i])
                end

            else

                if state_changed == 1
                    reward[death] = 0.0
                    for j = 1:N
                        if w[death, j, network_state] > 0
                            reward[death] += w[death, j, network_state] * A[state[death], state[j]]
                        end
                    end
                    fecundity[death] = exp(delta * reward[death])

                    for i = 1:N
                        if w[i, death, network_state] > 0
                            reward[i] = 0.0
                            for j = 1:N
                                reward[i] += w[i, j, network_state] * A[state[i], state[j]]
                            end
                            fecundity[i] = exp(delta * reward[i])
                        end
                    end
                end

            end

            if iter > 0.05 * maxIter
                for i = 1:N
                    frequency[state[i]] += 1 / N
                end
            end

        end

    end

    frequency = frequency / maxLoop / (0.95 * maxIter)

    return frequency
end