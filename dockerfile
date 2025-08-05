# Use lightweight and secure Nginx image
FROM nginx:alpine

# Remove the default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy your website files into the nginx public folder
COPY . /usr/share/nginx/html

FROM tomcat:latest
MAINTAINER Ashok <ashok@oracle.coms>
EXPOSE 8080
COPY target/maven-web-app.war /usr/local/tomcat/webapps/maven-web-app.war
