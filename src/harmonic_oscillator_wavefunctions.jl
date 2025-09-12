using CairoMakie
using GLMakie
using ClassicalOrthogonalPolynomials
GLMakie.activate!()

ns = 0:5
potential = @. sqrt(2 * (ns + 0.5))
energies = ns .+ 0.5
L = 5
q = -L:0.01:L

ψs = []
for n in 0:5
    ψ = @. hermiteh(n, q) * exp(-0.5 * q^2) / sqrt(2^n * factorial(n) * sqrt(pi))
    push!(ψs, ψ)
end




fig = Figure()
ax = Axis(fig[1, 1], xlabel = "q")

yoffset = 0.1
lines!(q, 0.5 .* q .^2 .+ yoffset, color = :gray10)

xlims!(-8, 8)
ylims!(0, 7)

xmin = ax.limits[][1][1]
xmax = ax.limits[][1][2]
xrange = xmax - xmin
xmins = @. (-potential - xmin) / xrange
xmaxes = @. (potential - xmin) / xrange
hlines!(energies .+ yoffset, xmin = xmins, xmax = xmaxes, color = :black)

scale = 0.6
for (i, ψ) in enumerate(ψs)
    ρ = ψ .^ 2
    lines!(q, scale * ψ .+ energies[i] .+ yoffset, linewidth = 2, color = :deepskyblue4)
    band!(q, scale * ψ .+ energies[i] .+ yoffset, energies[i] .+ yoffset, color = (:deepskyblue3, 0.5))
end


hlines!(0, color = :black, linewidth = 3)
vlines!(0, color = :black, linewidth = 1)
hideydecorations!(ax)
hidexdecorations!(ax, label = false, ticks = false, ticklabels = false)
hidespines!(ax)

fig

##
save("figures/QHO_wavefunctions.pdf", fig, backend = CairoMakie)