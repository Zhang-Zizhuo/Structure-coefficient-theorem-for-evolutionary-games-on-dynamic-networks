# Functions for computing structure coefficients of dynamic networks.
#
# This file is intended to be included by other Julia scripts, such as `Demo.jl`.
# The main user-facing function is `Structure_Coefficients(w, u, q)`, which returns
# the three structure coefficients [Lambda_1, Lambda_2, Lambda_3] for a given
# dynamic network.
#
# Inputs to the main function:
# - w: adjacency matrices of the static network states, stored as an N x N x L array.
# - u: mutation rate.
# - q: transition probability matrix of network states, stored as an L x L matrix.
#
# The remaining functions in this file are helper functions used internally by
# `Structure_Coefficients`.

using SparseArrays, LinearAlgebra, IterativeSolvers


# Stationary distribution of network states.
#
# Input:
# - q: transition probability matrix of network states, L × L matrix.
#
# Output:
# - s: stationary distribution of network states, length-L vector.
function stationary_distribution_of_networks(q)

    L = size(q, 1)  # Number of static counterparts
    A = zeros(L, L)
    A .= transpose(q)
    for i = 1:L
        A[i, i] -= 1
    end

    A[end, :] .= 1
    b = zeros(L)
    b[end] = 1
    s = A \ b

    return s
end



# Neutral replacement probabilities under death-birth updating.
#
# Input:
# - w: adjacency matrices of the static counterparts, N × N × L array.
#
# Output:
# - e: replacement probabilities, N × N × L array.
function replacement_probabilities(w)
    N, _, L = size(w)
    e = zeros(N, N, L)
    for beta = 1:L
        for i = 1:N 
            for j = 1:N 
                compete = copy(w[j, :, beta])
                sum_compete = sum(compete)
                if sum_compete > 0
                    compete ./= sum_compete
                end
                e[i, j, beta] = 1/N * compete[i]
            end
        end
    end
    return e
end


# Pair weights in the weighted-frequency method (for DB process) (see Eq.SI.13 in the SI).
#
# Input:
# - w: adjacency matrices of the static counterparts, N × N × L array.
# - u: mutation rate, scalar.
# - q: transition probability matrix of network states, L × L matrix.
#
# Output:
# - v: pair weights, N × L matrix.
function Pair_weights(w, u, q)

    N, _, L = size(w)

    e = replacement_probabilities(w)

    death_probability = 1.0 / N
    survival_probability = 1.0 - death_probability

    total_size = N * L

    row_indices = Int[]
    col_indices = Int[]
    values = Float64[]
    b = zeros(Float64, total_size)

    for beta = 1:L
        for i = 1:N
            row = (beta - 1) * N + i

            # Diagonal term
            push!(row_indices, row)
            push!(col_indices, row)
            push!(values, -1.0)

            for alpha = 1:L
                q_beta_alpha = q[beta, alpha]

                for j = 1:N
                    col = (alpha - 1) * N + j

                    val = q_beta_alpha * (1.0 - u) * e[i, j, beta]

                    if j == i
                        val += q_beta_alpha * survival_probability
                    end

                    if val != 0.0
                        push!(row_indices, row)
                        push!(col_indices, col)
                        push!(values, val)
                    end
                end
            end

            b[row] = -death_probability
        end
    end

    A_sparse = sparse(row_indices, col_indices, values, total_size, total_size)

    initial_vec = ones(Float64, total_size)
    v_vec = idrs!(initial_vec, A_sparse, b)

    v = reshape(v_vec, N, L)

    return v
end






# IBS probabilities for node pairs (for DB process) (see Eq.10 in the main text, or Eq.SI.46 in the main text).
#
# Input:
# - w: adjacency matrices of the static counterparts, N × N × L array.
# - u: mutation rate, scalar.
# - q: transition probability matrix of network states, L × L matrix.
# - n: number of strategies in the reference system, integer.
#
# Output:
# - phi2: IBS probabilities for node pairs, N × N × L array.
function IBS_probabilities_for_node_pairs(w, u, q, n)

    N, _, L = size(w)

    e = replacement_probabilities(w)
    s = stationary_distribution_of_networks(q)

    total_size = N^2 * L

    row_indices = Int[]
    col_indices = Int[]
    values = Float64[]
    b = zeros(Float64, total_size)

    for beta = 1:L
        for i = 1:N
            for j = 1:N
                row = N^2 * (beta - 1) + N * (i - 1) + j

                if i == j
                    push!(row_indices, row)
                    push!(col_indices, row)
                    push!(values, 1.0)
                    b[row] = 1.0
                    continue
                end

                if i > j
                    symmetric_row = N^2 * (beta - 1) + N * (j - 1) + i
                    push!(row_indices, row)
                    push!(col_indices, row)
                    push!(values, 1.0)
                    push!(row_indices, row)
                    push!(col_indices, symmetric_row)
                    push!(values, -1.0)
                    b[row] = 0.0
                    continue
                end

                push!(row_indices, row)
                push!(col_indices, row)
                push!(values, 1.0)

                for alpha = 1:L
                    for k = 1:N
                        col_1 = N^2 * (alpha - 1) + N * (k - 1) + j
                        val_1 = -s[alpha] / s[beta] * q[alpha, beta] * e[k, i, alpha] * (1 - u)
                        if val_1 != 0.0
                            push!(row_indices, row)
                            push!(col_indices, col_1)
                            push!(values, val_1)
                        end

                        col_2 = N^2 * (alpha - 1) + N * (k - 1) + i
                        val_2 = -s[alpha] / s[beta] * q[alpha, beta] * e[k, j, alpha] * (1 - u)
                        if val_2 != 0.0
                            push!(row_indices, row)
                            push!(col_indices, col_2)
                            push!(values, val_2)
                        end
                    end

                    col_3 = N^2 * (alpha - 1) + N * (i - 1) + j
                    val_3 = -s[alpha] / s[beta] * q[alpha, beta] * (1 - 2 / N)
                    if val_3 != 0.0
                        push!(row_indices, row)
                        push!(col_indices, col_3)
                        push!(values, val_3)
                    end
                end

                for alpha = 1:L
                    b[row] += 2 * u / (n * N) * q[alpha, beta] * s[alpha] / s[beta]
                end
            end
        end
    end

    A_sparse = sparse(row_indices, col_indices, values, total_size, total_size)

    initial_vec = ones(Float64, total_size)
    phi2_vec = idrs!(initial_vec, A_sparse, b)

    phi2 = zeros(Float64, N, N, L)
    for idx = 1:total_size
        beta = div(idx - 1, N^2) + 1
        local_idx = idx - (beta - 1) * N^2
        i = div(local_idx - 1, N) + 1
        j = local_idx - (i - 1) * N
        phi2[i, j, beta] = phi2_vec[idx]
    end

    return phi2
end







# IBS probabilities for triplets of nodes (for DB process) (see Eq.11 in the main text, or Eq.SI.54 in the main text).
#
# Input:
# - w: adjacency matrices of the static counterparts, N × N × L array.
# - u: mutation rate, scalar.
# - q: transition probability matrix of network states, L × L matrix.
# - n: number of strategies in the reference system, integer.
#
# Output:
# - phi3: IBS probabilities for node triplets, N × N × N × L array.
function IBS_probabilities_for_triplets(w, u, q, n)

    N, _, L = size(w)

    e = replacement_probabilities(w)
    s = stationary_distribution_of_networks(q)
    phi2 = IBS_probabilities_for_node_pairs(w, u, q, n)

    total_size = N^3 * L

    row_indices = Int[]
    col_indices = Int[]
    values = Float64[]
    b = zeros(Float64, total_size)

    for beta = 1:L
        for i = 1:N
            for j = 1:N
                for k = 1:N
                    row = N^3 * (beta - 1) + N^2 * (i - 1) + N * (j - 1) + k

                    if i == j && j == k
                        push!(row_indices, row)
                        push!(col_indices, row)
                        push!(values, 1.0)
                        b[row] = 1.0
                        continue
                    end

                    if i == j
                        push!(row_indices, row)
                        push!(col_indices, row)
                        push!(values, 1.0)
                        b[row] = phi2[i, k, beta]
                        continue
                    end

                    if j == k
                        push!(row_indices, row)
                        push!(col_indices, row)
                        push!(values, 1.0)
                        b[row] = phi2[i, j, beta]
                        continue
                    end

                    if i == k
                        push!(row_indices, row)
                        push!(col_indices, row)
                        push!(values, 1.0)
                        b[row] = phi2[i, j, beta]
                        continue
                    end

                    push!(row_indices, row)
                    push!(col_indices, row)
                    push!(values, 1.0)

                    for alpha = 1:L
                        for x = 1:N
                            col_1 = (alpha - 1) * N^3 + (x - 1) * N^2 + (j - 1) * N + k
                            val_1 = -s[alpha] / s[beta] * q[alpha, beta] * e[x, i, alpha] * (1 - u)
                            if val_1 != 0.0
                                push!(row_indices, row)
                                push!(col_indices, col_1)
                                push!(values, val_1)
                            end

                            col_2 = (alpha - 1) * N^3 + (i - 1) * N^2 + (x - 1) * N + k
                            val_2 = -s[alpha] / s[beta] * q[alpha, beta] * e[x, j, alpha] * (1 - u)
                            if val_2 != 0.0
                                push!(row_indices, row)
                                push!(col_indices, col_2)
                                push!(values, val_2)
                            end

                            col_3 = (alpha - 1) * N^3 + (i - 1) * N^2 + (j - 1) * N + x
                            val_3 = -s[alpha] / s[beta] * q[alpha, beta] * e[x, k, alpha] * (1 - u)
                            if val_3 != 0.0
                                push!(row_indices, row)
                                push!(col_indices, col_3)
                                push!(values, val_3)
                            end
                        end

                        col_4 = (alpha - 1) * N^3 + (i - 1) * N^2 + (j - 1) * N + k
                        val_4 = -s[alpha] / s[beta] * q[alpha, beta] * (1 - 3 / N)
                        if val_4 != 0.0
                            push!(row_indices, row)
                            push!(col_indices, col_4)
                            push!(values, val_4)
                        end
                    end

                    for alpha = 1:L
                        b[row] += s[alpha] / s[beta] * u / (n * N) * q[alpha, beta] * (
                            phi2[j, k, alpha] + phi2[i, k, alpha] + phi2[i, j, alpha]
                        )
                    end
                end
            end
        end
    end

    A_sparse = sparse(row_indices, col_indices, values, total_size, total_size)

    initial_vec = ones(Float64, total_size)
    phi3_vec = idrs!(initial_vec, A_sparse, b)

    phi3 = zeros(Float64, N, N, N, L)
    for idx = 1:total_size
        beta = div(idx - 1, N^3) + 1
        local_idx = idx - (beta - 1) * N^3
        i = div(local_idx - 1, N^2) + 1
        local_idx -= (i - 1) * N^2
        j = div(local_idx - 1, N) + 1
        k = local_idx - (j - 1) * N
        phi3[i, j, k, beta] = phi3_vec[idx]
    end

    return phi3
end






# Marginal effects of fecundity on replacement probabilities (for DB process) (see Eq.14 in the main text). 
#
# Input:
# - w: adjacency matrices of the static counterparts, N × N × L array.
#
# Output:
# - c: marginal effects, N × N × N × L array.
function marginal_effect(w)
    N, _, L = size(w)
    c = zeros(N, N, N, L)
    for j = 1:N 
        for i = 1:N 
            for k = 1:N
                for beta = 1:L 
                    if k == j 
                        c[j, i, k, beta] = w[i,j,beta] * ( sum(w[i,:,beta]) - w[i,j,beta]) / N / (sum(w[i,:,beta])^2)
                    else 
                        c[j, i, k, beta] = - w[i,j,beta] * w[i,k,beta] / N / (sum(w[i,:,beta])^2)
                    end
                end
            end
        end
    end
    return c
end





# Three structure coefficients for dynamic networks (see Eq.SI.64 in the main text).
#
# Input:
# - w: adjacency matrices of the static counterparts, N × N × L array.
# - u: mutation rate, scalar.
# - q: transition probability matrix of network states, L × L matrix.
#
# Output:
# - structure_coefficients_value: three structure coefficients [Lambda_1, Lambda_2, Lambda_3], length-3 vector.
function Structure_Coefficients(w, u, q)

    n = 3  # Number of strategies, which can be set as any integer >= 3

    N, _, L = size(w)

    s = stationary_distribution_of_networks(q)
    c = marginal_effect(w)
    v = Pair_weights(w, u, q)
    phi2 = IBS_probabilities_for_node_pairs(w, u, q, n)
    phi3 = IBS_probabilities_for_triplets(w, u, q, n)

    Lambda_1 = 0.0
    for beta = 1:L
        for alpha = 1:L
            for i = 1:N
                for j = 1:N
                    for k = 1:N
                        for l = 1:N
                            Lambda_1 += s[beta] * q[beta, alpha] * w[k, l, beta] * v[i, alpha] * c[j, i, k, beta] * (
                                -n^2 * phi3[i, k, l, beta]
                                + n^2 * (1 - u) * phi3[j, k, l, beta]
                                + n * phi2[i, k, beta]
                                + n * phi2[i, l, beta]
                                - n * (1 - u) * phi2[j, k, beta]
                                - n * (1 - u) * phi2[j, l, beta]
                                + n * u * phi2[k, l, beta]
                                - 2 * u
                            ) / ((n - 1) * (n - 2))
                        end
                    end
                end
            end
        end
    end

    Lambda_2 = 0.0
    for beta = 1:L
        for alpha = 1:L
            for i = 1:N
                for j = 1:N
                    for k = 1:N
                        for l = 1:N
                            Lambda_2 += s[beta] * q[beta, alpha] * w[k, l, beta] * v[i, alpha] * c[j, i, k, beta] * (
                                -n^2 * phi3[i, k, l, beta]
                                + n^2 * (1 - u) * phi3[j, k, l, beta]
                                + n * phi2[i, k, beta]
                                + n * (n - 1) * phi2[i, l, beta]
                                - n * (1 - u) * phi2[j, k, beta]
                                - n * (n - 1) * (1 - u) * phi2[j, l, beta]
                                + n * u * phi2[k, l, beta]
                                - n * u
                            ) / ((n - 1) * (n - 2))
                        end
                    end
                end
            end
        end
    end

    Lambda_3 = 0.0
    for beta = 1:L
        for alpha = 1:L
            for i = 1:N
                for j = 1:N
                    for k = 1:N
                        for l = 1:N
                            Lambda_3 += s[beta] * q[beta, alpha] * w[k, l, beta] * v[i, alpha] * c[j, i, k, beta] * (
                                2 * n^2 * phi3[i, k, l, beta]
                                - 2 * n^2 * (1 - u) * phi3[j, k, l, beta]
                                - n^2 * phi2[i, k, beta]
                                - n^2 * phi2[i, l, beta]
                                + n^2 * (1 - u) * phi2[j, k, beta]
                                + n^2 * (1 - u) * phi2[j, l, beta]
                                - 2 * n * u * phi2[k, l, beta]
                                + 2 * n * u
                            ) / ((n - 1) * (n - 2))
                        end
                    end
                end
            end
        end
    end

    structure_coefficients_value = [Lambda_1, Lambda_2, Lambda_3]

    return structure_coefficients_value
end

