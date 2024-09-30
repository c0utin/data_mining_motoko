build: deploy setup

deploy:
	dfx deploy

setup:
	dfx canister call dm_core setup_networks "(principal \"`dfx canister id dm_network`\")"

