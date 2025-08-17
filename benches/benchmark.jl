const SRC_DIR = "./../src"

include(SRC_DIR * "/globalStrictPositive.jl")

using .globalStrictPositive
using DynamicPolynomials
using DataFrames
using CSV

motzkin(x, y, z) = x^6 + y^4*z^2 + y^2*z^4 - 3x^2*y^2*z^2
robinson(x, y, z) = x^4*y^2 + y^4*z^2 + x^2*z^4 - 3x^2*y^2*z^2

function arch_benchmark_approaching_zero(num_samples, OUT_DIR)
  index      = zeros(Integer, num_samples)
  t_motzkin  = zeros(num_samples)
  r_motzkin  = zeros(Integer, num_samples)
  t_robinson = zeros(num_samples)
  r_robinson = zeros(Integer, num_samples)
  for i in 1:num_samples
    index[i] = i
    t_motzkin[i]  = @elapsed out_motzkin = uniformApproxSOS(motzkin(x, y, z) + 1//i, 1)
    t_robinson[i] = @elapsed out_robinson = uniformApproxSOS(robinson(x, y, z) + 1//i, 1)
    r_motzkin[i]  = out_motzkin[1]
    r_robinson[i] = out_robinson[1]
    println(">> Current i ", i)
  end
  times = DataFrame((Motzkin = t_motzkin, Robinson = t_robinson))
  r = DataFrame((Motzkin = r_motzkin, Robinson = r_robinson))
  CSV.write(OUT_DIR * "/times_400.csv", times)
  CSV.write(OUT_DIR * "/r_400.csv", r)
  # plot(index, [t_motzkin t_robinson r_motzkin r_robinson], title="Approaching zero", label=["time - Motzkin" "time - Robinson" "deg - Motzkin" "deg - Robinson"], linewidth=3, dpi=600)
end

function nonarch_benchmark_approaching_zero(num_samples, g, M, R, OUT_DIR)
  index      = zeros(Integer, num_samples)
  t_motzkin  = zeros(num_samples)
  r_motzkin  = zeros(Integer, num_samples)
  t_robinson = zeros(num_samples)
  r_robinson = zeros(Integer, num_samples)
  for i in 1:num_samples
    index[i] = i
    t_motzkin[i]  = @elapsed out_motzkin = uniformApproxSOS2(motzkin(x, y, z) + 1//i, g, M, R)
    t_robinson[i] = @elapsed out_robinson = uniformApproxSOS2(robinson(x, y, z) + 1//i, g, M, R)
    r_motzkin[i]  = out_motzkin[1]
    r_robinson[i] = out_robinson[1]
    println(">> Current i ", i)
  end
  times = DataFrame((Motzkin = t_motzkin, Robinson = t_robinson))
  r = DataFrame((Motzkin = r_motzkin, Robinson = r_robinson))
  CSV.write(OUT_DIR * "/times_400.csv", times)
  CSV.write(OUT_DIR * "/r_400.csv", r)
  # plot(index, [t_motzkin t_robinson r_motzkin r_robinson], title="Approaching zero", label=["time - Motzkin" "time - Robinson" "deg - Motzkin" "deg - Robinson"], linewidth=3, dpi=600)
end

function main()
  OUT_DIR = ARGS[1]

  # arch_benchmark_approaching_zero(400, OUT_DIR)
  nonarch_benchmark_approaching_zero(400, 10 - x^2 - y^4 - z^8, 11, 14, OUT_DIR)
end

@polyvar x y z
main()
