HOMEFILES := $(shell ls -A $(HOME))
DOTFILES := $(addprefix $(HOME)/,$(HOMEFILES))
ALIASES := ~/.bash_aliases
GITDIR := $(shell dirname $$PWD)

gitdir:
	@echo -n "Setting gitdir $(GITDIR) in $(ALIASES). [Y/n]" && read ans && [ $${ans:-Y} = Y ]
	$(shell echo "# set gitdir alias" >> $(ALIASES))
	$(shell echo "alias gitdir='cd $(GITDIR)'" >> $(ALIASES))

kube-ps1:
	$(shell wget https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh -O $(HOME)/kube-ps1/kube-ps1.sh)

link: # use this for making symlinks
