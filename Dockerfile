#FROM whitesourcesoftware/ua-base:v2
FROM ubuntu:18.04

LABEL version="1.0.1"
LABEL repository="https://github.com/TheAxZim/Whitesource-Scan-Action"
LABEL maintainer="Azeem Shezad Ilyas <azeemilyas@hotmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH 	    	$JAVA_HOME/bin:$PATH
ENV LANGUAGE	en_US.UTF-8
ENV LANG    	en_US.UTF-8
ENV LC_ALL  	en_US.UTF-8

### Install wget, curl, git, unzip, gnupg, locales
RUN apt-get update && \
	apt-get -y install \
      curl \
      git \
      gnupg \
      locales  \
      unzip \
      wget \
    && locale-gen en_US.UTF-8 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*


### Install Java openjdk 8
RUN echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu bionic main" | tee /etc/apt/sources.list.d/ppa_openjdk-r.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys DA1A4A13543B466853BAF164EB9B1D8886F44E2A && \
    apt-get update && \
    apt-get -y install openjdk-8-jdk && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### Install Node.js (16.x) + NPM (8.x)
RUN apt-get update && \
	curl -sL https://deb.nodesource.com/setup_16.x | bash && \
    apt-get install -y nodejs build-essential && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

RUN apt-get update && apt-get install -y jq

#### Install GO:
ARG GOLANG_VERSION=1.17.6
RUN mkdir -p goroot && \
   curl https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1
### Set GO environment variables
ENV GOROOT goroot
ENV GOPATH gopath
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
COPY list-project-alerts.sh /list-project-alerts.sh

ENTRYPOINT ["/entrypoint.sh"]
