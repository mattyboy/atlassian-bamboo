FROM buildpack-deps:jessie-scm

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.10.0
ENV NODE_HOME /usr/share/node
ENV NODE_URL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz"

ENV MAVEN_VERSION 3.3.9
ENV MAVEN_URL "http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz"
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "/root/.m2"

ENV BAMBOO_VERSION 6.0.3
ENV BAMBOO_HOME /opt/bamboo-home
ENV BAMBOO_INSTALL /var/local/atlassian/bamboo
ENV BAMBOO_URL "https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-$BAMBOO_VERSION.tar.gz"
ENV AWS_CLI /usr/local/aws

# allow replacing httpredir mirror, using AU mirror by default
ARG APT_MIRROR="ftp.monash.edu.au\/pub\/linux"

# install dependencies and set locale
RUN export DEBIAN_FRONTEND=noninteractive \
  && sed -i s/httpredir.debian.org/$APT_MIRROR/g /etc/apt/sources.list && apt-get update \
  && apt-get install -y --no-install-recommends locales ant ant-optional zip unzip xz-utils \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

# install maven
RUN mkdir -p ${MAVEN_HOME} ${MAVEN_HOME}/ref \
  && curl -fsSL $MAVEN_URL | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

# install node
RUN mkdir -p ${NODE_HOME} \
  && curl -fsSL $NODE_URL | tar -xJC /usr/share/node --strip-components=1 \
  && ln -s ${NODE_HOME}/bin/node /usr/bin/node \
  && ln -s ${NODE_HOME}/bin/npm /usr/bin/npm \
  && ln -s ${NODE_HOME}/bin/node /usr/local/bin/nodejs

# install aws cli
RUN mkdir -p $JAVA_HOME $AWS_CLI \
  && curl -o $AWS_CLI/awscli-bundle.zip -SL https://s3.amazonaws.com/aws-cli/awscli-bundle.zip \
  && unzip $AWS_CLI/awscli-bundle.zip -d $AWS_CLI && rm -f $AWS_CLI/awscli-bundle.zip \
  && $AWS_CLI/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# install bamboo
RUN mkdir -p $BAMBOO_INSTALL $BAMBOO_HOME \
  && curl -fsSL $BAMBOO_URL | tar -zxC $BAMBOO_INSTALL --strip-components=1

# set locales
ENV LANG en_US.UTF-8

# set java home
ENV JAVA_HOME /opt/java
ENV PATH $JAVA_HOME/bin:$PATH

VOLUME ["${BAMBOO_INSTALL}", "${BAMBOO_HOME}", "${MAVEN_CONFIG}"]
COPY docker-entrypoint.sh ${BAMBOO_INSTALL}/bin/
WORKDIR ${BAMBOO_INSTALL}

# default ports
EXPOSE 8085 54663

ENTRYPOINT ["bin/docker-entrypoint.sh"]
CMD ["bin/start-bamboo.sh", "-fg"]

