# Dockerizing a base images with:
#
#   - Ubuntu 16.04 LTS (Focal Fossa)
#   - OpenJDK 14
#   - Python 5.5
#   - MongoDB

FROM  ubuntu:16.04
RUN apt-get update \
  && apt-get install -y wget \
  && apt-get install -y gosu \
  && apt-get install -y net-tools \
  && apt-get install -y vim \
  && apt-get install -y apt-transport-https \
  && apt-get install -y ca-certificates \
  && apt-get --no-install-recommends install -y software-properties-common

LABEL maintainer="Koray Platform"

# Install Python 3.5

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install python3.5 -y

# Make python 3.5 the default

RUN echo "alias python=python3.5" >> ~/.bashrc
RUN export PATH=${PATH}:/usr/bin/python3.5
RUN /bin/bash -c "source ~/.bashrc"

# Install pip

RUN apt-get install python3-pip -y
RUN pip3 install --upgrade pip
RUN rm -rf /var/lib/apt/lists/*


ENV DOWNLOAD_DIR /opt
ENV JDK_VERSION 14.0.1
ENV JDK_MAJOR_VERSION 14


# Install OpenJDK Java 14 SDK
ENV JVM_DIR /usr/lib/jvm
ENV OPT_DIR /opt
RUN mkdir -p "${JVM_DIR}"

COPY "openjdk-${JDK_VERSION}_linux-x64_bin.tar.gz" "${DOWNLOAD_DIR}/openjdk-${JDK_VERSION}-linux-x64.tar.gz"
  
RUN cd "${JVM_DIR}" \
  && tar --no-same-owner -xzf "${DOWNLOAD_DIR}/openjdk-${JDK_VERSION}-linux-x64.tar.gz" \
  && rm -f "${DOWNLOAD_DIR}/openjdk-${JDK_VERSION}-linux-x64.tar.gz" \
  && mv "${JVM_DIR}/jdk-${JDK_VERSION}" "${JVM_DIR}/java-${JDK_VERSION}-openjdk-x64" \
  && ln -s "${JVM_DIR}/java-${JDK_VERSION}-openjdk-x64" "${JVM_DIR}/java-${JDK_MAJOR_VERSION}-openjdk-x64"

ADD java-x64.jinfo ${JVM_DIR}/.java-x64.jinfo
RUN cat "${JVM_DIR}/.java-x64.jinfo" | grep -E '^(jre|jdk|hl)' | awk '{print "/usr/bin/" $2 " " $2 " " $3 " 30 \n"}' | xargs -t -n4 gosu root update-alternatives --install
ENV JAVA_HOME ${JVM_DIR}/java-${JDK_MAJOR_VERSION}-openjdk-x64

#INSTALL MongoDB

# Install MongoDB.

RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc > gpg
RUN apt-key add gpg
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | tee "/etc/apt/sources.list.d/mongodb-org-4.4.list"
RUN apt-get update
RUN apt-get install -y mongodb-org
RUN rm -rf /var/lib/apt/lists/*

# Define mountable directories.
#VOLUME ["/data/db"]


# Define working directory.
#WORKDIR /data

#COPY start.sh ./
#RUN chmod +x ./start.sh
#RUN /data/start.sh

############################

#RUN mkdir -p /yys/scripts

#WORKDIR /yys/scripts
#COPY start.sh ./
#RUN chmod +x ./start.sh
#RUN /yys/scripts/start.sh


# Define default command.
CMD ["mongod"]

# Expose ports.
#   - 27017: process
#   - 28017: http
