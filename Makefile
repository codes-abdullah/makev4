
####################
PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
#remove trailing slash
PROJECT_DIR := $(PROJECT_DIR:/=)
PROJECT_NAME := $(notdir $(PROJECT_DIR))
CXX := g++
#don't specify -O0 or -g flags, will be inserted depending on IDE
CXXFLAGS := -Wall -Wextra -Wno-unused-parameter
####################
SRC_DIR_NAME := src
BUILD_DIR_NAME := build
OBJ_DIR_NAME := obj
TARGET_FILE_NAME := $(PROJECT_NAME)
####################
INCLUDE_LIBRARY := glfw3 glew
INCLUDE_LIBRARY_CFLAGS := $(shell pkg-config --cflags $(INCLUDE_LIBRARY))
INCLUDE_LIBRARY_LIBS_FLAGS := $(shell pkg-config --libs $(INCLUDE_LIBRARY))
####################
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
#####################
MAKE_DEPS := $(OBJ_FILES:.o=.d)
INCLUDE_DIR := $(PROJECT_DIR)/include
INCLUDE_DIR_FLAGS := $(addprefix -I,$(INCLUDE_DIR))
CPPFLAGS ?= $(INCLUDE_DIR_FLAGS)
#####################
##################### ECLIPSE SPECIFIC MODE SETUP
#####################
ifeq ($(BUILD_MODE),debug)
	CXXFLAGS += -g
else ifeq ($(BUILD_MODE),run)
	CXXFLAGS += -02
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
	$(eval CXXFLAGS += -02)
postRelease:
	#move files to obj and bin dirs
preDebug:
	$(eval CXXFLAGS += -g)
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
	@echo "Millis: $(millis)"

.PHONY: all clean
clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR)


