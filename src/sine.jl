using CairoMakie
using GLMakie
GLMakie.activate!()
include("custom_themes.jl")
set_theme!(theme_curvesonly())

fig = Figure(background = :transparent)
ax = Axis(fig[1, 1], backgroundcolor = :transparent)

lines!(sin.(0:0.01:8π), color = :black, linewidth = 7)

hidedecorations!(ax)

fig

##
save("figures/sine_curve.pdf", fig, backend = CairoMakie)