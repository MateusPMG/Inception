#base image on which the container will run
FROM debian:bullseye

#update and install nginx, openssl and removes cached files from APT reducing image size
RUN apt-get update && apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/nginx

#make html directory
RUN mkdir -p /var/www /etc/nginx/ssl

#generates a self-signed SSL certificate valid for a year with a RSA key with 4096 bits length
RUN openssl req -newkey rsa:4096 -x509 -days 365 -sha256 -nodes \
-keyout /etc/nginx/ssl/mpatrao.key  \
-out /etc/nginx/ssl/mpatrao.crt \
-subj "/C=PT/ST=Lisbon/L=Lisbon/O=42Lisbon/OU=mptrao/CN=mpatrao"

#crt tester
RUN ls -la /etc/nginx >> a 

#copy configuration settings from config file
COPY ./conf/nginx.conf /etc/nginx/conf.d

#Informs developers of the port ibtended to be exposed by the container\
EXPOSE 443



#Start NGINX container and ensures it does not daemonize itself
#thus i force to stay running in the foreground because docker expects containers to.
CMD ["nginx", "-g", "daemon off;"]