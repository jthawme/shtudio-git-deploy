#!/bin/bash

# A little script ideally run in a crontab to pull new git content
# stop a pm2 process and restart it after

GIT_REPO="$1"
LOCAL_FOLDER="$2"
LOCAL_REPO="${LOCAL_FOLDER}/.git"
PM2_NAME=$3
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

if [ -z "${PM2_NAME}" ];
then
    echo "No pm2 name assigned"
    exit 1 
fi

LATEST_REMOTE=$(git ls-remote $GIT_REPO HEAD | cut -f1)
LATEST_LOCAL=$(git --git-dir $LOCAL_REPO rev-parse HEAD);

if [[ "$LATEST_REMOTE" != "$LATEST_LOCAL" ]];
then
    echo "New changes, running"
    # Commits dont match so presume there is new delicious content
    pm2 stop $PM2_NAME
    git -C $LOCAL_FOLDER pull origin $BRANCH
    npm --prefix $LOCAL_FOLDER ci $LOCAL_FOLDER
    pm2 restart $PM2_NAME
    echo "New changes finished"
fi

date