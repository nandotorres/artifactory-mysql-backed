FROM docker.bintray.io/jfrog/artifactory-oss

ENV ARTIFACTORY_HOME=/var/opt/jfrog/artifactory

ADD http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.35/mysql-connector-java-5.1.35.jar /opt/jfrog/artifactory/tomcat/lib

ADD http://subversion.jfrog.org/artifactory/public/trunk/distribution/standalone/src/main/install/misc/db/mysql.properties ${ARTIFACTORY_HOME}/etc/storage.properties

RUN sed -i s/localhost/mysql/ ${ARTIFACTORY_HOME}/etc/storage.properties && \
    chmod 766 ${ARTIFACTORY_HOME}/etc/storage.properties && \
<<<<<<< HEAD
    chmod 766 /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-5.1.35.jar && \
    mkdir -p /opt/jfrog/artifactory/tomcat/webapps/ROOT/WEB-INF/lib
=======
    chmod 766 /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-5.1.35.jar
>>>>>>> f030a408f08b3778d8ccdc18959aee40a336f648

VOLUME /opt/jfrog/artifactory/logs
VOLUME /opt/jfrog/artifactory/data
VOLUME /opt/jfrog/artifactory/backup

EXPOSE 8081