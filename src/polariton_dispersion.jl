using DelimitedFiles
using GLMakie
using CairoMakie
include("functions.jl")
GLMakie.activate!()

function cavity_mode_energy(θs, E_0, n)
    E_c = Float64[]
    for θ_i in θs
        E_ci = E_0 / sqrt(1 - sin(θ_i)^2 / n^2)
        push!(E_c, E_ci)
    end
    return E_c
end

function polariton_branches(θs, E_v, E_0, n, Ω, branch = 1)
    E = Float64[]
    E_c = cavity_mode_energy(θs, E_0, n)

    if branch == 1
        for i in eachindex(θs)
            E_i = 0.5 * (E_v + E_c[i] - sqrt(Ω^2 + (E_c[i] - E_v)^2)) 
            push!(E, E_i)
        end
    elseif branch == 2
        for i in eachindex(θs)
            E_i = 0.5 * (E_v + E_c[i] + sqrt(Ω^2 + (E_c[i] - E_v)^2))
            push!(E, E_i)
        end
    end
    
    return E
end

# Generate fake data here by setting n, E_v, E_0, and Ω,
# which students must find by writing a fitting procedure.
E_v = 2000
E_0 = 1960
n = 1.5
Ω = 100

θs = range(-70, 70, length = 1000)
θsrad = deg2rad.(θs)
Ec = cavity_dispersion.(θsrad, E_0, n)
LP = coupled_energies.(Ec, E_v, Ω, 1)
UP = coupled_energies.(Ec, E_v, Ω, 2)

fig = Figure()
ax = Axis(fig[1, 1],
    xlabel = "Angle (degree)",
    ylabel = "Energy",
    xticks = [-60, -30, 0, 30, 60],
    xtickalign = 1,
    aspect = 1
)

lines!(θs, LP, color = :black)
lines!(θs, UP, color = :black)
lines!(θs, Ec, linestyle = :dash, color = :deepskyblue3)
hlines!(E_v, color = :firebrick3, linestyle = :dash)

ylims!(1900, 2210)

hidexdecorations!(ax, label = false, ticks = false, ticklabels = false)
hideydecorations!(ax, label = false, )

fig
##
save("figures/polariton_dispersion.pdf", fig, backend = CairoMakie)