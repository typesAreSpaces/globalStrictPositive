PROG=julia

.PHONY: test benchmark clean

all: r_and_times_400.png

r_and_times_400.png: times_400.csv r_400.csv
	${PROG} plots.jl
	magick convert r_400.png times_400.png -append r_and_times_400.png

times_400.csv:
	${PROG} benchmark.jl

r_400.csv: times_400.csv

test:
	${PROG} test_juliaPolyToMathematica.jl

clean:
	rm *.csv
	rm *.png
