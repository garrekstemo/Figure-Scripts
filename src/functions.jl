function dielectric_real(x, x₀, A, Γ)
    A * (x₀^2 - x^2) / ((x^2 - x₀^2)^2 + Γ^2 * x^2)
end

function dielectric_imag(x, x₀, A, Γ)
    A * Γ * x / ((x^2 - x₀^2)^2 + Γ^2 * x^2)
end

function lorentzian(x, x₀, A, Γ)
    A * Γ / (x - x₀ + im * Γ)
end

function gauss(x, x₀, A, σ)
    A * exp(-0.5 * ((x - x₀) / σ)^2)
end

function cavity_dispersion(θ, E₀, n_bg)
    E₀ / sqrt(1 - (sin(θ) / n_bg)^2)
end

function coupled_energies(E_c, E_v, V, branch)
    if branch == 1
        return 0.5 * (E_c + E_v) + 0.5 * sqrt((E_c - E_v)^2 + V^2)
    else
        return 0.5 * (E_c + E_v) - 0.5 * sqrt((E_c - E_v)^2 + V^2)
    end
end

function cavity_transmittance(ν, n, α, p)
    L, R, ϕ = p
    T = 1 - R
    T^2 * exp(-α * L) / (1 + R^2 * exp(-2 * α * L) - 2 * R * exp(-α * L) * cos(4π * n * L * ν + 2 * ϕ))
end