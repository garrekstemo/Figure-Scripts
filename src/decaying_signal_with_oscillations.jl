using CairoMakie
using GLMakie

t = 0:0.01:8π
y = @. 1/3 * exp(-t / 1.9) * sin(4t) + 1 / (1 + (0.5/t)^3) * exp(-t / 5)

fig = Figure(background = :transparent)
ax = Axis(fig[1, 1], backgroundcolor = :transparent)

lines!(t, y, color = :black)

# hidedecorations!(ax)

fig

##
save("figures/exponential_decay_with_oscillations.pdf", fig, backend = CairoMakie)