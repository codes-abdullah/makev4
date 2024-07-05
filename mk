####################
PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
#remove trailing slash
PROJECT_DIR := $(PROJECT_DIR:/=)
PROJECT_NAME := $(notdir $(PROJECT_DIR))
####################
CXX := g++
CXXFLAGS := -Wall -Wextra -g -O3 -Wno-unused-parameter
SRC_DIR_NAME := src
BUILD_DIR_NAME := build
OBJ_DIR_NAME := obj
TARGET_FILE_NAME := $(PROJECT_NAME)
####################
INCLUDE_LIBS := glfw3 glew
INCLUDE_LIBS_CFLAGS := $(shell pkg-config --cflags $(INCLUDE_LIBS))
INCLUDE_LIBS_LIBS := $(shell pkg-config --libs $(INCLUDE_LIBS))
####################
BUILD_DIR ?= $(PROJECT_DIR)/$(BUILD_DIR_NAME)
OBJ_DIR ?= $(PROJECT_DIR)/$(OBJ_DIR_NAME)
TARGET ?= $(BUILD_DIR)/$(TARGET_FILE_NAME)
SRC_DIR ?= $(PROJECT_DIR)/$(SRC_DIR_NAME)
#SRC_DIRS := $(shell find $(SRC_DIR) -not -empty -type d)
#SRC_DIRS_FLAGS := $(addprefix -I,$(SRC_DIRS))
SRC_FILES := $(shell find $(SRC_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')
OBJ_FILES := $(patsubst %.cpp, %.cpp.o, $(SRC_FILES))
OBJ_FILES := $(subst src,obj,$(OBJ_FILES))
#####################
MAKE_DEPS := $(OBJ_FILES:.o=.d)
INCLUDE_DIR := $(PROJECT_DIR)/include
INCLUDE_DIR_FLAGS := $(addprefix -I,$(INCLUDE_DIR))
CPPFLAGS ?= $(INCLUDE_DIR_FLAGS) -MMD -MP
#####################
millis := $(shell date +%s%N | cut -b1-13)






all: $(TARGET)
	$(eval  now:=$(shell date +%s%N | cut -b1-13))
	@echo $(millis)
	@echo $(now)

FINALLY: ECLIPSE_IDE_REQUIREMENTS
	$(shell rm -r $(BUILD_DIR)/$(OBJ_DIR_NAME))
	mv -f $(OBJ_DIR) $(BUILD_DIR)

#special impelementation, tested on eclipse Version: 2024-06 (4.32.0)
#eclipse will be looking for 2 dirs for running and debugging the app
#./build/default and ./build/make.debug.linux.x86_64
#just remove this target from all prerequisite to deactive
ECLIPSE_IDE_REQUIREMENTS:
	mkdir -p $(BUILD_DIR)/make.debug.linux.x86_64
	mkdir -p $(BUILD_DIR)/default
	cp $(TARGET) $(BUILD_DIR)/default
	mv $(TARGET) $(BUILD_DIR)/make.debug.linux.x86_64


test:
	@echo "SRC_DIRS: $(SRC_DIRS)"
	@echo "SRC_FILES: $(SRC_FILES)"
	@echo "BUILD_DIR: $(BUILD_DIR)"
	@echo "OBJ_DIR: $(OBJ_DIR)"
	@echo "OBJ_FILES: $(OBJ_FILES)"
	@echo "INCLUDE_DIR: $(INCLUDE_DIR)"
	@echo "INCLUDE_DIR_FLAGS: $(INCLUDE_DIR_FLAGS)"
	@echo "MAKE_DEPS: $(MAKE_DEPS)"
	@echo "CPP_FLAGS: $(CPP_FLAGS)"
	@echo "INCLUDE_LIBS: $(INCLUDE_LIBS)"
	@echo "INCLUDE_LIBS_LIBS: $(INCLUDE_LIBS_LIBS)"
	@echo "INCLUDE_LIBS_CFLAGS: $(INCLUDE_LIBS_CFLAGS)"
	@echo "TRARGET: $(TARGET)"

$(TARGET): $(OBJ_FILES)	
	mkdir -p $(dir $@)
	$(CXX) $(INCLUDE_LIBS_CFLAGS) $^ -o $@ $(INCLUDE_LIBS_LIBS)

$(OBJ_DIR)/%.cpp.o: $(SRC_DIR)/%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

.PHONY: all clean
clean:
	rm -r $(OBJ_DIR) $(BUILD_DIR)


