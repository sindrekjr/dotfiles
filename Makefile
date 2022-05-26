HOMEFILES := $(shell ls -A $(HOME))
DOTFILES := $(addprefix $(HOME)/,$(HOMEFILES))
GITDIR := $(shell dirname $$PWD)

ifneq (,$(findstring .bash_profile,$(HOMEFILES)))
	PROFILE := ~/.bash_profile
else ifneq (,$(findstring .bash_login,$(HOMEFILES)))
	PROFILE := ~/.bash_login
else ifneq (,$(findstring .profile,$(HOMEFILES)))
	PROFILE := ~/.profile
endif

gitdir:
	@echo -n "Setting gitdir $(GITDIR) in $(PROFILE). [Y/n]" && read ans && [ $${ans:-Y} = Y ]
	$(shell echo "\n# set gitdir alias" >> $(PROFILE))
	$(shell echo "alias gitdir='cd $(GITDIR)'" >> $(PROFILE))

kube-ps1:
	$(shell wget https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh -O $(HOME)/kube-ps1/kube-ps1.sh)

link: # use this for making symlinks
