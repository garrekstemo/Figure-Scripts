using CairoMakie
using GLMakie
include("functions.jl")

νs = -30:0.1:30
A = 1
ν0 = 0
Γ = 0.5
n_bg = 1.5

ε1 = real(lorentzian.(νs, ν0, A, Γ)) .+ n_bg^2
ε2 = imag(lorentzian.(νs, ν0, A, Γ))
n_medium = @. sqrt((sqrt(abs2(ε1) + abs2(ε2)) + ε1) / 2)
k_medium = @. sqrt((sqrt(abs2(ε1) + abs2(ε2)) - ε1) / 2)

fig = Figure()
ax = Axis(fig[1, 1], xlabel = "Frequency", ylabel = "n(ν), κ(ν)")
lines!(νs, n_medium .- n_bg, label = "n")
lines!(νs, k_medium, label = "κ")

axislegend(ax)

fig

##
save("figures/index_extinction.pdf", fig, backend = CairoMakie)