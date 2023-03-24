SHELL := /bin/bash

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: login
login:
	gh auth login --hostname github.com --git-protocol ssh --web

.PHONY: new-tag
new-tag: ## Add $(TAG) for $(COMMIT) and push it to $(REMOTE).
ifndef TAG
	$(error TAG is undefined, set the it in the vX.Y.Z format)
endif
ifndef COMMIT
	$(error COMMIT is undefined, set the commit to be tagged)
endif
ifndef REMOTE
	$(error REMOTE is undefined, set the remote where the tag should be pushed)
endif
	git tag -a $(TAG) -s -m "Version $(TAG)" $(COMMIT)
	git push $(REMOTE) $(TAG)

GDI_REPOS := $(shell cat repositories.txt)
TMP_DIR = tmp

.PHONY: create-issues
create-issues: login ## Create 'Adopt GDI specification $(TAG)' GitHub issues for all related repositories.
ifndef TAG
	$(error TAG is undefined, set the it in the vX.Y.Z format)
endif
	rm -rf $(TMP_DIR)
	$(foreach repo,$(GDI_REPOS),\
		gh repo clone $(repo) $(TMP_DIR) && \
		cd $(TMP_DIR) && \
		gh repo set-default $(repo) && \
		gh issue create --title 'Adopt GDI specification $(TAG)' --body 'Adopt https://github.com/signalfx/gdi-specification/releases/tag/$(TAG)' && \
		cd - && \
		rm -rf $(TMP_DIR);)
