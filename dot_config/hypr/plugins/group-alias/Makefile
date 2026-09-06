PLUGIN  := build/group-alias.so
SRC     := src/main.cpp

CXXFLAGS += -std=c++26 -O2 -g -fPIC -Wall -Wextra -Wno-unused-parameter
# senza -fno-gnu-unique glibc non scarica mai il .so: unload/reload riuserebbe il vecchio codice
CXXFLAGS += -fno-gnu-unique
CXXFLAGS += $(shell pkg-config --cflags hyprland pixman-1 libdrm lua)
LDFLAGS  += -shared

all: $(PLUGIN)

$(PLUGIN): $(SRC) Makefile
	@mkdir -p build
	$(CXX) $(CXXFLAGS) -MD -MP $(LDFLAGS) -o $@ $<

-include $(PLUGIN:.so=.d)

clean:
	rm -rf build

.PHONY: all clean
