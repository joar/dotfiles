XORG_CONF_D = /usr/share/X11/xorg.conf.d
SYSCTL_CONF_D = /etc/sysctl.d

.PHONY:
default:
	@echo "Nothing to do by default"
	@exit 1

.PHONY: sysctl-conf
sysctl-conf: $(wildcard sysctl.d/*)
	install -m 644 $? $(SYSCTL_CONF_D)

.PHONY: xorg-conf
xorg-conf: $(wildcard xorg.conf.d/*)
	install -m 644 $? $(XORG_CONF_D)
