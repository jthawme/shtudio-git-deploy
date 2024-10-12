#!/bin/bash

# A wrapper to load nvm and start keychain
# to give the bash file access to node and the ssh agent

date | tee -a "/tmp/debug.log"
echo "TEST" | tee -a "/tmp/debug.log"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo $(node --version) | tee -a "/tmp/debug.log"

# Use keychain to keep ssh-agent information available in a file
/usr/bin/keychain $HOME/.ssh/id
source $HOME/.keychain/${HOSTNAME}-sh

echo "AGENT PID $SSH_AGENT_PID" | tee -a "/tmp/debug.log"

./check.sh "$@"


echo "-------" | tee -a "/tmp/debug.log"