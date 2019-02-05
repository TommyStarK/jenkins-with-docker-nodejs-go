FROM jenkins/jenkins:lts

ARG user=jenkins

USER root

# prerequisites for docker
RUN apt-get update \
    && apt-get -y install \
        apt-transport-https \
        ca-certificates \
        bash \
        curl \
        gnupg2 \
        build-essential \
        libssl-dev \
        software-properties-common \
        gcc \
        g++ \
	gawk \
        netcat \
        nano \
        make  && \
        # nodejs
        curl -sL https://deb.nodesource.com/setup_11.x -o nodesource_setup.sh && \
        bash nodesource_setup.sh && \
        apt-get -y install nodejs && \
        # docker repos
        curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
                add-apt-repository \
                "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
                $(lsb_release -cs) \
                stable" && \
                apt-get update && \
        # docker
        apt-get -y install docker-ce && \
        # docker-compose
        curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
                && chmod +x /usr/local/bin/docker-compose && \
        # give jenkins docker rights
        usermod -aG docker jenkins && \
        # create a folder to hold jenkins ssh keys
        mkdir -p /home/${user}/.ssh

WORKDIR  /home/${user}/.ssh

# generate ssh keys
RUN ssh-keygen -t rsa -N "" -f id_rsa

WORKDIR /root

# setup go
RUN curl -O https://storage.googleapis.com/golang/go1.11.5.linux-amd64.tar.gz \
        && tar -xvf go1.11.5.linux-amd64.tar.gz \
        && mv go /usr/local/go \
        && chown -R ${user} /usr/local/go \
        && mkdir -p /home/${user}/go/ \
        && chown -R ${user} /home/${user}/go/ \
        && echo $'\nexport GOROOT="/usr/local/go"\nexport GOPATH="/home/jenkins/go"\nexport PATH=$GOROOT/bin:$GOPATH/bin:$PATH\n' >> /root/.bashrc \
        && rm -rf go1.11.5.linux-amd64.tar.gz gocache tmp

USER ${user}

ENV GOROOT="/usr/local/go"
ENV GOPATH="/home/jenkins/go"
ENV PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"

WORKDIR /home/${user}
