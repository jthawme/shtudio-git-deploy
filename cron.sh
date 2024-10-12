#!/bin/bash

# A wrapper to load nvm and start keychain
# to give the bash file access to node and the ssh agent

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use keychain to keep ssh-agent information available in a file
/usr/bin/keychain $HOME/.ssh/id
source $HOME/.keychain/${HOSTNAME}-sh

./check.sh "$@"