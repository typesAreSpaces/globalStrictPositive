const SRC_DIR = "./../src"

include(SRC_DIR * "/globalStrictPositive.jl")

using .globalStrictPositive
using DynamicPolynomials

@polyvar x y z

g = -x^4 - x^2*y^2 + x^2*y + x*y^2 - y^4 - 1

out_motzkin = uniformApproxSOS2(-g-e, g, M, R)
