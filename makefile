preview:
	npx zenn preview

update:
	npm install zenn-cli@latest

setup:
	npm init --yes
	npm install zenn-cli

new:
	npx zenn new:article --slug <slug>

.PHONY: preview update setup new
