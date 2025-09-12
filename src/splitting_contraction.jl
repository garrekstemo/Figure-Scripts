using CairoMakie
using GLMakie
include("functions.jl")
GLMakie.activate!()


n_bg = 1.5
A_0 = 2.5e4
A_0_on = A_0 * 0.98
ω_0 = 2000
Γ = 15
L = 12e-4
R = 0.8
ϕ = 11.93
ωs = range(ω_0 - 150, ω_0 + 150, length = 1000)

# Calculate pump off dielectric function, refractive index, and absorption coefficient
ε1 = dielectric_real.(ωs, ω_0, A_0, Γ) .+ n_bg^2
ε2 = dielectric_imag.(ωs, ω_0, A_0, Γ)
n = @. sqrt((ε1 + sqrt(ε1^2 + ε2^2)) / 2)
α = @. 4 * π * ωs * sqrt((-ε1 + sqrt(ε1^2 + ε2^2)) / 2)

# Calculate pump on dielectric function, refractive index, and absorption coefficient
ε1_on = dielectric_real.(ωs, ω_0, A_0_on, Γ) .+ n_bg^2
ε2_on = dielectric_imag.(ωs, ω_0, A_0_on, Γ)
n_on = @. sqrt((ε1_on + sqrt(ε1_on^2 + ε2_on^2)) / 2)
α_on = @. 4 * π * ωs * sqrt((-ε1_on + sqrt(ε1_on^2 + ε2_on^2)) / 2)

# Calculate transmittance
T = cavity_transmittance.(ωs, n, α, Ref([L, R, ϕ]))
T_on = cavity_transmittance.(ωs, n_on, α_on, Ref([L, R, ϕ]))


fig = Figure()

ax1 = Axis(fig[1, 1], ylabel = "ΔA")
hlines!(0, linewidth = 1, color = :black)
lines!(ωs, T .- T_on)


axl = Axis(fig[2, 1], 
    xlabel = "Frequency (cm⁻¹)", 
    ylabel = "Transmittance",
    )
lines!(ωs, T, color = :indigo)
axr = Axis(fig[2, 1], ylabel = "Absorbance",
    yaxisposition = :right,
    leftspinecolor = :indigo,
    rightspinecolor = :firebrick3,
)
lines!(ωs, α, color = :firebrick3)

ylims!(axl, 0, 0.5)
ylims!(axr, 0, 1.1e4)

hidedecorations!(ax1, label = false)

hidedecorations!(axl, label = false)
hidexdecorations!(axr)
hideydecorations!(axr, label = false)

fig
##
save("figures/splitting_contraction.pdf", fig, backend = CairoMakie)