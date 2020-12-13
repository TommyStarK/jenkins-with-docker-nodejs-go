FROM jenkins/jenkins:lts

ARG docker_compose_version=1.27.4
ARG go_version=1.15
ARG node_version=12

ENV DOCKER_COMPOSE_VERSION ${docker_compose_version}
ENV GO_VERSION ${go_version}
ENV NODE_VERSION ${node_version}

USER root

    # Install dependencies
RUN apt-get update && apt-get -y install \
                apt-transport-https \
                ca-certificates \
                bash \
                curl \
                gnupg2 \
                gawk \
                netcat \
                build-essential \
                libssl-dev \
                software-properties-common && \
        # generate jenkins specific ssh key
        mkdir /root/.ssh && \
                cd /root/.ssh && \
                ssh-keygen -t rsa -N "" -f id_rsa && \
                cd - && \
        # add docker to apt repository
        curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
                add-apt-repository \
                "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
                $(lsb_release -cs) \
                stable" && \
        # fetch nodejs install script
        curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o nodesource_setup.sh && \
        bash nodesource_setup.sh && \
        rm nodesource_setup.sh && \
        # install docker && nodejs
        apt-get -y install \
                nodejs \
                docker-ce && \
        # install docker-compose
        curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
                && chmod +x /usr/local/bin/docker-compose && \
        # give jenkins docker rights
        usermod -aG docker jenkins && \
        # grant correct permissions to npm -g
        chown -R jenkins /usr/lib

WORKDIR /root

# setup go
RUN curl -O https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz \
        && tar -xvf go${GO_VERSION}.linux-amd64.tar.gz \
        && mv go /usr/local/go \
        && chown -R jenkins /usr/local/go \
        && mkdir -p /home/jenkins/go/ \
        && chown -R jenkins /home/jenkins/go/ \
        && echo $'\nexport GOROOT="/usr/local/go"\nexport GOPATH="/home/jenkins/go"\nexport PATH=$GOROOT/bin:$GOPATH/bin:$PATH\n' >> /root/.bashrc \
        && rm -rf go${GO_VERSION}.linux-amd64.tar.gz gocache tmp

USER jenkins

ENV GOROOT="/usr/local/go"
ENV GOPATH="/home/jenkins/go"
ENV PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"

WORKDIR ${JENKINS_HOME}
