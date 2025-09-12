using GLMakie
include("functions.jl")
include("custom_themes.jl")
set_theme!(theme_purples())

# Find colors here
# https://juliagraphics.github.io/Colors.jl/latest/namedcolors/


fig = Figure(fontsize = 16, size = (500, 1000))

Label(fig[0, 1], "A particular theme for a particular person", tellwidth = false)

# With latex fonts
Axis(fig[1, 1], title = "Change \"color\" in palette = (color = [...])", 
    xlabel = L"x",
    ylabel = L"e^{-(x - x_0)^2 / 2σ^2}")
for i in 1:6
    lines!(gauss.(-10:0.5:40, 4i, 1, 3))
end

Axis(fig[2, 1], title = "Requires changing \"patchcolor\" in\npalette = (patchcolor = [...])", xlabel = L"x", ylabel = L"ρ(x)")

for i in 1:6
    density!(randn(50) .+ 2i)
end

cycle = [:navy, :royalblue, :steelblue, :dodgerblue, :cornflowerblue, :skyblue, :aliceblue, :deepskyblue3]
Axis(fig[3, 1],
    palette = (patchcolor = cycle,),
    title = "Overriding the theme colors with blues\n(where :deepskyblue3 is objectively\nthe best color in the universe)",
    xlabel = "X",
    ylabel = "ρ(X)")
for i in 1:length(cycle)
    density!(randn(50) .+ 3i)
end


fig
##
save("figures/custom_theme_example.pdf", fig, backend = CairoMakie)