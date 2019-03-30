deps_config := \
	vgasrc/Kconfig \
	/home/osdi/osdi/linux-0.11/seabios/src/Kconfig

include/config/auto.conf: \
	$(deps_config)


$(deps_config): ;
