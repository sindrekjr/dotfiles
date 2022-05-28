HOMEFILES := $(shell ls -A $(HOME))
DOTFILES := $(shell ls -A dotfiles)
DOTENV := ~/.env
GITDIR := $(shell dirname $$PWD)

link: $(DOTFILES)

$(DOTFILES):
	$(eval DOT=$(PWD)/dotfiles/$@)
	$(eval HOMEDOT=$(HOME)/$@)
	@if [ -f $(HOMEDOT) ] || [ -d $(HOMEDOT) ]; then \
		echo -n "$(HOMEDOT) already exists. (O)verwrite, (r)ename, or (c)cancel? " && read ans; \
		[ -z $$ans ] && ans=o; \
		case $$ans in \
			o|O) \
				ln -sfn $(DOT) $(HOMEDOT);; \
			r|R) \
				mv -f $(HOMEDOT) $(HOMEDOT).save ; \
				ln -s $(DOT) $(HOMEDOT);; \
			c|C) \
				return;; \
			*) \
				echo invalid argument; exit 1;; \
		esac; \
	else \
		ln -s $(DOT) $(HOMEDOT); \
	fi; \
	echo "Linked $(HOMEDOT) to $(DOT)"; \

gitdir:
	@echo -n "Setting GITDIR=$(GITDIR) in $(DOTENV). [Y/n]" && read ans && [ $${ans:-Y} = Y ]
	$(shell echo "GITDIR=$(GITDIR)" >> $(DOTENV))

kube-ps1:
	$(shell curl https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh --create-dirs -o $(HOME)/.kube/.sh/kube-ps1.sh)

link: # use this for making symlinks
