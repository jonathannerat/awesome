TARGET = $(HOME)
OPTS = --dotfiles -v -t $(TARGET)

install:
	stow $(OPTS) stow/

uninstall: OPTS += -D
uninstall: install

.PHONY = install uninstall
