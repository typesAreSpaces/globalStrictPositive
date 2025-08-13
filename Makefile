FILE=test_juliaPolyToMathematica.jl
FILE=benchmark.jl
FILE=plots.jl

#all: runOutput
all: run

run:
	julia ${FILE}

runOutput:
	julia ${FILE} > output.txt
