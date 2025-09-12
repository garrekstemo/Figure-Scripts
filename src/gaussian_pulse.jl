using CairoMakie
using GLMakie
include("functions.jl")
GLMakie.activate!()

f = 4
ϕ = 0
x = -10:0.005:10
envelope = gauss.(x, 0, 1, 2)
y = envelope .* sin.(f * x .+ ϕ)

fig = Figure(size = (1000, 500))
ax = Axis(fig[1, 1], backgroundcolor = :transparent)

lines!(x, y, linewidth = 5, color = :deepskyblue3)
lines!(x, envelope, linewidth = 5, color = :gray30)

hidedecorations!(ax)
hidespines!(ax)

fig

##
save("figures/gaussian_pulse.pdf", fig, backend = CairoMakie)