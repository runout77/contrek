CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17 -Isrc -MMD -MP -pthread -g \
           -fno-omit-frame-pointer -fsanitize=address,undefined \
           -O0
LDFLAGS = -pthread -lz -fsanitize=address,undefined

# valgrinf or perf setup
# CXXFLAGS = -Wall -Wextra -std=c++17 -Isrc -MMD -MP -pthread -g -fno-omit-frame-pointer -march=native -DNDEBUG -O3
# LDFLAGS = -lpng -pthread -lz

# best performances
CXXFLAGS = -Wall -Wextra -std=c++17 -Isrc -MMD -MP -pthread -g -march=native -DNDEBUG -Ofast -flto
LDFLAGS = -pthread -lz -flto=auto

SRC = $(shell find src -name '*.cpp')
C_SRC = $(shell find src -name 'spng.c')

OBJ = $(patsubst src/%.cpp, build/%.o, $(SRC))
OBJ += $(patsubst src/%.c, build/%.o, $(C_SRC))

DEPS = $(OBJ:.o=.d)

EXEC = contrek

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CXX) $(CXXFLAGS) $(OBJ) -o $@ -Wl,--no-as-needed $(LDFLAGS)

build/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

build/%.o: src/%.c
	@mkdir -p $(dir $@)
	$(CC) -O3 -march=native -fPIC -c $< -o $@

-include $(DEPS)

clean:
	rm -rf build $(EXEC)

run: all
	./$(EXEC)