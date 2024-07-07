################# for IDE's, uncomment one of below
#IDE:=CODE_BLOCKS
IDE:=ECLIPSE
BUILD_MODE:=debug
################# for non-IDE's, specify NO_IDE, either run or debug
#NO_IDE:=run
#NO_IDE:=debug
####
####
starts_millis := ./currentMillis.sh
PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
#remove trailing slash
PROJECT_DIR := $(PROJECT_DIR:/=)
PROJECT_NAME := $(notdir $(PROJECT_DIR))
CXX := g++
#################don't specify flags, will be inserted depending on IDE
CXXFLAGS :=
CXXFLAGS_DEBUG := -g -Wall -Wextra -Wno-unused-parameter 
CXXFLAGS_BUILD := -O0 -Wall -Wextra -Wno-unused-parameter
####
SRC_DIR_NAME := src
BUILD_DIR_NAME := build
DEBUG_DIR_NAME := debug
OBJ_DIR_NAME := obj
TARGET_FILE_NAME := $(PROJECT_NAME)
####
INCLUDE_LIBRARY := glfw3 glew
INCLUDE_LIBRARY_CFLAGS := $(shell pkg-config --cflags $(INCLUDE_LIBRARY))
INCLUDE_LIBRARY_LIBS_FLAGS := $(shell pkg-config --libs $(INCLUDE_LIBRARY))
#####
##### DEFAULT (NO_IDE) SETUP
#####
DEFAULT_BUILD_DIR := $(PROJECT_DIR)/$(BUILD_DIR_NAME)

ifeq ($(NO_IDE),run)
	CXXFLAGS += $(CXXFLAGS_BUILD)
else ifeq ($(NO_IDE),debug)
	DEFAULT_BUILD_DIR := $(PROJECT_DIR)/$(DEBUG_DIR_NAME)
	CXXFLAGS += $(CXXFLAGS_DEBUG)
endif

DEFAULT_BUILD_OBJ_DIR := $(DEFAULT_BUILD_DIR)/$(OBJ_DIR_NAME)
DEFAULT_BUILD_TARGET := $(DEFAULT_BUILD_DIR)/$(PROJECT_NAME)
####
DEFAULT_SRC_DIR := $(PROJECT_DIR)/$(SRC_DIR_NAME)
DEFAULT_SRC_FILES := $(shell find $(DEFAULT_SRC_DIR) -name '*.cpp' -or -name '*.c' -or -name '*.s')
DEFAULT_BUILD_OBJ_FILES := $(patsubst %.cpp, %.cpp.o, $(DEFAULT_SRC_FILES))
DEFAULT_BUILD_OBJ_FILES := $(subst $(DEFAULT_SRC_DIR),$(DEFAULT_BUILD_OBJ_DIR),$(DEFAULT_BUILD_OBJ_FILES))
####
MAKE_BUILD_DEPS := $(DEFAULT_BUILD_OBJ_FILES:.o=.d)
MAKE_DEBUG_DEPS := $(DEFAULT_DEBUG_OBJ_FILES:.o=.d)
INCLUDE_DIR := $(PROJECT_DIR)/include
INCLUDE_DIR_FLAGS := $(addprefix -I,$(INCLUDE_DIR))
CPPFLAGS ?= $(INCLUDE_DIR_FLAGS)





#####################3

	
define check
################# ECLIPSE SPECIFIC SETUP
ifeq ($(IDE),ECLIPSE)
ifeq ($(BUILD_MODE),run)
xxx+=A
DEFAULT_BUILD_DIR := $(DEFAULT_BUILD_DIR)/default
CXXFLAGS += $(CXXFLAGS_BUILD)
else ifeq ($(BUILD_MODE),debug)
xxx+=B
DEFAULT_BUILD_DIR := $(DEFAULT_BUILD_DIR)/make.debug.linux.x86_64
CXXFLAGS += $(CXXFLAGS_DEBUG)
else ifeq ($(BUILD_MODE),linuxtools)
xxx+=C
CFLAGS += -g -pg -fprofile-arcs -ftest-coverage
LDFLAGS += -pg -fprofile-arcs -ftest-coverage
EXTRA_CLEAN += $(PROJECT_NAME).gcda $(PROJECT_NAME).gcno $(PROJECT_ROOT)gmon.out
EXTRA_CMDS = rm -rf $(PROJECT_NAME).gcda
else
$(error ECLIPSE BUILD_MODE=$(BUILD_MODE) not supported by this Makefile)
endif
DEFAULT_BUILD_OBJ_DIR := $(DEFAULT_BUILD_DIR)/objXXXXXXXX
DEFAULT_BUILD_OBJ_FILES := $(patsubst %.cpp, %.cpp.o, $(DEFAULT_SRC_FILES))
DEFAULT_BUILD_OBJ_FILES := $(subst $(DEFAULT_SRC_DIR),$(DEFAULT_BUILD_OBJ_DIR),$(DEFAULT_BUILD_OBJ_FILES))
xxx+=ZZZZZZ
endif
#####
endef




$(eval $(check))
$(info $(xxx))





all: $(DEFAULT_BUILD_TARGET)

debug: all

################# CODE::BLOCKS SPECIFIC SETUP
Release: preRelease all
Debug: preDebug debug
preRelease:	
	$(eval DEFAULT_BUILD_DIR := $(PROJECT_DIR)/bin/Release)
	$(eval DEFAULT_BUILD_OBJ_DIR := $(PROJECT_DIR)/obj/Release)
	$(eval DEFAULT_BUILD_TARGET := $(DEFAULT_BUILD_DIR)/$(TARGET_FILE_NAME))
	$(eval CXXFLAGS += $(CXXFLAGS_BUILD))
preDebug:
	$(eval DEFAULT_BUILD_DIR := $(PROJECT_DIR)/bin/Debug)
	$(eval DEFAULT_BUILD_OBJ_DIR := $(PROJECT_DIR)/obj/Debug)
	$(eval DEFAULT_BUILD_TARGET := $(DEFAULT_BUILD_DIR)/$(TARGET_FILE_NAME))
	$(eval CXXFLAGS += $(CXXFLAGS_DEBUG))
#####
#####
#####



$(DEFAULT_BUILD_TARGET): $(DEFAULT_BUILD_OBJ_FILES)
	#@echo "linking now: $(DEFAULT_BUILD_TARGET)"
	#mkdir -p $(dir $(DEFAULT_BUILD_TARGET))
	
$(DEFAULT_BUILD_OBJ_DIR)/%.cpp.o: $(DEFAULT_SRC_DIR)/%.cpp
	mkdir -p $(dir $@)
	@echo "$< -o =====> $@"
	
	




#nothing set
ifeq ($(IDE),)
ifeq ($(NO_IDE),)
	$(error your must set IDE or NO_IDE)
endif
endif

#both set
ifneq ($(IDE),)
ifneq ($(NO_IDE),)
	$(error can't set IDE and NO_IDE at same time, use one of them only)
endif
endif

#unsupoorted IDE
ifeq ($(NO_IDE),)
ifneq ($(IDE),ECLIPSE)
ifneq ($(IDE),CODE_BLOCKS)
	$(error IDE=$(IDE) is unsupported)
endif
endif
endif

#unsupoorted NO_IDE
ifeq ($(IDE),)
ifneq ($(NO_IDE),run)
ifneq ($(NO_IDE),debug)
	$(error NO_IDE=$(NO_IDE) is unsupported)
endif
endif
endif


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
	@echo "DEFAULT_SRC_DIR: $(DEFAULT_SRC_DIR)"
	@echo "DEFAULT_SRC_FILES: $(DEFAULT_SRC_FILES)"
	@echo "DEFAULT_BUILD_OBJ_FILES: $(DEFAULT_BUILD_OBJ_FILES)"
	@echo "DEFAULT_DEBUG_OBJ_FILES: $(DEFAULT_DEBUG_OBJ_FILES)"
	@echo "MAKE_BUILD_DEPS: $(MAKE_BUILD_DEPS)"
	@echo "MAKE_DEBUG_DEPS: $(MAKE_DEBUG_DEPS)"
	@echo "INCLUDE_DIR: $(INCLUDE_DIR)"
	@echo "INCLUDE_DIR_FLAGS: $(INCLUDE_DIR_FLAGS)"
	@echo "xxx: $(xxx)"

.PHONY: all clean
clean:
	rm -rf $(DEFAULT_BUILD_OBJ_DIR) $(DEFAULT_BUILD_DIR)
	rm -rf $(PROJECT_DIR)/$(BUILD_DIR_NAME) $(PROJECT_DIR)/$(DEBUG_DIR_NAME)


