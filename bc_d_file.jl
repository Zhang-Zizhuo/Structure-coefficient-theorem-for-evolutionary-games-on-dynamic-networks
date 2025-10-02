include("fij_d_file.jl")
include("V_d_file.jl")
function bc_d(w,u,t)

    w = copy(w)
    s=size(w)
    N=s[1]
    g=s[3]

    for gamma=1:g 
        for i=1:N 
            w[i,:,gamma].=w[i,:,gamma]./sum(w[i,:,gamma])
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

    n = 2
    f2 = fij_d(w,u,t,n)
    # println("bc_d里面fij可以正常算")
    value = V_d(w,u,t)

    m=zeros(N,N,N,g);

    for gamma=1:g 
        for i=1:N 
            for j=1:N 
                for k=1:N 
                    if i==j 
                        m[i,j,k,gamma]=0
                    else
                        if k==i 
                            m[i,j,k,gamma]=(w[j,i,gamma]-w[j,i,gamma]^2)/N 
                        elseif k==j 
                            m[i,j,k,gamma]=0
                        else
                            m[i,j,k,gamma]=-w[j,i,gamma]*w[j,k,gamma]/N 
                        end
                    end
                end
            end
        end
    end

    s = ones(1,g)/g 
    
    
    K1 = 0 
    for alpha = 1:g 
        for beta = 1:g 
            for i = 1:N 
                for j = 1:N 
                    for k = 1:N 
                        for l = 1:N 
                            f_phi = -2*f2[i,l,beta]+2*(1-u)*f2[j,l,beta]+u 
                            K1 += s[beta]*q[alpha,beta]*value[i,alpha]*m[j,i,k,beta]*w[k,l,beta]*f_phi
                        end
                    end
                end
            end
        end
    end
    K1 /= 2

    K2 = 0
    for alpha = 1:g 
        for beta = 1:g 
            for i = 1:N 
                for j = 1:N 
                    for k = 1:N 
                        for l = 1:N 
                            f_phi = -2*f2[i,k,beta]+2*(1-u)*f2[j,k,beta]+u 
                            K2 += s[beta]*q[alpha,beta]*value[i,alpha]*m[j,i,k,beta]*w[k,l,beta]*f_phi
                        end
                    end
                end
            end
        end
    end
    K2 /= 2

    bc = K2 / K1
    # println("K1")
    # println(K1/2)
    # println("K2")
    # println(K2/2)

    # return bc 
    #   之前一致 return bc, 可能已经在别的地方用到了，谨慎使用
    vec = [bc K1 K2]
    return vec
end 



