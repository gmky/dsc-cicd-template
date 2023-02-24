#PLACEHOLDER
FROM openjdk:8-jre-alpine

COPY ./tmp/target/*.war /data/app.war

CMD java -Djava.security.egd=file:/dev/./urandom -jar /data/app.war