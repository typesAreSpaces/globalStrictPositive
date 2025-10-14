PROG=julia
TESTS_DIR=tests
BENCH_DIR=benches
OUT_DIR=out

.PHONY: test clean

all: test1


test:
	${PROG} ${BENCH_DIR}/arch_inconsistent.jl

test1:
	${PROG} ${TESTS_DIR}/basic_test.jl

clean:
	rm -rf ${OUT_DIR}/*.csv
	rm -rf ${OUT_DIR}/*.png
