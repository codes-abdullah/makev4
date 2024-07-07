
SKY := blue
define defThings :=
xxx:=a
endef


$(info sky is $(SKY))


all:
	$(eval $(call defThings,""))
	echo $(xxx)
