FROM alpine:3.15

RUN apk add --no-cache nginx openssl

COPY ./conf /etc/nginx

# Generate self-signed SSL certificate for simplicity
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=localhost"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
