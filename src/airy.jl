using GLMakie

airy(ϕ, R, T, α, l) = T^2 / (1 + R^2 * exp(-4α * l) - 2R * exp(-2α * l) * cos(2ϕ))

ϕ = range(-π/2, stop = 3π/2, length = 500)
R = 0.8
T = 1 - R
αs = [0, 0.05, 0.1]
l = 1


fig = Figure()
ax = Axis(fig[1, 1], xlabel = "ϕ", ylabel = "Transmittance",
    xticks = LinearTicks(5))

for α in αs
    lines!(ϕ, airy.(ϕ, R, T, α, l))
end

fig