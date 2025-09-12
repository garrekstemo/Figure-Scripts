using CairoMakie
using GLMakie

τ1 = 20
τ2 = 10
τ3 = 15
A2 = 4
ts = 0:0.1:100
y1 = @.  1 / (1 + (τ3 / ts)^3) * exp(-ts / τ1)
y2 = @.  A2 * (1 - exp(-ts / τ1)) * exp(-ts / τ2)

fig = Figure(background = :transparent)
ax = Axis(fig[1, 1], backgroundcolor = :transparent)

lines!(ts, y1)
lines!(ts, y2)

hidedecorations!(ax)

fig

##
save("figures/rise_and_decay.pdf", fig, backend = CairoMakie)