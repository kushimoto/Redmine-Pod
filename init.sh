#!/bin/sh

mkdir /opt/redmine-pod
mkdir /opt/redmine-pod/data
mkdir /opt/redmine-pod/data/app
mkdir /opt/redmine-pod/data/db

cp ./redmine-pod.yaml /opt/redmine-pod
cp ./redmine-pod.kube /usr/share/containers/systemd/
