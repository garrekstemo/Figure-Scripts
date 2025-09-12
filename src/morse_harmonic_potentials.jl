using CairoMakie
using GLMakie

const u = 1.6605390666e-27  # atomic mass constant
const c_0 = 299_792_458
const h = 6.62607015e-34
const ħ = h / 2π
const joules = 100 * h * c_0

function morse_potential(qs, λ)
    @. 0.5 * λ * (1 - exp(-qs / sqrt(λ)))^2
end

function morse_energies(ns, λ)
    @. (ns + 0.5) - (ns + 0.5)^2 / (2 * λ)
end

function endpoints(energy, λ)
    b = @. sqrt(2 * energy / λ)
    left = @. -sqrt(λ) * log(1 + b)
    right = @. -sqrt(λ) * log(1 - b)
    return left, right
end

λ = 7
ns = 0:λ
q = -10:0.01:30

morse = morse_energies(ns, λ)
harmonic_energies = @. sqrt(2 * (ns + 0.5))
harmonic_levels = ns .+ 0.5

fig = Figure(fontsize = 18)

# ax = Axis(fig[1, 1], xlabel = "Q", ylabel = "V(Q)")
ax = Axis(fig[1, 1], xlabel = "Interatomic separation", ylabel = "Energy", backgroundcolor = :transparent)

xlims!(-3, 13)
ylims!(0, 4)

xrange = @lift($(ax.limits)[1][2] - $(ax.limits)[1][1])
xmin_h = @lift((-harmonic_energies .- $(ax.limits)[1][1]) ./ $xrange)
xmax_h = @lift((harmonic_energies .- $(ax.limits)[1][1]) ./ $xrange)
xmin_m = @lift([(endpoints(morse, λ)[2][i] - $(ax.limits)[1][1]) / $xrange for i in eachindex(morse)])
xmax_m = @lift([(endpoints(morse, λ)[1][i] - $(ax.limits)[1][1]) / $xrange for i in eachindex(morse)])
# hlines!(harmonic_levels, xmin = xmin_h, xmax = xmax_h, color = :deepskyblue4, linewidth = 1, linestyle = :dash, visible = true)
# lines!(q, 0.5 .* q .^2, color = :deepskyblue4, linewidth = 2, linestyle = :dash)
hlines!(morse, xmin = xmin_m, xmax = xmax_m, color = :firebrick4, linewidth = 1, visible = true)
lines!(q, morse_potential(q, λ), color = :firebrick4, linewidth = 2)

hideydecorations!(ax, label=false)
hidexdecorations!(ax, label=false)

fig

##
save("figures/morse_potential_simple.pdf", fig, backend = CairoMakie)