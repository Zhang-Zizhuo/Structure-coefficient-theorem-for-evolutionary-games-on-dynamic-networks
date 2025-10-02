include("V_d_file.jl")
include("fij_d_file.jl")
include("fijk_d_file.jl")
using LinearAlgebra
function Lambda_d(w,u,t)
    n=3
    s=size(w)
    N=s[1]
    g=s[3]

    for gamma=1:g 
        for i=1:N 
            w[i,:,gamma].=w[i,:,gamma]./sum(w[i,:,gamma])
        end
    end
    # 时序网络
    # q=zeros(g,g)
    # for i=1:g-1
    #     q[i,i+1]=1
    # end
    # q[g,1]=1
    # q = [ 1-t/N   t/N
    #        t/N   1-t/N]
    q = zeros(g,g)
    for i=1:g 
        for j=1:g 
            if i==j 
                q[i,j] = 1 - t/N 
            else 
                q[i,j] = t/N/(g-1)
            end
        end
    end

    v=ones(1,g)
    v.=v./sum(v)

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

    value = V_d(w,u,t)

    f2 = fij_d(w,u,t,n)

    f3 = fijk_d(w,u,t,n)

    x1=-n^2
    x2=n^2*(1-u)
    x3=n
    x4=n
    x5=-n*(1-u)
    x6=-n*(1-u)
    x7=n*u
    x8=-2*u

    x=[x1,x2,x3,x4,x5,x6,x7,x8]

    s0=0
    for beta=1:g 
        for alpha=1:g 
            for i=1:N 
                for j=1:N 
                    for k=1:N 
                        for l=1:N 
                            y = [f3[i,k,l,beta], f3[j,k,l,beta], f2[i,k,beta], f2[i,l,beta], f2[j,k,beta], f2[j,l,beta], f2[k,l,beta], 1]
                            f_phi = dot(x,y)/(n-1)/(n-2)
                            s0 += 1/g*q[alpha,beta]*w[k,l,beta]*value[i,alpha]*m[j,i,k,beta]*f_phi
                        end
                    end
                end
            end
        end
    end
    L1 = s0


    
    x1=-n^2;
    x2=n^2*(1-u);
    x3=n;
    x4=n*(n-1);
    x5=-n*(1-u);
    x6=-n*(n-1)*(1-u);
    x7=n*u;
    x8=-n*u;

    x=[x1,x2,x3,x4,x5,x6,x7,x8]

    s0=0
    for beta=1:g 
        for alpha=1:g 
            for i=1:N 
                for j=1:N 
                    for k=1:N 
                        for l=1:N 
                            y = [f3[i,k,l,beta], f3[j,k,l,beta], f2[i,k,beta], f2[i,l,beta], f2[j,k,beta], f2[j,l,beta], f2[k,l,beta], 1]
                            f_phi = dot(x,y)/(n-1)/(n-2)
                            s0 += 1/g*q[alpha,beta]*w[k,l,beta]*value[i,alpha]*m[j,i,k,beta]*f_phi
                        end
                    end
                end
            end
        end
    end
    L2 = s0


    x1=2*n^2;
    x2=-2*n^2*(1-u);
    x3=-n^2;
    x4=-n^2;
    x5=n^2*(1-u);
    x6=n^2*(1-u);
    x7=-2*n*u;
    x8=2*n*u;

    x=[x1,x2,x3,x4,x5,x6,x7,x8]

    s0=0
    for beta=1:g 
        for alpha=1:g 
            for i=1:N 
                for j=1:N 
                    for k=1:N 
                        for l=1:N 
                            y = [f3[i,k,l,beta], f3[j,k,l,beta], f2[i,k,beta], f2[i,l,beta], f2[j,k,beta], f2[j,l,beta], f2[k,l,beta], 1]
                            f_phi = dot(x,y)/(n-1)/(n-2)
                            s0 += 1/g*q[alpha,beta]*w[k,l,beta]*value[i,alpha]*m[j,i,k,beta]*f_phi
                        end
                    end
                end
            end
        end
    end
    L3 = s0

    L = [L1,L2,L3]

    return L







    


end