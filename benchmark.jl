include("./globalStrictPositive.jl")

using .globalStrictPositive
using DynamicPolynomials
using Plots
using DataFrames
using CSV
using LaTeXStrings

motzkin(x, y, z) = x^6 + y^4*z^2 + y^2*z^4 - 3x^2*y^2*z^2
robinson(x, y, z) = x^4*y^2 + y^4*z^2 + x^2*z^4 - 3x^2*y^2*z^2

# TODO Delete this function: it is not used
# Example:
# benchmark_approaching_zero(n, robinson(x, y, z), "robinson_benchmark_approaching_zero_out.txt")
function benchmark_approaching_zero(n, poly, file_name)
  open(file_name, "w") do file
    for i in 1:n
      t = @elapsed out = uniformApproxSOS(poly + 1//i, 1)
      write(file, "$i, $(out[1]), $t\n")
    end
  end
end

# TODO Delete this function: it is not used
# Example:
# benchmark_plot_approaching_zero(n, robinson(x, y, z), "Robinson approaching zero", "robinson_benchmark_approaching_zero.png")
function benchmark_plot_approaching_zero(n, poly, _title, _fig)
  t     = zeros(n)
  m     = zeros(Integer, n)
  index = zeros(Integer, n)
  for i in 1:n
    t[i]     = @elapsed out = uniformApproxSOS(poly + 1//i, 1)
    m[i]     = out[1]
    index[i] = i
  end
  plot(index, [t m], title=_title, label=["time" "deg"], linewidth=3)
  xlabel!("inverse separation")
  savefig(_fig)
end

function arch_benchmark_approaching_zero(n)
  index      = zeros(Integer, n)
  t_motzkin  = zeros(n)
  m_motzkin  = zeros(Integer, n)
  t_robinson = zeros(n)
  m_robinson = zeros(Integer, n)
  for i in 1:n
    index[i] = i
    t_motzkin[i]  = @elapsed out_motzkin = uniformApproxSOS(motzkin(x, y, z) + 1//i, 1)
    t_robinson[i] = @elapsed out_robinson = uniformApproxSOS(robinson(x, y, z) + 1//i, 1)
    m_motzkin[i]  = out_motzkin[1]
    m_robinson[i] = out_robinson[1]
    println(">> Current i ", i)
  end
  times = DataFrame((Motzkin = t_motzkin, Robinson = t_robinson))
  m = DataFrame((Motzkin = m_motzkin, Robinson = m_robinson))
  CSV.write("times_400.csv", times)
  CSV.write("m_400.csv", m)
  # plot(index, [t_motzkin t_robinson m_motzkin m_robinson], title="Approaching zero", label=["time - Motzkin" "time - Robinson" "deg - Motzkin" "deg - Robinson"], linewidth=3, dpi=600)
end

function nonarch_benchmark_approaching_zero(n, g, M, R)
  index      = zeros(Integer, n)
  t_motzkin  = zeros(n)
  m_motzkin  = zeros(Integer, n)
  t_robinson = zeros(n)
  m_robinson = zeros(Integer, n)
  for i in 1:n
    index[i] = i
    t_motzkin[i]  = @elapsed out_motzkin = uniformApproxSOS2(motzkin(x, y, z) + 1//i, g, M, R)
    t_robinson[i] = @elapsed out_robinson = uniformApproxSOS2(robinson(x, y, z) + 1//i, g, M, R)
    m_motzkin[i]  = out_motzkin[1]
    m_robinson[i] = out_robinson[1]
    println(">> Current i ", i)
  end
  times = DataFrame((Motzkin = t_motzkin, Robinson = t_robinson))
  m = DataFrame((Motzkin = m_motzkin, Robinson = m_robinson))
  CSV.write("times_400.csv", times)
  CSV.write("m_400.csv", m)
  # plot(index, [t_motzkin t_robinson m_motzkin m_robinson], title="Approaching zero", label=["time - Motzkin" "time - Robinson" "deg - Motzkin" "deg - Robinson"], linewidth=3, dpi=600)
end


function basic_test()
  g = -x^4 - x^2*y^2 + 2*x^2*y + x*y^2 - y^2
  g = 10 - x^2 - y^4 - z^8

  out = uniformApproxSOS2(motzkin(x, y, z) + 1, g, 11, 14)
  println(">> m: ", out[1])
  println(">> expr: ", out[2])
  println(">> repr: ", out[3])
end

@polyvar x y z

# basic_test()
# arch_benchmark_approaching_zero(400)
g = 10 - x^2 - y^4 - z^8
nonarch_benchmark_approaching_zero(400, g, 11, 14)
