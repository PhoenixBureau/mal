#####################

SOURCES_BASE = reader.nim types.nim printer.nim
# SOURCES_REBUILD = $(SOURCES_BASE) env.nim core.nim

#####################

SRCS = step0_repl.nim step1_read_print.nim
BINS = $(SRCS:%.nim=%)

#####################

all: $(BINS)

dist: mal

mal: $(word $(words $(BINS)),$(BINS))
	cp $< $@

$(BINS): %: %.nim $(SOURCES_BASE)
	nim -d:release --nimcache:nimcache-$@ c $@

clean:
	rm -rf nimcache-*/ $(BINS)
	rm -f mal
