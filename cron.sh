#!/bin/bash

# A wrapper to load nvm and start keychain
# to give the bash file access to node and the ssh agent

date

# Start up nvm, to use node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo $(node --version)

# Use keychain to keep ssh-agent information available in a file
/usr/bin/keychain $HOME/.ssh/id
source $HOME/.keychain/${HOSTNAME}-sh

# Echos the ssh agent, for debug purposes to check the agent is running
echo "AGENT PID $SSH_AGENT_PID"

# Call the main check file
REL=$(dirname "$0")
echo "$REL/check.sh"

/usr/bin/bash $REL/check.sh "$@"

echo "-------"