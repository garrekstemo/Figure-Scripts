using CairoMakie
using GLMakie

ns = 0:5
potential = @. sqrt(2 * (ns + 0.5))
energies = ns .+ 0.5
q = -10:0.01:10

fig = Figure()
ax = Axis(fig[1, 1], xlabel = "Q", ylabel = "Energy")

yoffset = 0.1
lines!(q, 0.5 .* q .^2 .+ yoffset, color = :black)

xlims!(-8, 8)
ylims!(0, 7)

xmin = ax.limits[][1][1]
xmax = ax.limits[][1][2]
xrange = xmax - xmin
xmins = @. (-potential - xmin) / xrange
xmaxes = @. (potential - xmin) / xrange
hlines!(energies .+ yoffset, xmin = xmins, xmax = xmaxes, color = :black)

hidedecorations!(ax)
hidespines!(ax)

fig

##
save("figures/harmonic_oscillator.pdf", fig, backend = CairoMakie)