
# Find colors here:
# https://juliagraphics.github.io/Colors.jl/latest/namedcolors/

"""
    theme_curvesonly()

Theme that only displays the function curves 
and removes all spines, labels, and other axis attributes.
"""
function theme_curvesonly()
    Theme(
        # backgroundcolor = :blue,
        Lines = (cycle = nothing, color = :black),

        Axis = (
            backgroundcolor = :transparent,
            xgridvisible = false,
            ygridvisible = false,
            xminorgridvisible = false,
            yminorgridvisible = false,
            leftspinevisible = false,
            rightspinevisible = false,
            bottomspinevisible = false,
            topspinevisible = false,
            xminorticksvisible = false,
            yminorticksvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            xticklabelsvisible = false,
            yticklabelsvisible = false,
        ),
)
end

function theme_purples()
    Theme(
        palette = (
            color = [:purple, :violet, :plum, :orchid, :thistle, :lavender],
            patchcolor = [:purple, :violet, :plum, :orchid, :thistle, :lavender],
        )
    )
end