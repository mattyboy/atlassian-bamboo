# Details
Note: You must supply the jdk for bamboo using -v /path/to/jdk1.8:/opt/java

Atlassian Bamboo container with the following Debian packages installed:

- ant
- ant-optional
- mercurial
- git
- curl
- zip
- unzip
- openssh-client

## Additional software:

Latest version of https://s3.amazonaws.com/aws-cli/awscli-bundle.zip

# Basic Usage
How to startup a specific version of bamboo and expose http port to host

    docker run -v /path/to/jdk1.8:/opt/java -v /path/to/bamboo-home:/opt/bamboo-home -p 8085:8085 --name bamboo -d mattyboy/atlassian-bamboo:5.9
    
# Advanced Usage

    docker run --name bamboo \
      -v /path/to/jdk1.8.0_101:/opt/java \
      -v /path/to/bamboo-home:/opt/bamboo-home \
      -v /path/to/server.xml:/var/local/atlassian/bamboo/conf/server.xml:ro \
      -v /path/to/setenv.sh:/var/local/atlassian/bamboo/bin/setenv.sh:ro \
      -v /data/bamboo/capabilities:/opt/capabilities \
      -e TZ=Australia/Melbourne \
      --restart=always -d mattyboy/atlassian-bamboo:5.9

In this example we have

- mapped external JDK to /opt/java
- mapped external bamboo-home folder to container
- replaced the default server.conf with a customised version
- replaced the default setenv.sh with a customised version
- changed the default timezone
- mapped capabilities folder to container
