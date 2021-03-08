FROM maven:3-jdk-8 AS builder

RUN apt update && apt install -y python-virtualenv python-pip              \
      && rm -rf /var/lib/apt/lists/*

RUN pip install jstools && ln -s /usr/local/bin/jsbuild /bin/jsbuild

COPY m2-settings.xml /root/.m2/settings.xml
COPY . /src
WORKDIR /src/cadastrapp
RUN mvn clean install

FROM jetty:9-jre8 AS runtime

USER root
RUN mkdir -p /etc/georchestra/mapfishapp/addons
COPY --from=builder /src/cadastrapp/target/cadastrapp-1.10-SNAPSHOT-addon.zip /etc/georchestra/mapfishapp/addons/cadastrapp-addon.zip
COPY --from=builder /src/cadastrapp/target/cadastrapp-1.10-SNAPSHOT.war /var/lib/jetty/webapps/cadastrapp.war

RUN unzip /etc/georchestra/mapfishapp/addons/cadastrapp-addon.zip                                           && \
    unzip -d /var/lib/jetty/webapps/cadastrapp /var/lib/jetty/webapps/cadastrapp.war                        && \
    rm -f /etc/georchestra/mapfishapp/addons/cadastrapp-addon.zip /var/lib/jetty/webapps/cadastrapp.war     && \
    chown -R jetty:jetty /var/lib/jetty/webapps/cadastrapp

COPY --from=builder /src/cadastrapp/src/docker/jetty-env.xml /var/lib/jetty/webapps/cadastrapp/WEB-INF/jetty-env.xml
RUN java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start=jmx,jmx-remote,stats,http-forwarded

VOLUME [ "/tmp", "/run/jetty" ]

CMD ["sh", "-c", "exec java \
-Djava.io.tmpdir=/tmp/jetty \
-Dgeorchestra.datadir=/etc/georchestra \
-Xmx${XMX:-512m} -Xms${XMX:-512m} \
-Duser.language=fr -Duser.country=FR \
-XX:-UsePerfData \
${JAVA_OPTIONS} \
-Djetty.jmxremote.rmiregistryhost=0.0.0.0 \
-Djetty.jmxremote.rmiserverhost=0.0.0.0 \
-jar /usr/local/jetty/start.jar"]
