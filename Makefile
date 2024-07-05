####################
PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
#remove trailing slash
PROJECT_DIR := $(PROJECT_DIR:/=)
PROJECT_NAME := $(notdir $(PROJECT_DIR))
CXX := g++
#don't specify flags, will be inserted depending on IDE
CXXFLAGS :=
CXXFLAGS_DEBUG := -g -Wall -Wextra -Wno-unused-parameter 
CXXFLAGS_BUILD := -O0 -Wall -Wextra -Wno-unused-parameter
####################
SRC_DIR_NAME := src
BUILD_DIR_NAME := build
DEBUG_DIR_NAME := debug
OBJ_DIR_NAME := obj
TARGET_FILE_NAME := $(PROJECT_NAME)
####################
INCLUDE_LIBRARY := glfw3 glew
INCLUDE_LIBRARY_CFLAGS := $(shell pkg-config --cflags $(INCLUDE_LIBRARY))
INCLUDE_LIBRARY_LIBS_FLAGS := $(shell pkg-config --libs $(INCLUDE_LIBRARY))
####################
DEFAULT_BUILD_DIR := $(PROJECT_DIR)/$(BUILD_DIR_NAME)
DEFAULT_BUILD_OBJ_DIR := $(DEFAULT_BUILD_DIR)/$(OBJ_DIR_NAME)
DEFAULT_BUILD_TARGET := $(DEFAULT_BUILD_DIR)/$(PROJECT_NAME)
DEFAULT_DEBUG_DIR := $(PROJECT_DIR)/$(DEBUG_DIR_NAME)
DEFAULT_DEBUG_OBJ_DIR := $(DEFAULT_DEBUG_DIR)/$(OBJ_DIR_NAME)
DEFAULT_DEBUG_TARGET := $(DEFAULT_DEBUG_DIR)/$(PROJECT_NAME)
####################
DEFAULT_SRC_DIR := $(PROJECT_DIR)/$(SRC_DIR_NAME)
DEFAULT_SRC_FILES := $(shell find $(DEFAULT_SRC_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')
DEFAULT_BUILD_OBJ_FILES := $(patsubst %.cpp, %.cpp.o, $(DEFAULT_SRC_FILES))
DEFAULT_DEBUG_OBJ_FILES := $(DEFAULT_BUILD_OBJ_FILES)
DEFAULT_BUILD_OBJ_FILES := $(subst $(DEFAULT_SRC_DIR),$(DEFAULT_BUILD_OBJ_DIR),$(DEFAULT_BUILD_OBJ_FILES))
DEFAULT_DEBUG_OBJ_FILES := $(subst $(DEFAULT_SRC_DIR),$(DEFAULT_DEBUG_OBJ_DIR),$(DEFAULT_DEBUG_OBJ_FILES))
####################
ECLIPSE_BUILD_DIR := $(DEFAULT_BUILD_DIR)/default
ECLIPSE_BUILD_OBJ_DIR := $(ECLIPSE_BUILD_DIR)/obj
ECLIPSE_DEBUG_DIR := $(DEFAULT_DEBUG_DIR)/make.debug.linux.x86_64
ECLIPSE_DEBUG_OBJ_DIR := $(ECLIPSE_DEBUG_DIR)/obj
ECLIPSE_BUILD_TARGET := $(ECLIPSE_BUILD_DIR)/$(TARGET_FILE_NAME)
ECLIPSE_DEBUG_TARGET := $(ECLIPSE_DEBUG_DIR)/$(TARGET_FILE_NAME)
#####################
MAKE_DEPS := $(OBJ_FILES:.o=.d)
INCLUDE_DIR := $(PROJECT_DIR)/include
INCLUDE_DIR_FLAGS := $(addprefix -I,$(INCLUDE_DIR))
CPPFLAGS ?= $(INCLUDE_DIR_FLAGS)
#####################
##################### ECLIPSE SPECIFIC MODE SETUP
#####################
ifeq ($(BUILD_MODE),debug)
	CXXFLAGS += CXXFLAGS_DEBUG
else ifeq ($(BUILD_MODE),run)
	CXXFLAGS += CXXFLAGS_RUN
endif
#####################
#####################
#####################


all: $(TARGET) 
	$(eval  ends_millis := $(shell date +%s%N | cut -b1-13))
	@echo done in $(shell ./xdiff $(ends_millis) $(starts_millis)) millis
#####################
##################### CODE::BLOCKS SPECIFIC SETUP
#####################
Release: preRelease all postRelease
Debug: preDebug all postDebug
preRelease:	
	$(eval CXXFLAGS += CXXFLAGS_RUN)
postRelease:
	#move files to obj and bin dirs
preDebug:
	$(eval CXXFLAGS += CXXFLAGS_DEBUG)
postDebug:
#####################
#####################
#####################



$(TARGET): compile link


compile:
	@echo "compiling now"
	$(CXX) $(INCLUDE_DIR_FLAGS) -c $(SRC_FILES)
link:
	@echo "linking now"
	$(CXX) $(INCLUDE_LIBRARY_CFLAGS) *.o -o app $(INCLUDE_LIBRARY_LIBS_FLAGS)
test:
	@echo "PROJECT_DIR: $(PROJECT_DIR)"
	@echo "PROJECT_DIR: $(PROJECT_DIR)"
	@echo "PROJECT_NAME: $(PROJECT_NAME)"
	@echo "CXX: $(CXX)"
	@echo "CXXFLAGS: $(CXXFLAGS)"
	@echo "CXXFLAGS_DEBUG: $(CXXFLAGS_DEBUG)"
	@echo "CXXFLAGS_BUILD: $(CXXFLAGS_BUILD)"
	@echo "SRC_DIR_NAME: $(SRC_DIR_NAME)"
	@echo "BUILD_DIR_NAME: $(BUILD_DIR_NAME)"
	@echo "DEBUG_DIR_NAME: $(DEBUG_DIR_NAME)"
	@echo "OBJ_DIR_NAME: $(OBJ_DIR_NAME)"
	@echo "TARGET_FILE_NAME: $(TARGET_FILE_NAME)"
	@echo "INCLUDE_LIBRARY: $(INCLUDE_LIBRARY)"
	@echo "INCLUDE_LIBRARY_CFLAGS: $(INCLUDE_LIBRARY_CFLAGS)"
	@echo "INCLUDE_LIBRARY_LIBS_FLAGS: $(INCLUDE_LIBRARY_LIBS_FLAGS)"
	@echo "DEFAULT_BUILD_DIR: $(DEFAULT_BUILD_DIR)"
	@echo "DEFAULT_BUILD_OBJ_DIR: $(DEFAULT_BUILD_OBJ_DIR)"
	@echo "DEFAULT_BUILD_TARGET: $(DEFAULT_BUILD_TARGET)"
	@echo "DEFAULT_DEBUG_DIR: $(DEFAULT_DEBUG_DIR)"
	@echo "DEFAULT_DEBUG_OBJ_DIR: $(DEFAULT_DEBUG_OBJ_DIR)"
	@echo "DEFAULT_DEBUG_TARGET: $(DEFAULT_DEBUG_TARGET)"
	@echo "DEFAULT_SRC_DIR: $(DEFAULT_SRC_DIR)"
	@echo "DEFAULT_SRC_FILES: $(DEFAULT_SRC_FILES)"
	@echo "DEFAULT_BUILD_OBJ_FILES: $(DEFAULT_BUILD_OBJ_FILES)"
	@echo "DEFAULT_DEBUG_OBJ_FILES: $(DEFAULT_DEBUG_OBJ_FILES)"
	@echo "ECLIPSE_BUILD_DIR: $(ECLIPSE_BUILD_DIR)"
	@echo "ECLIPSE_BUILD_OBJ_DIR: $(ECLIPSE_BUILD_OBJ_DIR)"
	@echo "ECLIPSE_DEBUG_DIR: $(ECLIPSE_DEBUG_DIR)"
	@echo "ECLIPSE_DEBUG_OBJ_DIR: $(ECLIPSE_DEBUG_OBJ_DIR)"
	@echo "ECLIPSE_BUILD_TARGET: $(ECLIPSE_BUILD_TARGET)"
	@echo "ECLIPSE_DEBUG_TARGET: $(ECLIPSE_DEBUG_TARGET)"
	@echo "MAKE_DEPS: $(MAKE_DEPS)"
	@echo "INCLUDE_DIR: $(INCLUDE_DIR)"
	@echo "INCLUDE_DIR_FLAGS: $(INCLUDE_DIR_FLAGS)"

.PHONY: all clean
clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR)


