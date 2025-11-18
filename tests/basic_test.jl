const SRC_DIR = "./../src/"

include(SRC_DIR * "globalStrictPositive.jl")
using .globalStrictPositive
using DynamicPolynomials
using MathLink

motzkin(x, y, z) = x^6 + y^4*z^2 + y^2*z^4 - 3x^2*y^2*z^2;

function basic_test()
  g = -x^4 - x^2*y^2 + 2*x^2*y + x*y^2 - y^2
  g = 10 - x^2 - y^4 - z^8

  out = uniformApproxSOS2(motzkin(x, y, z) + 1, g, 11, 14)
  println(">> m: ", out[1])
  println(">> expr: ", out[2])
  # println(">> repr: ", out[3])
end

@polyvar x y z

basic_test()

