#!/bin/sh

set -e

cp -r /opt/ssh/. /root/.ssh;
mkdir /opt/clone-dir
git clone ${GIT_REPO} /opt/clone-dir;
(
    cd /opt/clone-dir;
    git checkout ${GIT_BRANCH};
    if [ ! -z "$GIT_PATH" ]; then
        cp -r /opt/clone-dir/${GIT_PATH}/* /opt/terraform/
    else
        cp -r /opt/clone-dir/* /opt/terraform/
    fi
)