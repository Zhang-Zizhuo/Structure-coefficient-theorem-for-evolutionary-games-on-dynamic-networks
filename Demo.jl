# This script computes the cooperation frequency on a simple dynamic network using both analytical

# theory and Monte Carlo simulations.

#

# It outputs the theoretical prediction and the corresponding simulation estimate for comparison.

# Close agreement between them supports the accuracy of the theoretical approximation.

#

# Increasing `maxLoop` and `maxIter` improves the accuracy of the simulation estimate, but also

# increases the computational time.



include("Structure_Coefficients_of_Dynamic_Networks.jl")
include("Simulation.jl")
N = 6

# A ring graph
w1 = zeros(N,N)
for i = 1:N-1
    w1[i,i+1] = 1
    w1[i+1,i] = 1
end
w1[1,N] = 1
w1[N,1] = 1

# A star graph
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

delta = 0.002  # selection intensity
n = 2  # number of strategies
b = 4  # benefit 
c = 1  # cost 
A = [b-c  -c   # payoff matrix of a donation game
      b   0]

# Payoff-average terms (see Eq.3 in the main text)
a_11 = b-c            # a_{11}
a_1s = (b - 2*c) / 2  #  \bar{a_{1*}}
a_s1 = (2*b - c) / 2  #  \bar{a_{*1}}
a_ss = (b - c) / 2    #  \bar{a_{**}}
a = (2*b - 2*c) / 4   #  \bar{a}
fc = 1/2 + delta * ( Lambda[1]*(a_11 - a_ss) + Lambda[2]*(a_1s - a_s1) + Lambda[3]*(a_1s - a) )

println("Theoretical cooperation frequency (c=$(c), b=$(b), delta=$(delta)):  fc = $(fc)")

# maxLoop = 10
# maxIter = 10^8

# frequency_vector = game_on_dynamic_network(w, u, q, delta, maxLoop, maxIter, A)
# println("Frequency of cooperation in a Monte Carlo simulation: ", frequency_vector[1])

maxLoop = 10
maxIter = 10^8

println("Starting Monte Carlo simulation. This may take a few minutes for a large number of iterations.")

frequency_vector = game_on_dynamic_network(w, u, q, delta, maxLoop, maxIter, A)

println("Monte Carlo simulation completed.")
println("Frequency of cooperation in a Monte Carlo simulation: ", frequency_vector[1])
