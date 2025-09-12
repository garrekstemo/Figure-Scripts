using CairoMakie
using GLMakie
GLMakie.activate!()

function lorentz2d(x, y, A, ω_0, Γ)
    data = zeros(length(x), length(y))
    for i in eachindex(x)
        for j in eachindex(y)
            data[i, j] = A * Γ / ((x[i] - ω_0[1])^2 + (y[j] - ω_0[2])^2 + Γ^2)
        end
    end
    data
end

x = -2.3:0.01:1.9
Γ = 0.2
A = 1

ω_diag = [(1, 1), (-1, 1), (-1, -1), (1, -1)]
ω_offdiag = [ω .- (0.5, 0) for ω in ω_diag]
z = sum(-lorentz2d(x, x, A, ω, Γ) for ω in ω_diag) + sum(lorentz2d(x, x, A, ω, Γ) for ω in ω_offdiag)


fig = Figure()

ax = Axis(fig[1, 1],
    title = "2D IR spectrum with off-diagonal features",
    xlabel = "Probe frequency (cm⁻¹)",
    ylabel = "Pump frequency (cm⁻¹)",
    xticks = ([-1, 1], ["ω₁", "ω₂"]),
    yticks = ([-1, 1], ["ω₁", "ω₂"]),
    )
ct = contourf!(x, x, z, levels = 15, colormap = :Egypt)
lines!(x, x, color = :black, linestyle = :dash, linewidth = 2)
Colorbar(fig[1, 2], ct)
colsize!(fig.layout, 1, Aspect(1, 1.0))

hidedecorations!(ax, label = false, ticks = false, ticklabels = false)

fig

##
save("figures/2DIR_spectrum.pdf", fig, backend = CairoMakie)