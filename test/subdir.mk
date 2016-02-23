TEST_RUNNER = bin/run_tests

SRCS += $(wildcard test/*.cpp)

.PHONY: test tests

all: $(TEST_RUNNER)

# build the tests
tests: $(TEST_RUNNER)

$(TEST_RUNNER): build/test/test_runner.o
	mkdir -p $(@D)
	$(COMPILE) $< -o $@

# run the tests
test: $(TEST_RUNNER)
	$(TEST_RUNNER)
