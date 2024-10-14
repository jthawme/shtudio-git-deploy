#!/bin/bash

# A little script ideally run in a crontab to pull new git content
# stop a pm2 process and restart it after

GIT_REPO="$1"
LOCAL_FOLDER="$2"
LOCAL_REPO="${LOCAL_FOLDER}/.git"

# The name of the pm2 instance
PM2_NAME=$3

# Optionally pass another branch name in other than main
BRANCH=${4:-main}

if [ -z "${GIT_REPO}" ];
then
    echo "No git repo assigned"
    exit 1 
fi

if [ -z "${LOCAL_FOLDER}" ];
then
    echo "No local repo assigned"
    exit 1 
fi

LATEST_REMOTE=$(git ls-remote $GIT_REPO HEAD | cut -f1)
LATEST_LOCAL=$(git --git-dir $LOCAL_REPO rev-parse HEAD);


echo "LATEST REMOTE $LATEST_REMOTE"
echo "LATEST LOCAL $LATEST_LOCAL"

if [[ "$LATEST_REMOTE" != "$LATEST_LOCAL" ]];
then
    echo "New changes, running"
    # Commits dont match so presume there is new delicious content

    if [ -n "${PM2_NAME}" ];
    then
        pm2 stop $PM2_NAME
    fi

    # -C makes git act as if you were in that directory
    git -C $LOCAL_FOLDER pull origin $BRANCH
    npm --prefix $LOCAL_FOLDER ci $LOCAL_FOLDER

    if [ -n "${PM2_NAME}" ];
    then
        pm2 restart $PM2_NAME
    fi

    echo "New changes finished"
fi