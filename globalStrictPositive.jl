module globalStrictPositive

export juliaPolyToMathematica, minimizeInMathematica
export uniformApproxSOS, uniformApproxSOS2

using SumOfSquares
using DynamicPolynomials
using MosekTools
using Folds
using MathLink

import MathLink: WSymbol

global const uniformApproxSOS_debug = false

# Translates polynomial from DynamicPolynomials
# to W"" expression associated to MathLink
function juliaPolyToMathematica(f, vars=variables(f))
  exponents   = map(mon -> mon.z, f.x)
  w_vars      = map(var -> WSymbol(var.name), vars)
  w_monomials = map(exp -> Folds.prod(w_vars .^ exp), exponents)
  Folds.sum(f.a .* w_monomials)
end

# Create minimization problem query
# to compute minimum value of polynomial f using Mathematica
function minimizeInMathematica(f, vars=variables(f))
  w_f    = juliaPolyToMathematica(f, vars)
  w_vars = map(var -> WSymbol(var.name), vars)
  w_output = weval(W`Rationalize[Part[Minimize[$w_f, $w_vars], 1], 1/100]`)
  if isa(w_output, Number)
    w_output
  else
    weval(W`Numerator[$(w_output)]`)//weval(W`Denominator[$(w_output)]`)
  end
end

function uniformApproxSOS(f, archimedean_n::Integer)
  M    = rationalize(exp(archimedean_n) - 1)
  vars = variables(f)
  n    = length(vars)

  if n == 0
    error("Polynomial is a constant")
  end

  fStar = minimizeInMathematica(f, vars)
  if fStar <= 0
    error("Polynomial is not strictly positive")
  end

  r     = 0
  accum = n
  expr  = f

  model = SOSModel(Mosek.Optimizer)
  set_silent(model)
  @constraint(model, con, expr >= 0)
  optimize!(model)

  while termination_status(model) != OPTIMAL
    if uniformApproxSOS_debug
      println(">> Current r: ", r)
      println(">> Current expr: ", expr)
    end

    r     += 1
    accum += 1//factorial(r) * Folds.sum(map(var -> var^(2*r), vars))
    expr   = f - fStar//2 + fStar//(2*(M + n))*accum

    model  = SOSModel(Mosek.Optimizer)
    set_silent(model)
    @constraint(model, con, expr >= 0)
    optimize!(model)
  end
  repr = sos_decomposition(con)
  r, expr, repr
end

# g such that S(g) is bounded
# K = 1
# M = sup(g + K)
# R such that Semialgebraic(g + K) \subseteq Semialgebraic(R - ||x||^2)
function uniformApproxSOS2(f, g, M, R)
  vars = variables(f)
  n    = length(vars)

  if n == 0
    error("Polynomial is a constant")
  end

  fStar = minimizeInMathematica(f, vars)
  if fStar <= 0
    error("Polynomial is not strictly positive")
  end

  eps   = fStar//(2*M*n*rationalize(exp(R)))

  r     = 0
  accum = n
  expr  = f

  model = SOSModel(Mosek.Optimizer)
  set_silent(model)
  @constraint(model, con, expr >= 0)
  optimize!(model)

  while termination_status(model) != OPTIMAL
    if uniformApproxSOS_debug
      println(">> Current m: ", r)
      println(">> Current expr: ", expr)
    end

    r     += 1
    accum += 1//factorial(r) * Folds.sum(map(var -> var^(2*r), vars))
    expr   = f - eps*accum*g

    model  = SOSModel(Mosek.Optimizer)
    set_silent(model)
    @constraint(model, con, expr >= 0)
    optimize!(model)
  end
  repr = sos_decomposition(con)
  r, expr, repr
end

end
