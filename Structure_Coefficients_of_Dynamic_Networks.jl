
using SparseArrays, LinearAlgebra, IterativeSolvers

# q: Transition probability matrix of networks
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



# w: Adjacency matrices of the static counterparts, stored as an N × N × L array
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




# w: Adjacency matrices of the static counterparts, stored as an N × N × L array
# u: Mutation rate
# q: Transition matrix of network states, where q[beta, alpha] is the probability
#    that the network state switches from beta to alpha in one step
function Pair_weights(w, u, q)

    N, _, L = size(w)

    e = replacement_probabilities(w)

    d = ones(N, L) / N  ## d[i,beta] is the death probability of individual i in network beta, which is 1/N for DB process

    total_size = N * L
    # 使用稀疏矩阵直接构建
    I_idx = Int[]  # 行索引
    J_idx = Int[]  # 列索引
    V_val = Float64[]  # 值
    b = zeros(total_size)

    for gamma1 = 1:L 
        for i = 1:N 
            row = (gamma1 - 1) * N + i 
            
            # 添加对角元素 (A[row,row] -= 1)
            push!(I_idx, row)
            push!(J_idx, row)
            push!(V_val, -1.0)
            
            # 添加其他元素
            for gamma2 = 1:L 
                for j = 1:N 
                    col = (gamma2 - 1) * N + j 
                    val = 0.0
                    
                    # 第一部分: q[gamma1,gamma2]*(1-u)*e[i,j,gamma1]
                    val += q[gamma1, gamma2] * (1 - u) * e[i, j, gamma1]
                    
                    # 第二部分: 当 j==i 时的额外项
                    if j == i 
                        val += q[gamma1, gamma2] * (1 - d[i, gamma1])
                    end
                    
                    # 只添加非零值
                    if val != 0
                        push!(I_idx, row)
                        push!(J_idx, col)
                        push!(V_val, val)
                    end
                end
            end
            
            # 设置右侧向量
            b[row] = -1/N 
        end
    end

    # 直接创建稀疏矩阵
    A_sparse = sparse(I_idx, J_idx, V_val, total_size, total_size)
    
    # 求解方程组
    
    V_vec = idrs(A_sparse, b)
    # 重构结果
    v = zeros(N, L)
    for idx = 1:length(V_vec)
        gamma = ceil(Int, idx / N)
        node = idx - (gamma - 1) * N 
        v[node, gamma] = V_vec[idx]
    end
    
    return v
end






# w: Adjacency matrices of the static counterparts, stored as an N × N × L array
# u: Mutation rate
# q: Transition matrix of network states, where q[beta, alpha] is the probability
#    that the network state switches from beta to alpha in one step
# n: Number of strategies in the reference system, which can be set as any integer >= 2
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







# w: Adjacency matrices of the static counterparts, stored as an N × N × L array
# u: Mutation rate
# q: Transition matrix of network states, where q[beta, alpha] is the probability
#    that the network state switches from beta to alpha in one step
# n: Number of strategies in the reference system, which can be set as any integer >= 2
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






# w: Adjacency matrices of the static counterparts, stored as an N × N × L array
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





# w: Adjacency matrices of the static counterparts, stored as an N × N × L array
# u: Mutation rate
# q: Transition matrix of network states, where q[beta, alpha] is the probability
#    that the network state switches from beta to alpha in one step
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

