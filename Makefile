HOMEFILES := $(shell ls -A $(HOME))
DOTFILES := $(shell ls -A dotfiles)

# Am I Windows?
ifeq ($(OS),Windows_NT)
  HOME := $(shell echo $$HOME)
endif


## ---------------------------------------------------------------
## Automated symlinks; recurses through every object in the
## dotfiles directory and creates links in the user's home dir
## for each. If a given file already exists in home, prompt for
## user input (overwrite/rename/cancel).
## ---------------------------------------------------------------
link: $(DOTFILES)

$(DOTFILES):
	$(eval DOT=$(PWD)/dotfiles/$@)
	$(eval HOMEDOT=$(HOME)/$@)
	@if [ -f $(HOMEDOT) ] || [ -d $(HOMEDOT) ]; then \
		echo -n "Home already contains $(DOT). (O)verwrite, (r)ename, or (c)cancel? " && read ans; \
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
				echo " ! Fail ! invalid argument: $$ans"; exit 1;; \
		esac \
	else \
		ln -s $(DOT) $(HOMEDOT); \
	fi; \
	echo " - Success - linked $(HOMEDOT) to $(DOT)"; \


## ---------------------------------------------------------------
## Kubernetes stuff, installs and configures the following
## - kubectl
## - kubectx
## - kubens
## - kind
## ---------------------------------------------------------------
KUBECTX := kubectx kubens

kube: kube-ps1 kubectl $(KUBECTX)

kind:
	@curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
	@chmod +x /tmp/kind
	@sudo mv /tmp/kind /usr/local/bin/kind
	@echo " - Success - installed kind"

kube-ps1:
	@curl https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh --create-dirs -o $(HOME)/.kube/.sh/kube-ps1.sh

kubectl:
	@curl -Lo /tmp/kubectl "https://dl.k8s.io/release/$(shell curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	@curl -Lo /tmp/kubectl.sha256 "https://dl.k8s.io/$(shell curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
	@echo "$$(cat /tmp/kubectl.sha256) /tmp/kubectl" | sha256sum --check
	@sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
	@rm /tmp/kubectl /tmp/kubectl.sha256
	@echo " - Success - installed kubectl"

$(KUBECTX):
	@curl https://raw.githubusercontent.com/ahmetb/kubectx/master/$@ -o /tmp/$@
	@chmod +x /tmp/$@
	@sudo mv /tmp/$@ /usr/local/bin/$@
	@echo " - Success - installed $@"


## ---------------------------------------------------------------
## Environment variables; initialized in a ~/.env file
## ---------------------------------------------------------------
DOTENV := ~/.env
GITDIR := $(shell dirname $$PWD)

env: gitdir

gitdir:
	@echo -n "Setting GITDIR=$(GITDIR) in $(DOTENV). [Y/n]" && read ans && [ $${ans:-Y} = Y ]
	$(shell echo "GITDIR=$(GITDIR)" >> $(DOTENV))
