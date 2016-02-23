## make settings
.DEFAULT_GOAL = all
.SUFFIXES: # disables most default rules
.SECONDEXPANSION: # allow prereqs to reference targets

## compilation settings

CXX = clang++
CXXFLAGS = -std=c++14 -Wall -Werror -pedantic $(INCLUDE_DIRS:%,-I%)
DEPFLAGS = -MMD -MP # compiler flags for generating dependency files
COMPILE = $(CXX) $(CXXFLAGS) $(DEPFLAGS)


## project structure

TARGET = bin/rematch

SRCS := $(wildcard src/*.cpp)

INCLUDE_DIRS = src vendor
OUTPUT_DIRS = build bin

## rules
.PHONY: all clean

all: $(TARGET)

$(TARGET): build/src/main.o
	@mkdir -p $(@D) # ensure output directory exists
	$(COMPILE) $^ -o $@

# build object and dependency files
build/%.o : %.cpp
	@mkdir -p $(@D) # ensure output directory exists
	@echo building $@ from "<" $^ ">"
	$(COMPILE) $< -c -o $@

# tests
include test/subdir.mk

clean:
	rm -rf $(OUTPUT_DIRS)

#include dependency information
-include $(SRCS:%.cpp=build/%.d)
