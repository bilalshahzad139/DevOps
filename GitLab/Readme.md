GitLab self hosted version can be installed by using different options. Here we'll see how to do it using docker option. https://docs.gitlab.com/omnibus/docker/

Here is quick step by step guide with some default configuration.

## Prerequisites

- Install docker & docker-compose ([Video Tutorial](https://www.youtube.com/watch?v=BYr22wnWdyU&ab_channel=LearnInUrdu))
	- https://get.docker.com/
	- https://docs.docker.com/compose/install/

- Pull gitlab ce docker image 
	> docker pull gitlab/gitlab-ce:latest
- Let say we've domain **gitlab.test.com** and mapped with IP **10.10.10.1**

## Setup

- We need to have a location where we want to store everything of GitLab. We’ll use this to mount while running the container. Let say **/data/gitlab**
- Create /data/gitlab/configure/ssl directory  
- Move certificate files (e.g. wildcard.crt & wildcard.key) to /data/gitlab/configure/ssl directory
- We need to set GITLAB_HOME environment variable. Let's do it permanently
  > touch /etc/profile.d/gitlab_home.sh
  
  > vi /etc/profile.d/gitlab_home.sh
- Add following in gitlab_home.sh file
  > export GITLAB_HOME=/data/gitlab
 - Create **docker-compose.yml** somewhere (e.g. /data/gitlabsetup) with [following content](docker-compose.yml)
 - Start containers
   > docker-compose up -d
 - It may take around 5 to 10 minutes. You may check logs to check the setup progress
   > docker logs gitlab --tail 10
- Check https://gitlab.test.com in browser
- Once it is online, it will ask for password of **root** user
- We often need to restart gitlab services after making any changes. **gitlab-ctl reconfigure** command is used for this.
  > docker exec gitlab gitlab-ctl reconfigure

- To Auto Start Docker on Reboot
  > sudo systemctl enable docker
  
  > sudo systemctl start docker
  
  > sudo systemctl enable /usr/lib/systemd/system/docker.service  
