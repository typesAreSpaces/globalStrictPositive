include("./globalStrictPositive.jl")

using .globalStrictPositive
using DynamicPolynomials
using DataFrames
using CSV

motzkin(x, y, z) = x^6 + y^4*z^2 + y^2*z^4 - 3x^2*y^2*z^2
robinson(x, y, z) = x^4*y^2 + y^4*z^2 + x^2*z^4 - 3x^2*y^2*z^2

function arch_benchmark_approaching_zero(n)
  index      = zeros(Integer, n)
  t_motzkin  = zeros(n)
  r_motzkin  = zeros(Integer, n)
  t_robinson = zeros(n)
  r_robinson = zeros(Integer, n)
  for i in 1:n
    index[i] = i
    t_motzkin[i]  = @elapsed out_motzkin = uniformApproxSOS(motzkin(x, y, z) + 1//i, 1)
    t_robinson[i] = @elapsed out_robinson = uniformApproxSOS(robinson(x, y, z) + 1//i, 1)
    r_motzkin[i]  = out_motzkin[1]
    r_robinson[i] = out_robinson[1]
    println(">> Current i ", i)
  end
  times = DataFrame((Motzkin = t_motzkin, Robinson = t_robinson))
  r = DataFrame((Motzkin = r_motzkin, Robinson = r_robinson))
  CSV.write("times_400.csv", times)
  CSV.write("r_400.csv", r)
  # plot(index, [t_motzkin t_robinson r_motzkin r_robinson], title="Approaching zero", label=["time - Motzkin" "time - Robinson" "deg - Motzkin" "deg - Robinson"], linewidth=3, dpi=600)
end

function nonarch_benchmark_approaching_zero(n, g, M, R)
  index      = zeros(Integer, n)
  t_motzkin  = zeros(n)
  r_motzkin  = zeros(Integer, n)
  t_robinson = zeros(n)
  r_robinson = zeros(Integer, n)
  for i in 1:n
    index[i] = i
    t_motzkin[i]  = @elapsed out_motzkin = uniformApproxSOS2(motzkin(x, y, z) + 1//i, g, M, R)
    t_robinson[i] = @elapsed out_robinson = uniformApproxSOS2(robinson(x, y, z) + 1//i, g, M, R)
    r_motzkin[i]  = out_motzkin[1]
    r_robinson[i] = out_robinson[1]
    println(">> Current i ", i)
  end
  times = DataFrame((Motzkin = t_motzkin, Robinson = t_robinson))
  r = DataFrame((Motzkin = r_motzkin, Robinson = r_robinson))
  CSV.write("times_400.csv", times)
  CSV.write("r_400.csv", r)
  # plot(index, [t_motzkin t_robinson r_motzkin r_robinson], title="Approaching zero", label=["time - Motzkin" "time - Robinson" "deg - Motzkin" "deg - Robinson"], linewidth=3, dpi=600)
end


# TODO Move this function somewhere else
function basic_test()
  g = -x^4 - x^2*y^2 + 2*x^2*y + x*y^2 - y^2
  g = 10 - x^2 - y^4 - z^8

  out = uniformApproxSOS2(motzkin(x, y, z) + 1, g, 11, 14)
  println(">> m: ", out[1])
  println(">> expr: ", out[2])
  # println(">> repr: ", out[3])
end

@polyvar x y z

# basic_test()

# arch_benchmark_approaching_zero(400)
nonarch_benchmark_approaching_zero(400, 10 - x^2 - y^4 - z^8, 11, 14)
