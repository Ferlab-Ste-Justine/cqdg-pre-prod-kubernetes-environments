#!/bin/sh

set -e

cp -r /opt/ssh/. /root/.ssh;
git clone ${GIT_REPO} . /opt/terraform;
git checkout ${GIT_BRANCH};