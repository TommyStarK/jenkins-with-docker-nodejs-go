# CI-Jenkins

- Build the image

```bash
$ docker build . -t ci-jenkins:latest
```

- Run the container

```bash
$ docker run --detach --restart always --name ci-jenkins -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 ci-jenkins
```

- Finalize the install

Connect to the running container as root

```bash
$ docker exec -ti -u root ci-jenkins bash
```

Now we are inside the container, run the following commands

```bash
# change ownership of docker socket to jenkins user
$ chown jenkins /var/run/docker.sock

# install netcat/g++
$ sudo apt-get install -y g++ netcat
```


- Logs

```bash
$ docker logs -f `docker ps -aqf "name=ci-jenkins"`
```
