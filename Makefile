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

KUBECTX := kubectx kubens

kube: kube-ps1 kubectl $(KUBECTX)

kube-ps1:
	@curl https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh --create-dirs -o $(HOME)/.kube/.sh/kube-ps1.sh

kubectl:
	@curl -L "https://dl.k8s.io/release/$(shell curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /tmp/kubectl
	@curl -L "https://dl.k8s.io/$(shell curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" -o /tmp/kubectl.sha256
	@echo "$$(cat /tmp/kubectl.sha256) /tmp/kubectl" | sha256sum --check
	@sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
	@rm /tmp/kubectl /tmp/kubectl.sha256

$(KUBECTX):
	@sudo curl https://raw.githubusercontent.com/ahmetb/kubectx/master/$@ -o /usr/local/bin/$@
	@sudo chown $$USER:$$USER /usr/local/bin/$@
	@sudo chmod +x /usr/local/bin/$@
