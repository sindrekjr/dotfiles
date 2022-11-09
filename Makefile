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
	@if [ -d $(HOMEDOT) ]; then \
		rm -r $(HOMEDOT); \
	fi;
	@ln -sfn $(DOT) $(HOMEDOT)
	@echo " - Success - linked $(HOMEDOT) to $(DOT)"


## ---------------------------------------------------------------
## GitHub CLI
## ---------------------------------------------------------------
ghcli:
	@curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	@echo "deb [arch=$(shell dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
	@sudo apt update
	@sudo apt install gh


## ---------------------------------------------------------------
## .NET
## ---------------------------------------------------------------
DOTNET_VERSION ?= 6.0

dotnet-sdk:
	@sudo apt update
	sudo apt install -y dotnet-sdk-$(DOTNET_VERSION)


## ---------------------------------------------------------------
## Node Version Manager
## ---------------------------------------------------------------
nvm:
	@curl -o- https://raw.githubusercontent.com/creationix/nvm/$(shell basename $$(curl -fs -o/dev/null -w %{redirect_url} https://github.com/nvm-sh/nvm/releases/latest))/install.sh | bash


## ---------------------------------------------------------------
## Kubernetes stuff; installs and configures the following
## - kubectl
## - kubectx
## - kubens
## - kube-ps1
## - kubectl-krew
## ---------------------------------------------------------------
KUBECTX := kubectx kubens

kube: kubectl $(KUBECTX) kube-ps1 kubectl-krew

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

kube-ps1:
	@curl https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh --create-dirs -o $(HOME)/.kube/.sh/kube-ps1.sh

kubectl-krew:
	set -x; cd "$$(mktemp -d)" && \
	OS="$$(uname | tr '[:upper:]' '[:lower:]')" && \
	ARCH="$$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$$/arm64/')" && \
	KREW="krew-$${OS}_$${ARCH}" && \
	curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/$${KREW}.tar.gz" && \
	tar zxvf "$${KREW}.tar.gz" && \
	./"$${KREW}" install krew;

# ---------------------------------------------------------------
# Optional Kubernetes stuff
# - kubectl-graph
# - kind
# ---------------------------------------------------------------
kubectl-graph:
	@kubectl krew install graph
	@sudo apt install graphviz

kind:
	@curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
	@chmod +x /tmp/kind
	@sudo mv /tmp/kind /usr/local/bin/kind
	@echo " - Success - installed kind"


## ---------------------------------------------------------------
## Environment variables; initialized in a ~/.env file
## ---------------------------------------------------------------
DOTENV := ~/.env
GITDIR := $(shell dirname $$PWD)

env: gitdir

gitdir:
	@echo -n "Setting GITDIR=$(GITDIR) in $(DOTENV). [Y/n]" && read ans && [ $${ans:-Y} = Y ]
	$(shell echo "GITDIR=$(GITDIR)" >> $(DOTENV))
