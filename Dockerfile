FROM docker.bintray.io/jfrog/artifactory-oss

ADD http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.35/mysql-connector-java-5.1.35.jar /opt/jfrog/artifactory/tomcat/lib

ADD http://subversion.jfrog.org/artifactory/public/trunk/distribution/standalone/src/main/install/misc/db/mysql.properties /var/opt/jfrog/artifactory/etc/storage.properties

RUN sed -i s/localhost/mysql/ /var/opt/jfrog/artifactory/etc/storage.properties && \
    chmod 766 /var/opt/jfrog/artifactory/etc/storage.properties && \
    chmod 766 /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-5.1.35.jar 
