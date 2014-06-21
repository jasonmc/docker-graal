FROM dockerfile/ubuntu

RUN apt-get update
RUN apt-get -y install python mercurial

# Install Java.
RUN \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  apt-get install -y oracle-java8-installer

RUN mkdir /data
RUN cd /data && hg clone http://hg.openjdk.java.net/graal/graal

# /usr/lib/jvm/java-8-oracle/jre

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/
ENV EXTRA_JAVA_HOMES /usr/lib/jvm/java-7-oracle/

RUN \
  cd /data/graal && \
  ./mx.sh --vm server build

# Define mountable directories.
# VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["bash"]
