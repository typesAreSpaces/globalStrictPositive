PROG=julia

.PHONY: test benchmark clean

all: r_and_times_400.png
all: output.txt

r_and_times_400.png:
	${PROG} plots.jl
	magick convert r_400.png times_400.png -append r_and_times_400.png

benchmark:
	${PROG} benchmark.jl

output.txt:
	${PROG} benchmark.jl > output.txt

test:
	${PROG} test_juliaPolyToMathematica.jl

clean:
	rm *.png
	rm output.txt
