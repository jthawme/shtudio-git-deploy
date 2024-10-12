#!/bin/bash

# A wrapper to load nvm and start keychain
# to give the bash file access to node and the ssh agent

date
echo "TEST"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo $(node --version)

# Use keychain to keep ssh-agent information available in a file
/usr/bin/keychain $HOME/.ssh/id
source $HOME/.keychain/${HOSTNAME}-sh

echo "AGENT PID $SSH_AGENT_PID"

REL=$(dirname "$0")

echo "$REL/check.sh"

/usr/bin/bash $REL/check.sh "$@"


echo "-------"