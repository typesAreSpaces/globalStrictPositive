include("./globalStrictPositive.jl")
using .globalStrictPositive
using DynamicPolynomials
using Plots

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

function benchmark_plot_approaching_zero(n)
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
  end
  plot(index, [t_motzkin t_robinson m_motzkin m_robinson], title="Approaching zero", label=["time - Motzkin" "time - Robinson" "deg - Motzkin" "deg - Robinson"], linewidth=3, dpi=600)
  xlabel!("inverse separation")
  savefig("benchmark_approaching_zero.png")
end

@polyvar x y z

motzkin_benchmark_plot_approaching_zero(100)
benchmark_plot_approaching_zero(200)
