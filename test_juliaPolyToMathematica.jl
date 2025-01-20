include("./globalStrictPositive.jl")
using .globalStrictPositive
using DynamicPolynomials
using MathLink

motzkin(x, y, z) = x^6 + y^4*z^2 + y^2*z^4 - 3x^2*y^2*z^2;

@polyvar x y z

poly = motzkin(1, x, y) + 1
test = minimizeInMathematica(poly)
@show test
