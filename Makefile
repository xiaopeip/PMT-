outfile := $(patsubst %, jieguo/%-pgan.h5, $(shell seq 1797))
all:$(outfile)

%-pgan.h5:
	wolframscript -file final.wl $(patsubst %-pgan.h5, %, $@)
clean:
	rm jieguo/*-pgan.h5
