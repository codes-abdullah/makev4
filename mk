

VAR1 := x
VAR2 := B
MAKECMDGOALS := cleanRelease Release

ifeq ($(MAKECMDGOALS),$(filter $(MAKECMDGOALS),Release cleanRelease))
	result:=found
else
	result:=not-found
endif
all:
	@echo $(result)
	
last:
	@echo $(VAR)

check:
	$(eval VAR += B)

