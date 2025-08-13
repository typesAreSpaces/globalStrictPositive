FILE=test_juliaPolyToMathematica.jl
FILE=plots.jl
FILE=benchmark.jl

#all: runOutput
all: run

run:
	julia ${FILE}

runOutput:
	julia ${FILE} > output.txt
