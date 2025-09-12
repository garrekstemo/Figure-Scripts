using TransferMatrix
using Optim
using Peaks
using CairoMakie
using GLMakie
include("functions.jl")
GLMakie.activate!()

function sqr_err(p, X, Y)
    E_c0, E_v, n, V = p
    E_c = cavity_dispersion.(X, E_c0, n)
    up = coupled_energies.(E_c, E_v, V, 1)
    lp = coupled_energies.(E_c, E_v, V, 0)

    error = 0
    error += sum(abs2, Y[:, 1] .- up) + sum(abs2, Y[:, 2] .- lp)
    return error
end

λ_0 = 1
λ_start = λ_0 - 0.05
λ_end = λ_0 + 0.03
λs = range(λ_start, λ_end, length = 200)
θs = range(0, 30, length = 100)  # degrees
νs = 10^4 ./ λs

# Layer thicknesses
n1 = 2.0
n2 = 1.5
n_bg = 1  # Background refractive index

t1 = λ_0 / (4 * n1[1])
t2 = λ_0 / (4 * n2[1])
t_cav = λ_0 / (2 * n_bg) + 0.04

# Absorbing material parameters
A_0 = 1e5
ν_0 = 10^4 / λ_0
Γ_0 = 30
ε1 = dielectric_real.(νs, ν_0, A_0, Γ_0) .+ n_bg^2
ε2 = dielectric_imag.(νs, ν_0, A_0, Γ_0)
n_medium = @. sqrt((sqrt(abs2(ε1) + abs2(ε2)) + ε1) / 2)
k_medium = @. sqrt((sqrt(abs2(ε1) + abs2(ε2)) - ε1) / 2)

# Construct layers
air = Layer(λs, ones(length(λs)), zeros(length(λs)), 1)  # thickness is arbitrary for semi-infinite layers
material1 = Layer(λs, fill(n1, length(λs)), zeros(length(λs)), t1)
material2 = Layer(λs, fill(n2, length(λs)), zeros(length(λs)), t2)
absorbing_layer = Layer(λs, n_medium, k_medium, t_cav)

nperiods = 6
unit = [material1, material2]
layers = [air, repeat(unit, nperiods)..., absorbing_layer, repeat(reverse(unit), nperiods)..., air]

# Calculate angle-resolved spectrum
res = angle_resolved(λs, deg2rad.(θs), layers)


# Create figure
fig = Figure(size = (800, 400), fontsize = 18)

ax1 = Axis(fig[1, 1],
    xlabel = "Frequency (cm⁻¹)",
    ylabel = "Transmittance (arb.)",
    backgroundcolor = :transparent)

peak_frequencies = []
θ_plot = []
offset = 0.7
interval = round(Int, length(θs) / 8)
count = 0  # Needed to offset each spectrum

for (i, Tpp) in enumerate(eachrow(res.Tpp))

    # Only plot a few angles to reduce clutter
    if mod(i, interval) == 0 && (θs[i] < 20) && (θs[i] > 5)
        peaks, vals = findmaxima(Tpp)
        push!(peak_frequencies, 10^4 ./ (λs[peaks]))
        push!(θ_plot, θs[i])
        lines!(νs, Tpp .+ count * offset, color = :indigo, label = "θ = $(θs[i])°")
        text!(10350, count * offset + 0.05, text="θ ≈ $(round(Int, θs[i]))°")
        count += 1
    end
end

p0 = [10000, 10000, 1.0, 100.0]
peaks = reduce(hcat, peak_frequencies)'
fit = optimize(p -> sqr_err(p, deg2rad.(θ_plot), peaks), p0)
params = Optim.minimizer(fit)
cavity = cavity_dispersion.(deg2rad.(θs), params[1], params[3])
lp = coupled_energies.(cavity, params[2], params[4], 0)
up = coupled_energies.(cavity, params[2], params[4], 1)


ax2 = Axis(fig[1, 2], xlabel = "Incidence angle (°)", ylabel = "Frequency (cm⁻¹)")

heatmap!(θs, νs, res.Tpp, colormap = :tempo)
hlines!(ν_0, color = :orangered, linestyle = :dash, linewidth = 3)
lines!(θs, cavity, color = :dodgerblue, linestyle = :dash, linewidth = 3)
lines!(θs, lp, color = :magenta2, linestyle = :dash, linewidth = 3)
lines!(θs, up, color = :magenta2, linestyle = :dash, linewidth = 3)

text!(ax1, 0.2, 0.9, text="LP", space = :relative)
text!(ax1, 0.7, 0.9, text="UP", space = :relative)

text!(ax2, 0.8, 0.55, text = "Photon", rotation = deg2rad(46), color = :dodgerblue, space = :relative)
text!(ax2, 0.7, 0.37, text = "Molecule", color = :orangered, space = :relative)
text!(ax2, 0.7, 0.8, text = "UP", color = :magenta2, space = :relative)
text!(ax2, 0.5, 0.17, text = "LP", color = :magenta2, space = :relative)

resize_to_layout!(fig)
fig

##
save("figures/polariton_dispersion_cascade_TMM.pdf", fig, backend = CairoMakie)