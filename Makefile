SHELL := /usr/bin/env bash -O globstar

.PHONY: prepare-environment
prepare-environment:
	pnpm install

.PHONY: readme
readme: prepare-environment
	pnpm run readme:parameters
	pnpm run readme:lint

.PHONY: unittests-helm
unittests-helm:
	helm unittest --strict -f 'unittests/helm/**/*.yaml' -f 'unittests/helm/values-conflicting-checks.yaml' ./

.PHONY: helm
update-helm-dependencies:
	helm dependency update

.PHONY: yamllint
yamllint:
	yamllint -c .yamllint .