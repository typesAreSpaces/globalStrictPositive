include("./globalStrictPositive.jl")

using .globalStrictPositive
using DynamicPolynomials
using Plots
using DataFrames
using CSV
using LaTeXStrings

function plot_benchmark(times_file, m_file, num_samples)
  m = CSV.read(m_file, DataFrame; missingstring="-")
  # m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300)
  # m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yguidefontrotation=-90)
  m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:2:12, yguidefontrotation=-90)
  xlabel!(m_plot, L"d")
  ylabel!(m_plot, L"m")
  savefig(m_plot, "m_400.png")

  times = CSV.read(times_file, DataFrame; missingstring="-")
  times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:3:12)
  # times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:2:12)
  xlabel!(times_plot, L"d")
  #ylabel!(times_plot, "time (seconds)")
  ylabel!(times_plot, "time (seconds)")
  savefig(times_plot, "times_400.png")

  plot(m_plot, times_plot, layout=(1, 2), size=(1000, 300), margin = 1Plots.cm)
  savefig("m_times_400.png")
end

function plot_benchmark_comparison(times_file, m_file, times_2_file, m_2_file, num_samples)
  m1 = CSV.read(m_file, DataFrame; missingstring="-")
  m2 = CSV.read(m_2_file, DataFrame; missingstring="-")
  m = hcat(m1, m2)
  m = m[1:end-100, :]
  # m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300)
  # m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yguidefontrotation=-90)
  m_plot = plot(Matrix(m), labels=permutedims(names(m)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:2:12, yguidefontrotation=-90)
  xlabel!(m_plot, L"d")
  ylabel!(m_plot, L"m")
  savefig(m_plot, "m_400.png")

  times1 = CSV.read(times_file, DataFrame; missingstring="-")
  times2 = CSV.read(times_2_file, DataFrame; missingstring="-")
  times = hcat(times1, times2)
  times = times[1:end-100, :]
  times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:3:12)
  # times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:2:12)
  xlabel!(times_plot, L"d")
  ylabel!(times_plot, "time (seconds)")
  savefig(times_plot, "times_400.png")

  plot(m_plot, times_plot, layout=(1, 2), size=(1000, 300), margin = 1Plots.cm)
  savefig("m_times_400.png")
end

default(fontfamily="Times New Roman")
# plot_benchmark("./results/400/times_400.csv", "./results/400/m_400.csv")
# plot_benchmark_comparison("./results/400/times_400.csv", "./results/400/m_400.csv", "./results/400/realcertify_times_400_2.csv", "./results/400/realcertify_m_400_2.csv")
plot_benchmark("./times_400.csv", "./m_400.csv", 400)
