

VAR := Aj

ifeq (,$(findstring d,p,j,$(VAR)))
	result:=not-found
else
	result:=found
endif
all:
	@echo $(result)
	
last:
	@echo $(VAR)

check:
	$(eval VAR += B)

