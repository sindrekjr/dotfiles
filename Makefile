HOMEFILES := $(shell ls -A $(HOME))
DOTFILES := $(addprefix $(HOME)/,$(HOMEFILES))
ALIASES := ~/.bash_aliases
GITDIR := $(shell dirname $$PWD)

gitdir:
	@echo -n "Setting GITDIR=$(GITDIR) in $(ALIASES). [Y/n]" && read ans && [ $${ans:-Y} = Y ]
	$(shell echo "# set GITDIR variable for gitdir.sh" >> $(ALIASES))
	$(shell echo "GITDIR=$(GITDIR)" >> $(ALIASES))

kube-ps1:
	$(shell curl https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh --create-dirs -o $(HOME)/kube-ps1/kube-ps1.sh)

link: # use this for making symlinks
