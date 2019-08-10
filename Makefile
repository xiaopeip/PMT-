outfile := $(patsubst %, result/%-pgan.h5, $(shell seq 1797))
all:$(outfile)

result/%-pgan.h5:
	wolframscript -file finalfit.wl $(patsubst result/%-pgan.h5, %, $@)
clean:
	rm result/*-pgan.h5
