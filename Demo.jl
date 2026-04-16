include("Structure_Coefficients_of_Dynamic_Networks.jl")

N = 6
w1 = zeros(N,N)
for i = 1:N-1
    w1[i,i+1] = 1
    w1[i+1,i] = 1
end
w1[1,N] = 1
w1[N,1] = 1

w2 = zeros(N,N)
w2[1, 2:N] .= 1
w2[2:N, 1] .= 1

# A dynamic network of size N = 6 composed of two static counterparts, a ring and a star graph
w = zeros(N,N,2)
w[:,:,1] .= w1 
w[:,:,2] .= w2

u = 0.01  # mutation rate

t = 10   # rescaled duration
q = [ 1-1/(t*N)  1/(t*N)      # Transition probability matrix of networks
      1/(t*N)  1-1/(t*N) ]

Lambda = Structure_Coefficients(w, u, q)
println("Structure coefficients of the dynamic network: ", Lambda)

K1 = (Lambda[1] - Lambda[2]) / 4
K2 = sum(Lambda) / 4
bc = K2 / K1
println("Critical benefit-to-cost ratio for cooperation:   (b/c)* = ", bc)