XORG_CONF_D = /usr/share/X11/xorg.conf.d
SYSCTL_CONF_D = /etc/sysctl.d
SSH_CONF_D = /etc/ssh

INSTALL := install --backup=numbered --suffix='.bak'

.PHONY:
default:
	@echo "Nothing to do by default"
	@exit 1

.PHONY: sysctl-conf
sysctl-conf: $(wildcard sysctl.d/*)
	$(INSTALL) -m 644 $? $(SYSCTL_CONF_D)

.PHONY: xorg-conf
xorg-conf: $(wildcard xorg.conf.d/*)
	$(INSTALL) -m 644 $? $(XORG_CONF_D)

.PHONY: ssh-conf
ssh-conf: $(wildcard ssh/*)
	$(INSTALL) -m 644 $? $(SSH_CONF_D)

.PHONY: the-platinum-searcher
the-platinum-searcher:
	make -C $@ install

.PHONY: oled-brightness
oled-brightness:
	make -C $@ install
