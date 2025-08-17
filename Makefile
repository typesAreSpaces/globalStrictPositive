PROG=julia
TESTS_DIR=tests
BENCH_DIR=benches
OUT_DIR=out

.PHONY: test benchmark clean

all: ${OUT_DIR}/r_and_times_400.png

${OUT_DIR}/r_and_times_400.png: ${OUT_DIR}/times_400.csv ${OUT_DIR}/r_400.csv
	${PROG} ${BENCH_DIR}/plots.jl ${OUT_DIR}
	magick convert ${OUT_DIR}/r_400.png ${OUT_DIR}/times_400.png -append ${OUT_DIR}/r_and_times_400.png

${OUT_DIR}/times_400.csv:
	${PROG} ${BENCH_DIR}/benchmark.jl ${OUT_DIR}

${OUT_DIR}/r_400.csv: ${OUT_DIR}/times_400.csv

test:
	${PROG} ${TESTS_DIR}/test_juliaPolyToMathematica.jl

clean:
	rm -rf ${OUT_DIR}/*.csv
	rm -rf ${OUT_DIR}/*.png
