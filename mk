
SKY := blue
define defThings
	$(shell echo "aa")
	ifneq ($(SKY),blue)
		$(error not declared, found: '$(SKY)')
	endif
endef


$(info sky is $(SKY))


all:
	$(eval $(call defThings))
