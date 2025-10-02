# function V_d(w,u,t)

#     s=size(w)
#     N=s[1]
#     g=s[3]
#     # 时序网络
#     # q=zeros(g,g)
#     # for i=1:(g-1)
#     #     q[i,i+1]=1
#     # end
#     # q[g,1]=1
#     # q = [ 1-t/N   t/N
#     #        t/N   1-t/N]
#     q = zeros(g,g)
#     for i=1:g 
#         for j=1:g 
#             if i==j 
#                 q[i,j] = 1 - t/N 
#             else 
#                 q[i,j] = t/N/(g-1)
#             end
#         end
#     end

#     for gamma=1:g 
#         for i=1:N 
#             w[i,:,gamma].=w[i,:,gamma]./sum(w[i,:,gamma])
#         end
#     end

#     e=zeros(N,N,g)
#     for gamma=1:g 
#         for i=1:N 
#             for j=1:N 
#                 compete=w[j,:,gamma]
#                 compete.=compete./sum(compete)
#                 e[i,j,gamma]=1/N*compete[i]
#             end
#         end
#     end

#     d=zeros(N,g)
#     for gamma=1:g 
#         for i=1:N 
#             d[i,gamma]=sum(e[:,i,gamma])
#         end
#     end

#     A=zeros(N*g,N*g)
#     b=zeros(N*g,1)

#     for gamma1=1:g 
#         for i=1:N 
#             row = (gamma1-1)*N + i 
            
#             for gamma2=1:g 
#                 for j=1:N 
#                     line=(gamma2-1)*N + j 
#                     A[row,line] += q[gamma1,gamma2]*(1-u)*e[i,j,gamma1]
                    
#                     if j==i 
#                         A[row,line] += q[gamma1,gamma2]*(1-d[i,gamma1])
#                     end

#                 end
#             end

#             A[row,row] -= 1
#             b[row] = -1/N 
#         end
#     end

#     V = A \ b  # 求解方程 Ax = b
    
#     value = zeros(N,g)
#     for i=1:N*g 
#         gamma = ceil(Int, i/N)
#         index = i - (gamma-1)*N 
#         value[index,gamma]=V[i]
#     end
#     return value

# end




using SparseArrays, LinearAlgebra

function V_d(w, u, t)
    s = size(w)
    N = s[1]
    g = s[3]
    
    # 构建转移矩阵 q
    q = zeros(g, g)
    for i = 1:g 
        for j = 1:g 
            if i == j 
                q[i, j] = 1 - t/N 
            else 
                q[i, j] = t/(N*(g-1))
            end
        end
    end

    # 归一化 w (添加零除保护)
    for gamma = 1:g 
        for i = 1:N 
            row_sum = sum(w[i, :, gamma])
            if row_sum > 0
                w[i, :, gamma] ./= row_sum
            end
        end
    end

    # 计算 e 矩阵 (添加零除保护)
    e = zeros(N, N, g)
    for gamma = 1:g 
        for i = 1:N 
            for j = 1:N 
                compete = copy(w[j, :, gamma])
                sum_compete = sum(compete)
                if sum_compete > 0
                    compete ./= sum_compete
                end
                e[i, j, gamma] = 1/N * compete[i]
            end
        end
    end

    # 计算 d 矩阵
    d = zeros(N, g)
    for gamma = 1:g 
        for i = 1:N 
            d[i, gamma] = sum(e[:, i, gamma])
        end
    end

    total_size = N * g
    # 使用稀疏矩阵直接构建
    I_idx = Int[]  # 行索引
    J_idx = Int[]  # 列索引
    V_val = Float64[]  # 值
    b = zeros(total_size)

    for gamma1 = 1:g 
        for i = 1:N 
            row = (gamma1 - 1) * N + i 
            
            # 添加对角元素 (A[row,row] -= 1)
            push!(I_idx, row)
            push!(J_idx, row)
            push!(V_val, -1.0)
            
            # 添加其他元素
            for gamma2 = 1:g 
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
    value = zeros(N, g)
    for idx = 1:length(V_vec)
        gamma = ceil(Int, idx / N)
        node = idx - (gamma - 1) * N 
        value[node, gamma] = V_vec[idx]
    end

    # println("1")
    
    return value
end