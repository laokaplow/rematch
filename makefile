## make settings
.DEFAULT_GOAL = all
.PHONY = all clean test
.SUFFIXES = # disables most default rules


## compilation settings

CXX = clang++
CXXFLAGS = -std=c++14 -Wall -Werror -pedantic $(INCLUDE_DIRS:%,-I%)
DEPFLAGS = -MMD -MP # compiler flags for generating dependency files
COMPILE = $(CXX) $(CXXFLAGS) $(DEPFLAGS)


## project structure

TARGET = bin/re

SRCS := $(wildcard src/*.cpp)
OBJ_FILES = $(SRCS:src/%.cpp=build/%.o)
DEP_FILES = $(SRCS:src/%.cpp=build/%.d)

INCLUDE_DIRS = src vendor
OUTPUT_DIRS = build bin
$(OUTPUT_DIRS):
	mkdir -p $@


## rules

all: $(TARGET)

$(TARGET): build/main.o | bin
	$(COMPILE) $^ -o $@

# place object and dependency files in their own directory
$(OBJ_FILES): $(SRCS:build/%.o=src/%.cpp) | build
	@echo building $@ from $<
	$(COMPILE) $< -c -o $@

# tests
#include tests/subdir.mk


clean:
	rm -rf $(OUTPUT_DIRS)

#include dependency information
-include $(DEP_FILES:%.c=%.d)
