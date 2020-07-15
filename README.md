# repo-backup

Backup all Github & Gitlab repositories as .zip files 

## Github Backup

### Create an Access Token

On github.com, go to your profile -> Settings -> Developer Settings -> Personal access tokens

Click on Generate a personal access token 

**Name**: *backup* (it doesn't matter)
**Scopes**: *repo* & *read:user* 

Then click on Generate token

![alt github.png](https://github.com/alexadam/repo-backup/blob/master/screenshots/github.png?raw=true)

### Run the backup script

After the token is generated, paste it in the script below:

```sh
#!/bin/sh

dirname=github-backup-$(date "+%Y-%m-%d-%H-%M-%S")
mkdir "$dirname"
cd $dirname

#change these vars:
privateToken=YOUR_ACCESS_TOKEN
userName=YOUR_GITHUB_USERNAME

curl -H "Accept: application/vnd.github.nebula-preview+json" \
    -H "Authorization: token $privateToken" \
    "https://api.github.com/user/repos?visibility=all&affiliation=owner&per_page=200" \
    | jq -r '.[] | .name' \
    | while IFS= read projectName; do
        curl -H "Authorization: token $privateToken" -H "Accept: application/vnd.github.v3.raw" -L \
         "https://api.github.com/repos/$userName/$projectName/zipball" --output $projectName.zip
     done

echo Done! All files downloaded here: $(pwd)
```

Then run the script with `sh github.sh` or `./github.sh` (`chmod +x github.sh` might be needed)

## Gitlab Backup

### Create an Access Token

On gitlab.com, go to your profile -> Settings -> Access Tokens and create a new Access Token

**Name**: *backup* (it doesn't matter)
**Expires at**: tomorrow (or later, if you want to reuse it)
**Scopes**: *read_api* & *read_repository* 

Then click on Create personal access token

![alt gitlab.png](https://github.com/alexadam/repo-backup/blob/master/screenshots/gitlab.png?raw=true)

### Run the backup script

After the token is generated, paste it in the script below:

```sh
#!/bin/sh

dirname=gitlab-backup-$(date "+%Y-%m-%d-%H-%M-%S")
mkdir "$dirname"
cd $dirname

privateToken=YOUR_ACCESS_TOKEN
userName=YOUR_GITLAB_USERNAME

curl --header "Private-Token: $privateToken" "https://gitlab.com/api/v4/users/$userName/projects" \
   | jq -r '.[] | .id, .name' \
   | while IFS= read projectId; read projectName; do
        curl --header "Private-Token: $privateToken" "https://gitlab.com/api/v4/projects/$projectId/repository/archive.zip" --output $projectName.zip
    done

echo Done! All files downloaded here: $(pwd)
```

Then run the script with `sh gitlab.sh` or `./gitlab.sh` (`chmod +x gitlab.sh` might be needed)