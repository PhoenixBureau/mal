#####################

# SOURCES_BASE = types.nim reader.nim printer.nim
# SOURCES_REBUILD = $(SOURCES_BASE) env.nim core.nim

#####################

SRCS = step0_repl.nim
BINS = $(SRCS:%.nim=%)

#####################

all: $(BINS)

dist: mal

mal: $(word $(words $(BINS)),$(BINS))
	cp $< $@

$(BINS): %: %.nim
	nim -d:release --nimcache:nimcache-$@ c $@

clean:
	rm -rf nimcache-*/ $(BINS)
	rm -f mal
