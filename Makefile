# Allow to use a different pandoc binary, e.g. when testing.
PANDOC ?= pandoc

# Test that running the filter on the sample input document yields
# the expected output.
#
# The automatic variable `$<` refers to the first dependency
# (i.e., the filter file).
test: test/perevirka.md
	$(PANDOC) lua test/runtests.lua $<

# Ensure that the `test` target is run each time it's called.
.PHONY: test
