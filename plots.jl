include("./globalStrictPositive.jl")

using .globalStrictPositive
using DynamicPolynomials
using Plots
using DataFrames
using CSV
using LaTeXStrings

function plot_benchmark(times_file, r_file, num_samples)
  r = CSV.read(r_file, DataFrame; missingstring="-")
  # r_plot = plot(Matrix(r), labels=permutedims(names(r)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300)
  # r_plot = plot(Matrix(r), labels=permutedims(names(r)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yguidefontrotation=-90)
  r_plot = plot(Matrix(r), labels=permutedims(names(r)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:2:12)
  xlabel!(r_plot, L"d")
  ylabel!(r_plot, L"r")
  savefig(r_plot, "r_400.png")

  times = CSV.read(times_file, DataFrame; missingstring="-")
  times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:3:12)
  # times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:2:12)
  xlabel!(times_plot, L"d")
  ylabel!(times_plot, "time (seconds)")
  savefig(times_plot, "times_400.png")

  # plot(r_plot, times_plot, layout=(1, 2), size=(1000, 300), margin = 1Plots.cm)
  # savefig("r_and_times_400.png")
end

function plot_benchmark_comparison(times_file, r_file, times_2_file, r_2_file, num_samples)
  r1 = CSV.read(r_file, DataFrame; missingstring="-")
  r2 = CSV.read(r_2_file, DataFrame; missingstring="-")
  r = hcat(r1, r2)
  r = r[1:end-100, :]
  # r_plot = plot(Matrix(r), labels=permutedims(names(r)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300)
  # r_plot = plot(Matrix(r), labels=permutedims(names(r)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yguidefontrotation=-90)
  r_plot = plot(Matrix(r), labels=permutedims(names(r)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:2:12, yguidefontrotation=-90)
  xlabel!(r_plot, L"d")
  ylabel!(r_plot, L"r")
  savefig(r_plot, "r_400.png")

  times1 = CSV.read(times_file, DataFrame; missingstring="-")
  times2 = CSV.read(times_2_file, DataFrame; missingstring="-")
  times = hcat(times1, times2)
  times = times[1:end-100, :]
  times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:outerbottom, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:3:12)
  # times_plot = plot(Matrix(times), labels=permutedims(names(times)), legend=:none, legendcolumns=2, linewidth=2, dpi=300, ylimits=(0,12), xlimits=(0,num_samples), yticks=0:2:12)
  xlabel!(times_plot, L"d")
  ylabel!(times_plot, "time (seconds)")
  savefig(times_plot, "times_400.png")

  plot(r_plot, times_plot, layout=(1, 2), size=(1000, 300), margin = 1Plots.cm)
  savefig("r_and_times_400.png")
end

default(fontfamily="Times New Roman")
# plot_benchmark("./results/400/times_400.csv", "./results/400/r_400.csv")
# plot_benchmark_comparison("./results/400/times_400.csv", "./results/400/r_400.csv", "./results/400/realcertify_times_400_2.csv", "./results/400/realcertify_r_400_2.csv")
plot_benchmark("./times_400.csv", "./r_400.csv", 400)
