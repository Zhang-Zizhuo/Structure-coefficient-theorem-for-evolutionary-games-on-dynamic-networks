# using SparseArrays, IterativeSolvers, LinearAlgebra
# function fij_d(w,u,t,n)
#     s=size(w)
#     N=s[1]
#     g=s[3]

#     for gamma=1:g 
#         for i=1:N 
#             w[i,:,gamma].=w[i,:,gamma]./sum(w[i,:,gamma])
#         end
#     end

#     e=zeros(N,N,g)
#     for gamma=1:g 
#         for i=1:N 
#             for j=1:N 
#                 compete = w[j,:,gamma]
#                 compete.=compete./sum(compete)
#                 e[i,j,gamma]=1/N*compete[i]
#             end
#         end
#     end
#     # 时序网络
#     # q=zeros(g,g)
#     # for i=1:g-1
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

#     A=zeros(N^2*g,N^2*g)
#     b=zeros(N^2*g,1)

#     for beta=1:g 
#         for i=1:N 
#             for j=1:N 
#                 row = N^2*(beta-1)+N*(i-1)+j 

#                 if i==j 
#                     A[row,row] = 1
#                     b[row]=1
#                     continue
#                 end

#                 if i>j 
#                     line = (beta-1)*N^2 + N*(j-1) + i 
#                     A[row,row] = 1 
#                     A[row,line] = -1
#                     b[row] = 0
#                     continue
#                 end



#                 A[row,row] += 1
#                 for alpha=1:g 

#                     for k=1:N 
#                         line = N^2*(alpha-1)+N*(k-1)+j 
#                         A[row,line] -= q[alpha,beta]*e[k,i,alpha]*(1-u)
#                         line = N^2*(alpha-1)+N*(k-1)+i 
#                         A[row,line] -= q[alpha,beta]*e[k,j,alpha]*(1-u)
#                     end

#                     line = N^2*(alpha-1)+N*(i-1)+j 
#                     A[row,line] -= q[alpha,beta]*(1-2/N)
#                 end

#                 b[row] = 2*u/n/N*sum(q[:,beta])
#             end
#         end
#     end

#     # F = A \ b 

#     println("填充完成")

#     A1 = sparse(A)
#     b1 = vec(b)
#     F = idrs(A1,b1)
    


#     fij=zeros(N,N,g)
#     for i=1:N^2*g 
#         gamma = ceil(Int,i/N^2)
#         index_1 = ceil(Int,(i-(gamma-1)*N^2)/N)
#         index_2 = i - (gamma-1)*N^2 - (index_1-1)*N 
#         fij[index_1,index_2,gamma] = F[i]
#     end
#     return fij


# end




using SparseArrays, IterativeSolvers, LinearAlgebra

function fij_d(w, u, t, n)
    s = size(w)
    N = s[1]
    g = s[3]

    # 归一化 w
    for gamma = 1:g 
        for i = 1:N 
            row_sum = sum(w[i, :, gamma])
            if row_sum > 0
                w[i, :, gamma] ./= row_sum
            end
        end
    end

    # 计算 e
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

    total_size = N^2 * g
    # 使用稀疏矩阵直接构建
    I = Int[]  # 行索引
    J = Int[]  # 列索引
    V = Float64[]  # 值
    b = zeros(total_size)

    for beta = 1:g 
        for i = 1:N 
            for j = 1:N 
                row = N^2 * (beta - 1) + N * (i - 1) + j 
                
                if i == j 
                    push!(I, row)
                    push!(J, row)
                    push!(V, 1.0)
                    b[row] = 1
                    continue
                end

                if i > j 
                    line = (beta - 1) * N^2 + N * (j - 1) + i 
                    push!(I, row)
                    push!(J, row)
                    push!(V, 1.0)
                    push!(I, row)
                    push!(J, line)
                    push!(V, -1.0)
                    b[row] = 0
                    continue
                end

                # i < j 的情况
                push!(I, row)
                push!(J, row)
                push!(V, 1.0)  # A[row, row] += 1
                
                for alpha = 1:g 
                    for k = 1:N 
                        # 第一个减项
                        line1 = N^2 * (alpha - 1) + N * (k - 1) + j 
                        val1 = -q[alpha, beta] * e[k, i, alpha] * (1 - u)
                        push!(I, row)
                        push!(J, line1)
                        push!(V, val1)
                        
                        # 第二个减项
                        line2 = N^2 * (alpha - 1) + N * (k - 1) + i 
                        val2 = -q[alpha, beta] * e[k, j, alpha] * (1 - u)
                        push!(I, row)
                        push!(J, line2)
                        push!(V, val2)
                    end
                    
                    # 第三个减项
                    line3 = N^2 * (alpha - 1) + N * (i - 1) + j 
                    val3 = -q[alpha, beta] * (1 - 2/N)
                    push!(I, row)
                    push!(J, line3)
                    push!(V, val3)
                end
                
                b[row] = 2 * u / (n * N) * sum(q[:, beta])
            end
        end
    end

    # 直接创建稀疏矩阵
    A_sparse = sparse(I, J, V, total_size, total_size)
    # println("稀疏矩阵构建完成，非零元素数量: ", nnz(A_sparse))
    
    # 求解方程组
    # F = idrs(A_sparse, b)
    Initial_Vec = ones(N^2*g,1)
    Initial_Vec = vec(Initial_Vec)
    F = idrs!(Initial_Vec, A_sparse, b) 
    
    # 重构结果
    fij = zeros(N, N, g)
    for idx = 1:length(F)
        gamma = ceil(Int, idx / N^2)
        local_idx = idx - (gamma - 1) * N^2
        i = ceil(Int, local_idx / N)
        j = local_idx - (i - 1) * N
        fij[i, j, gamma] = F[idx]
    end
    
    return fij
end