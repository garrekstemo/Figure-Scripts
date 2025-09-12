using CairoMakie
using GLMakie
GLMakie.activate!()

L = 1
n_max = 3
x = range(0, stop = 2L, length = 500)
sines = [sin.(π * x * n / 2L) for n in 1:n_max]


fig = Figure()
ax = Axis(fig[1, 1])

offset = 3
for i in eachindex(sines)
    lines!(x, sines[i] .+ offset * i, linewidth = 3, color = :deepskyblue3)
    lines!(x, -sines[i] .+ offset * i, linewidth = 3, color = :deepskyblue3)
end
vlines!([0, 2L], color = :black, linewidth = 10)

hidedecorations!(ax)
hidespines!(ax)
fig

##
save("figures/standing_waves.pdf", fig, backend = CairoMakie)