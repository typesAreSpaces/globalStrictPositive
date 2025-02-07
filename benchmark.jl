include("./globalStrictPositive.jl")

using .globalStrictPositive
using DynamicPolynomials
using Plots
using DataFrames
using CSV
using LaTeXStrings

motzkin(x, y, z) = x^6 + y^4*z^2 + y^2*z^4 - 3x^2*y^2*z^2
robinson(x, y, z) = x^4*y^2 + y^4*z^2 + x^2*z^4 - 3x^2*y^2*z^2

function motzkin_benchmark_simple(n)
  for i in 1:n
    t = @elapsed out = uniformApproxSOS(motzkin(i, x, y) + 1, 1)
    println(">> Current i: ", i)
    println(">> m: ", out[1])
  end
end

function motzkin_benchmark_approaching_zero(n)
  open("motzkin_benchmark_approaching_zero_out.txt", "w") do file
    for i in 1:n
      t = @elapsed out = uniformApproxSOS(motzkin(x, y, z) + 1//i, 1)
      write(file, "$i, $(out[1]), $t\n")
    end
  end
end

function motzkin_benchmark_plot_approaching_zero(n)
  t     = zeros(n)
  m     = zeros(Integer, n)
  index = zeros(Integer, n)
  for i in 1:n
    t[i]     = @elapsed out = uniformApproxSOS(motzkin(x, y, z) + 1//i, 1)
    m[i]     = out[1]
    index[i] = i
  end
  plot(index, [t m], title="Motzkin approaching zero", label=["time" "deg"], linewidth=3)
  xlabel!("inverse separation")
  savefig("motzkin_benchmark_approaching_zero.png")
end

function robinson_benchmark_simple(n)
  for i in 1:n
    @time out = uniformApproxSOS(robinson(i, x, y) + 1, 1)
    println(">> Current i: ", i)
    println(">> m: ", out[1])
  end
end

function robinson_benchmark_approaching_zero(n)
  open("robinson_benchmark_approaching_zero_out.txt", "w") do file
    for i in 1:n
      t = @elapsed out = uniformApproxSOS(robinson(x, y, z) + 1//i, 1)
      write(file, "$i, $(out[1]), $t\n")
    end
  end
end

function robinson_benchmark_plot_approaching_zero(n)
  t     = zeros(n)
  m     = zeros(Integer, n)
  index = zeros(Integer, n)
  for i in 1:n
    t[i]     = @elapsed out = uniformApproxSOS(robinson(x, y, z) + 1//i, 1)
    m[i]     = out[1]
    index[i] = i
  end
  plot(index, [t m], title="Robinson approaching zero", label=["time" "deg"], linewidth=3)
  xlabel!("inverse separation")
  savefig("robinson_benchmark_approaching_zero.png")
end

function benchmark_approaching_zero(n)
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

function plot_benchmark(times_file, m_file)
  m = CSV.read(m_file, DataFrame)
  # m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300)
  # m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,400), yguidefontrotation=-90)
  m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,400), yticks=0:2:12, yguidefontrotation=-90)
  xlabel!(m_plot, L"d")
  ylabel!(m_plot, L"m")
  savefig(m_plot, "m_400.png")

  times = CSV.read(times_file, DataFrame)
  # times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,400), yticks=0:3:12)
  times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,400), yticks=0:2:12)
  xlabel!(times_plot, L"d")
  #ylabel!(times_plot, "time (seconds)")
  ylabel!(times_plot, "time (seconds)")
  savefig(times_plot, "times_400.png")

  plot(m_plot, times_plot, layout=(1, 2), size=(1000, 300), margin = 1Plots.cm)
  savefig("m_times_400.png")
end

@polyvar x y z

# motzkin_benchmark_plot_approaching_zero(10)
# benchmark_approaching_zero(400)
default(fontfamily="Times New Roman")
plot_benchmark("./results/400/times_400.csv", "./results/400/m_400.csv")

# TODO: Later
# g = 1 - x^4*y^2 - x^2*y^4 + x^2*y^2 - y^6 - x^6
# n = 1000000
# for i in 1:n
  # println(">> i: ", i)
  # println(">> input poly: ", motzkin(1//2, x, y) + 1//i)
  # t = @elapsed out = uniformApproxSOS2(motzkin(1//2, x, y) + 1//i, g)
  # println(">> m: ", out[1])
  # println(">> time: ", t)
# end


