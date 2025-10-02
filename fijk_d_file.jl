# include("fij_d_PC_file.jl")
# function fijk_d(w,u,t,n)
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
#                 compete=w[j,:,gamma]
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

#     A=zeros(N^3*g, N^3*g)
#     b=zeros(N^3*g, 1)

#     fij = fij_d_PC(w,u,t,n)

#     for beta=1:g 
#         for i=1:N 
#             for j=1:N 
#                 for k=1:N 
#                     row = N^3*(beta-1) + N^2*(i-1) + N*(j-1) + k 

#                     if i==j && j==k 
#                         A[row,row]=1
#                         b[row]=1
#                         continue
#                     end

#                     if i==j 
#                         A[row,row]=1
#                         b[row]=fij[i,k,beta]
#                         continue
#                     end

#                     if j==k 
#                         A[row,row]=1
#                         b[row]=fij[i,j,beta]
#                         continue
#                     end

#                     if i==k 
#                         A[row,row]=1
#                         b[row]=fij[i,j,beta]
#                         continue
#                     end

#                     # if !(i<j) || !(j<k)  # 要求 i<j<k
#                     #     x1, x2, x3 = sort([i,j,k])
#                     #     line = (beta-1)*N^3 + N^2*(x1-1) + N*(x2-1) + x3 
#                     #     A[row,row]=1
#                     #     A[row,line]=-1
#                     #     b[row]=0
#                     #     continue
#                     # end

#                     A[row,row]+=1
#                     for alpha=1:g 
#                         for x=1:N 
#                             line = (alpha-1)*N^3 + (x-1)*N^2 + (j-1)*N + k 
#                             A[row,line] -= q[alpha,beta]*e[x,i,alpha]*(1-u)

#                             line = (alpha-1)*N^3 + (i-1)*N^2 + (x-1)*N + k 
#                             A[row,line] -= q[alpha,beta]*e[x,j,alpha]*(1-u) 

#                             line = (alpha-1)*N^3 + (i-1)*N^2 + (j-1)*N + x 
#                             A[row,line] -= q[alpha,beta]*e[x,k,alpha]*(1-u)
#                         end

#                         line = (alpha-1)*N^3 + (i-1)*N^2 + (j-1)*N + k 
#                         A[row,line] -= q[alpha,beta]*(1-3/N)

#                     end
                    
#                     for alpha=1:g 
#                         b[row] += u/n/N*q[alpha,beta]*(fij[j,k,alpha]+fij[i,k,alpha]+fij[i,j,alpha])
#                     end


                    
#                 end
#             end
#         end
#     end


#     F = A \ b 

#     fijk=zeros(N,N,N,g)
#     for i=1:N^3*g 
#         gamma=ceil(Int, i/(N^3))
#         Sum = i-N^3*(gamma-1)
#         index1 = ceil(Int, Sum/(N^2))
#         Sum = Sum - N^2*(index1-1)
#         index2 = ceil(Int, Sum/N)
#         Sum = Sum - N*(index2-1)
#         index3 = Sum
#         fijk[index1,index2,index3,gamma]=F[i]
#     end
#     return fijk


# end







include("fij_d_file.jl")

using SparseArrays, LinearAlgebra, IterativeSolvers

function fijk_d(w, u, t, n)
    s = size(w)
    N = s[1]
    g = s[3]
    d_val = 1/(n-1)  # 最小精度（如果需要）
    
    # 归一化 w
    for gamma = 1:g 
        for i = 1:N 
            row_sum = sum(w[i, :, gamma])
            if row_sum > 0
                w[i, :, gamma] ./= row_sum
            end
        end
    end

    # 计算 e 矩阵
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

    total_size = N^3 * g
    # 初始化稀疏矩阵三元组
    I_idx = Int[]
    J_idx = Int[]
    V_val = Float64[]
    b = zeros(total_size)
    
    # 预计算 fij (假设 fij_d_PC 已优化)
    fij = fij_d(w, u, t, n)
    
    for beta = 1:g 
        for i = 1:N 
            for j = 1:N 
                for k = 1:N 
                    row = N^3 * (beta - 1) + N^2 * (i - 1) + N * (j - 1) + k 
                    
                    # 处理特殊情况
                    if i == j && j == k 
                        # 对角元素设为 1
                        push!(I_idx, row)
                        push!(J_idx, row)
                        push!(V_val, 1.0)
                        b[row] = 1
                        continue
                    end
                    
                    if i == j 
                        push!(I_idx, row)
                        push!(J_idx, row)
                        push!(V_val, 1.0)
                        b[row] = fij[i, k, beta]
                        continue
                    end
                    
                    if j == k 
                        push!(I_idx, row)
                        push!(J_idx, row)
                        push!(V_val, 1.0)
                        b[row] = fij[i, j, beta]
                        continue
                    end
                    
                    if i == k 
                        push!(I_idx, row)
                        push!(J_idx, row)
                        push!(V_val, 1.0)
                        b[row] = fij[i, j, beta]
                        continue
                    end
                    
                    # 通用情况 (i, j, k 互不相同)
                    # 对角线元素
                    push!(I_idx, row)
                    push!(J_idx, row)
                    push!(V_val, 1.0)
                    
                    # 非对角线元素
                    for alpha = 1:g 
                        for x = 1:N 
                            # 第一项: -q[alpha,beta]*e[x,i,alpha]*(1-u)
                            col1 = (alpha - 1) * N^3 + (x - 1) * N^2 + (j - 1) * N + k 
                            val1 = -q[alpha, beta] * e[x, i, alpha] * (1 - u)
                            if val1 != 0
                                push!(I_idx, row)
                                push!(J_idx, col1)
                                push!(V_val, val1)
                            end
                            
                            # 第二项: -q[alpha,beta]*e[x,j,alpha]*(1-u)
                            col2 = (alpha - 1) * N^3 + (i - 1) * N^2 + (x - 1) * N + k 
                            val2 = -q[alpha, beta] * e[x, j, alpha] * (1 - u)
                            if val2 != 0
                                push!(I_idx, row)
                                push!(J_idx, col2)
                                push!(V_val, val2)
                            end
                            
                            # 第三项: -q[alpha,beta]*e[x,k,alpha]*(1-u)
                            col3 = (alpha - 1) * N^3 + (i - 1) * N^2 + (j - 1) * N + x 
                            val3 = -q[alpha, beta] * e[x, k, alpha] * (1 - u)
                            if val3 != 0
                                push!(I_idx, row)
                                push!(J_idx, col3)
                                push!(V_val, val3)
                            end
                        end
                        
                        # 第四项: -q[alpha,beta]*(1-3/N)
                        col4 = (alpha - 1) * N^3 + (i - 1) * N^2 + (j - 1) * N + k 
                        val4 = -q[alpha, beta] * (1 - 3/N)
                        if val4 != 0
                            push!(I_idx, row)
                            push!(J_idx, col4)
                            push!(V_val, val4)
                        end
                    end
                    
                    # 设置右侧向量
                    b_val = 0.0
                    for alpha = 1:g 
                        b_val += u / (n * N) * q[alpha, beta] * 
                                (fij[j, k, alpha] + fij[i, k, alpha] + fij[i, j, alpha])
                    end
                    b[row] = b_val
                end
            end
        end
    end

    # 创建稀疏矩阵
    A_sparse = sparse(I_idx, J_idx, V_val, total_size, total_size)
    # println("稀疏矩阵构建完成: $total_size×$total_size, 非零元素: ", 
    #         nnz(A_sparse), " (", round(100 * nnz(A_sparse)/total_size^2, digits=4), "%)")
    
    # 使用 IDRS 求解
    maxiter = 1000
    tol = 1e-6
    # F_vec = idrs(A_sparse, b; maxiter=maxiter, tol=tol)


    Initial_Vec = ones(N^3*g,1)
    Initial_Vec = vec(Initial_Vec)
    F_vec = idrs!(Initial_Vec, A_sparse, b) 
    
    # 重构四维张量
    fijk = zeros(N, N, N, g)
    for idx = 1:total_size
        gamma = ceil(Int, idx / N^3)
        remainder = idx - (gamma - 1) * N^3
        i = ceil(Int, remainder / N^2)
        remainder -= (i - 1) * N^2
        j = ceil(Int, remainder / N)
        k = remainder - (j - 1) * N
        fijk[i, j, k, gamma] = F_vec[idx]
    end
    
    return fijk
end