# CI-Jenkins

A docker-in-docker for CI using Jenkins.

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

# install netcat/g++
$ sudo apt-get install -y g++ netcat

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
