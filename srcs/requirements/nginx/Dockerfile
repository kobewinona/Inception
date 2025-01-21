FROM debian:stable-slim

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y nginx
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY conf/mynginx.conf /etc/nginx/conf.d/

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
