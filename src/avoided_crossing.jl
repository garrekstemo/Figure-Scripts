using CairoMakie
using GLMakie
GLMakie.activate!()

function coupled_energies(Δk, p, branch = 0)
    m, k, k3 = p
    ω1 = sqrt(k / m)
    ω2 = sqrt.((k .+ Δk) / m)
    Ω = sqrt(k3^2 / m^2) ./ sqrt.(ω1 * ω2)
    if branch == 0
        return @. 0.5 * (ω1^2 + ω2^2 + sqrt((ω1^2 - ω2^2)^2 + 4 * Ω^2 * ω1 * ω2))
    elseif branch == 1
        return @. 0.5 * (ω1^2 + ω2^2 - sqrt((ω1^2 - ω2^2)^2 + 4 * Ω^2 * ω1 * ω2))
    end
end


m = 1
k = 1
k3 = 0.09 * k
Δk = -k:0.01:k

fig = Figure()
ax = Axis(fig[1, 1], xlabel = "Δk / k₀", ylabel = "ω / ω₀")
lines!(Δk ./ k, coupled_energies(Δk, [m, k, k3], 0) ./ sqrt(k / m), label = "ω₊/ω₀")
lines!(Δk ./ k, coupled_energies(Δk, [m, k, k3], 1) ./ sqrt(k / m), label = "ω₋/ω₀")
hlines!(k, color = :black, linestyle = :dash)
axislegend(ax, position = :lt)

fig

##
save("figures/spring_dispersion.pdf", fig, backend = CairoMakie)