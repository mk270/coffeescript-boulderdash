
SRC := $(wildcard *.coffee)
TGT := $(patsubst %.coffee, %.js, $(SRC))

all: $(TGT)

%.js: %.coffee
	coffee -c $<

.PHONY: clean
clean:
	rm -f -- *~ $(TGT)
