preview:
	npx zenn preview --port 8000

update:
	npm install zenn-cli@latest

setup:
	npm init --yes
	npm install zenn-cli

new:
	npx zenn new:article --slug <slug>

.PHONY: preview update setup new
