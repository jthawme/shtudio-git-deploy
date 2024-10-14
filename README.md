# Git Automatic Deploy

This is a small bash script to usually place on a raspberry pi that can be instantiated from a cronjob or some other place to check if there are changes on a git branch, pull them and optionally stop and start a pm2 instance

## Dependencies / Assumptions

This script needs keychain installed, which manages the ssh agent in the cron user environment

```
sudo apt-get install keychain
```

It also utilises nvm to ensure node is installed

## Usage

```
crontab -e

# Add this line, it outputs all the echos into a cron.log file to debug
# Obviously replace with other variables

# * * * * * SCRIPT_LOCATION REMOTE_REPO_URL LOCAL_FOLDER PM2_NAME [BRANCH_NAME] [> OUTPUT_FILE 2>&1]
* * * * * $HOME/Desktop/shtudio-git-deploy/cron.sh git@github.com:jthawme/shtudio-dashboard.git $HOME/Desktop/shtudio-dashboard/ dashboard > /tmp/cron.log 2>&1
```
