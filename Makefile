build: deploy setup

deploy:
	dfx deploy

setup:
	dfx canister call parsekoto_core setup_networks "(principal \"`dfx canister id parsekoto_network`\")"

