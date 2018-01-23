BASE ?= https://github.com/monochromegane/the_platinum_searcher/releases/download
VERSION ?= 2.1.5

PREFIX ?= ~/.local/bin



.PHONY: v$(VERSION)/pt_linux_amd64.tar.gz
v$(VERSION)/pt_linux_amd64.tar.gz:

pt_linux_amd64.tar.gz: v$(VERSION)/pt_linux_amd64.tar.gz
	curl -sSL -o $@ $(BASE)/$<

pt_linux_amd64/pt: pt_linux_amd64.tar.gz
	tar xf $< && test -f $@

install: pt_linux_amd64/pt
	install -m 744 $< $(PREFIX)
