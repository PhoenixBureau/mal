#####################

SOURCES_BASE = reader1.nim types1.nim printer1.nim
# SOURCES_REBUILD = $(SOURCES_BASE) env.nim core.nim

#####################

SRCS = step0_repl.nim step1_read_print.nim
BINS = $(SRCS:%.nim=%)

NIMOPTS = --debuginfo --linedir:on
# -d:release

#####################

all: $(BINS)

dist: mal

mal: $(word $(words $(BINS)),$(BINS))
	cp $< $@

$(BINS): %: %.nim $(SOURCES_BASE)
	nim $(NIMOPTS)  --nimcache:nimcache-$@ c $@

clean:
	rm -rf nimcache-*/ $(BINS)
	rm -f mal
