#!/bin/bash

# A little script ideally run in a crontab to pull new git content
# stop a pm2 process and restart it after

GIT_REPO="git@github.com:jthawme/shtudio-graphing.git"
LOCAL_FOLDER="$1"
LOCAL_REPO="${LOCAL_FOLDER}/.git"
PM2_NAME=$2
BRANCH=${3:-main}

if [ -z "${LOCAL_REPO}" ];
then
    printf '%s\n' "No local repo assigned" >&2  # write error message to stderr
    exit 1 
fi

if [ -z "${PM2_NAME}" ];
then
    printf '%s\n' "No pm2 name assigned" >&2  # write error message to stderr
    exit 1 
fi

LATEST_REMOTE=$(git ls-remote $GIT_REPO HEAD | cut -f1)
LATEST_LOCAL=$(git --git-dir $LOCAL_REPO rev-parse HEAD);

echo $LATEST_REMOTE
echo $LATEST_LOCAL

if [[ "$LATEST_REMOTE" != "$LATEST_LOCAL" ]];
then
    # Commits dont match so presume there is new delicious content
    pm2 stop $PM2_NAME
    git --git-dir $LOCAL_REPO pull origin $BRANCH
    npm --prefix $LOCAL_FOLDER ci $LOCAL_FOLDER
    pm2 restart $PM2_NAME
fi