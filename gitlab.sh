#!/bin/sh

dirname=gitlab-backup-$(date "+%Y-%m-%d-%H-%M-%S")
mkdir "$dirname"
cd $dirname

#change these vars:
privateToken=?
userName=?

curl --header "Private-Token: $privateToken" "https://gitlab.com/api/v4/users/$userName/projects" \
   | jq -r '.[] | .id, .name' \
   | while IFS= read projectId; read projectName; do
        curl --header "Private-Token: $privateToken" "https://gitlab.com/api/v4/projects/$projectId/repository/archive.zip" --output $projectName.zip
    done

echo Done! All files downloaded here: $(pwd)