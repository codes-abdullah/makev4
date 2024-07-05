
####################
PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
#remove trailing slash
PROJECT_DIR := $(PROJECT_DIR:/=)
PROJECT_NAME := $(notdir $(PROJECT_DIR))
CXX := g++
#don't specify flags, will be inserted depending on IDE
CXXFLAGS :=
CXXFLAGS_DEBUG := -g -Wall -Wextra -Wno-unused-parameter 
CXXFLAGS_RUN := -O0 -Wall -Wextra -Wno-unused-parameter
####################
SRC_DIR_NAME := src
BUILD_DIR_NAME := build
DEBUG_DIR_NAME := build
OBJ_DIR_NAME := obj
TARGET_FILE_NAME := $(PROJECT_NAME)
####################
INCLUDE_LIBRARY := glfw3 glew
INCLUDE_LIBRARY_CFLAGS := $(shell pkg-config --cflags $(INCLUDE_LIBRARY))
INCLUDE_LIBRARY_LIBS_FLAGS := $(shell pkg-config --libs $(INCLUDE_LIBRARY))
####################
DEFAULT_BUILD_DIR := $(PROJECT_DIR)/$(BUILD_DIR_NAME)
DEFAULT_DEBUG_DIR := $(PROJECT_DIR)/$(DEBUG_DIR_NAME)
DEFAULT_OBJ_DIR := $(DEFAULT_BUILD_DIR)/$(OBJ_DIR_NAME)
DEFAULT_BUILD_TARGET := $(DEFAULT_BUILD_DIR)/$(PROJECT_NAME)
DEFAULT_DEBUG_TARGET := $(DEFAULT_BUILD_DIR)/$(PROJECT_NAME)

BUILD_DIR := $(PROJECT_DIR)/$(BUILD_DIR_NAME)
OBJ_DIR := $(BUILD_DIR)/$(OBJ_DIR_NAME)
TARGET := $(BUILD_DIR)/$(TARGET_FILE_NAME)
SRC_DIR := $(PROJECT_DIR)/$(SRC_DIR_NAME)
#SRC_DIRS := $(shell find $(SRC_DIR) -not -empty -type d)
#SRC_DIRS_FLAGS := $(addprefix -I,$(SRC_DIRS))
SRC_FILES := $(shell find $(SRC_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')
OBJ_FILES := $(patsubst %.cpp, %.cpp.o, $(SRC_FILES))
OBJ_FILES := $(subst $(SRC_DIR),$(OBJ_DIR),$(OBJ_FILES))
starts_millis := $(shell date +%s%N | cut -b1-13)
####################
ECLIPSE_BUILD_DIR := $(BUILD_DIR)/default
ECLIPSE_BUILD_OBJ_DIR := $(ECLIPSE_BUILD_DIR)/obj
ECLIPSE_DEBUG_DIR := $(BUILD_DIR)/make.debug.linux.x86_64
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
	@echo "SRC_DIR: $(SRC_DIR)"
	@echo "SRC_FILES: $(SRC_FILES)"
	@echo "BUILD_DIR: $(BUILD_DIR)"
	@echo "OBJ_DIR: $(OBJ_DIR)"
	@echo "OBJ_FILES: $(OBJ_FILES)"
	@echo "INCLUDE_DIR: $(INCLUDE_DIR)"
	@echo "INCLUDE_DIR_FLAGS: $(INCLUDE_DIR_FLAGS)"
	@echo "MAKE_DEPS: $(MAKE_DEPS)"
	@echo "CPP_FLAGS: $(CPP_FLAGS)"
	@echo "INCLUDE_LIBRARY: $(INCLUDE_LIBRARY)"
	@echo "INCLUDE_LIBRARY_LIBS_FLAGS: $(INCLUDE_LIBRARY_LIBS_FLAGS)"
	@echo "INCLUDE_LIBRARY_CFLAGS: $(INCLUDE_LIBRARY_CFLAGS)"
	@echo "TRARGET: $(TARGET)"
	@echo "ECLIPSE_BUILD_DIR: $(ECLIPSE_BUILD_DIR)"
	@echo "ECLIPSE_BUILD_OBJ_DIR: $(ECLIPSE_BUILD_OBJ_DIR)"
	@echo "ECLIPSE_BUILD_TARGET: $(ECLIPSE_BUILD_TARGET)"
	@echo "ECLIPSE_DEBUG_OBJ_DIR: $(ECLIPSE_DEBUG_OBJ_DIR)"
	@echo "ECLIPSE_DEBUG_DIR: $(ECLIPSE_DEBUG_DIR)"
	@echo "ECLIPSE_DEBUG_TARGET: $(ECLIPSE_DEBUG_TARGET)"	

.PHONY: all clean
clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR)


