PREFIX ?= /usr/local
LIBDIR = $(PREFIX)/lib/transmission-tracker-add
DEFAULTDIR ?= /etc/default

OWNER ?= transmission
GROUP ?= $(OWNER)

install:
	install -D --owner $(OWNER) --group $(GROUP) --mode 0750 transmission-tracker-add.sh $(DESTDIR)$(LIBDIR)/transmission-tracker-add
	install -D --owner $(OWNER) --group $(GROUP) --mode 0640 transmission-tracker-add.default $(DESTDIR)$(DEFAULTDIR)/transmission-tracker-add

uninstall:
	rm --force --verbose $(DESTDIR)$(LIBDIR)/transmission-tracker-add
	rm --force --verbose $(DESTDIR)$(DEFAULTDIR)/transmission-tracker-add
	rmdir --verbose $(DESTDIR)$(LIBDIR)

.PHONY: install uninstall
