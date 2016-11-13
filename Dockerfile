FROM tomcat:7.0.72-jre7

# Based on mattgruter/artifactory image

MAINTAINER Fernando Torres <nandotorres@gmail.com>

# To update, check https://bintray.com/jfrog/artifactory/artifactory/view
ENV ARTIFACTORY_VERSION 4.14.1
ENV ARTIFACTORY_SHA1 48deba9f045a0b3b796646043c2c01a26a673eb5706b3f9477cfc9292ddfef7e

# Disable Tomcat's manager application.
RUN rm -rf webapps/*

# Redirect URL from / to artifactory/ using UrlRewriteFilter
COPY urlrewrite/WEB-INF/lib/urlrewritefilter.jar /
COPY urlrewrite/WEB-INF/urlrewrite.xml /
RUN \
  mkdir -p webapps/ROOT/WEB-INF/lib && \
  mv /urlrewritefilter.jar webapps/ROOT/WEB-INF/lib && \
  mv /urlrewrite.xml webapps/ROOT/WEB-INF/

# Fetch and install Artifactory OSS war archive.
RUN \
  echo $ARTIFACTORY_SHA1 artifactory.zip > artifactory.zip.sha1 && \
  wget artifactory.zip https://bintray.com/artifact/download/jfrog/artifactory/artifactory-${ARTIFACTORY_VERSION}.zip && \
  sha1sum -c artifactory.zip.sha1 && \
  unzip -j artifactory.zip "artifactory-*/webapps/artifactory.war" -d webapps && \
  rm artifactory.zip

# Expose tomcat runtime options through the RUNTIME_OPTS environment variable.
#   Example to set the JVM's max heap size to 256MB use the flag
#   '-e RUNTIME_OPTS="-Xmx256m"' when starting a container.
RUN echo 'export CATALINA_OPTS="$RUNTIME_OPTS"' > bin/setenv.sh

# Artifactory home
RUN mkdir -p /artifactory
ENV ARTIFACTORY_HOME /artifactory

# Install mysql jdbc driver and configure Artifactory to be backed by MySQL
ADD http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.35/mysql-connector-java-5.1.35.jar /usr/local/tomcat/lib/

ADD http://subversion.jfrog.org/artifactory/public/trunk/distribution/standalone/src/main/install/misc/db/mysql.properties /artifactory/etc/storage.properties

# but change localhost to mysql for mySQL container --link
RUN sed -i s/localhost/mysql/ /artifactory/etc/storage.properties

# Expose Artifactories data, log and backup directory.
VOLUME /artifactory/data
VOLUME /artifactory/logs
VOLUME /artifactory/backup

WORKDIR /artifactory

# Add hook to install custom artifactory.war (i.e. Artifactory Pro) to replace OSS distribution.
ONBUILD COPY artifactory.war $CATALINA_HOME/webapps/artifactory.war