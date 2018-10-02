FROM ubuntu:xenial

# Java Env Variables
ENV JAVA_VERSION="1.8.0_181"
ENV JAVA_TARBALL="server-jre-8u181-linux-x64.tar.gz"
ENV JAVA_HOME="/opt/java/jdk${JAVA_VERSION}"
ENV JAVA_MAGIC="96a7b8442fe848ef90c96a2fad6ed6d1"
ENV JAVA_VERSION_BUILD="8u181-b13"

# Make Ubuntu clean again
RUN echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean
RUN echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean
RUN echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install wget

# Install Java
RUN wget -q --directory-prefix=/tmp --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
            http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_BUILD}/${JAVA_MAGIC}/${JAVA_TARBALL}
RUN mkdir -p /opt/java && tar -xzf /tmp/${JAVA_TARBALL} -C /opt/java/
RUN update-alternatives --install "/usr/bin/java" "java" "/opt/java/jdk${JAVA_VERSION}/bin/java" 100 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/opt/java/jdk${JAVA_VERSION}/bin/javac" 100 && \
    update-alternatives --set java /opt/java/jdk${JAVA_VERSION}/bin/java && \
    update-alternatives --set javac /opt/java/jdk${JAVA_VERSION}/bin/javac
