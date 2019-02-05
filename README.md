# CI-Jenkins

A CI-Jenkins base image with docker-in-docker enabled, Nodejs v11 & Golang v1.11.5 available.

# Setup your host

```bash
$ sudo mkdir -p /var/jenkins_home/{workspace,builds,jobs}
$ sudo chown -R 1000 /var/jenkins_home/ && sudo chmod -R a+rwx /var/jenkins_home/
```

# Run the container

```bash
$ docker-compose up --build --detach
```

# Complete the installation

- Connect to the running container as root:

```bash
$ docker exec -ti -u root ci-jenkins bash
```

- Now we are inside the container, run the following commands:

```bash
# change ownership of docker socket to jenkins user
$ chown jenkins /var/run/docker.sock

# exit
$ exit
```

- Test docker:

```bash
$ docker exec -ti ci-jenkins bash

# This command should display all docker containers
$ docker ps -a
```

## Logs

```bash
$ docker logs -f `docker ps -aqf "name=ci-jenkins"`
```

## Retrieve your ssh keys

```bash
$ docker exec -ti -u root ci-jenkins bash
$ cat /home/jenkins/.ssh/*
$ exit
```
