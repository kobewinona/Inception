FROM nginx:latest

# Install gettext package which provides envsubst
RUN apt-get update && apt-get install -y gettext-base

# Copy SSL certificates
COPY ./tools/dklimkin.42.fr.crt /etc/ssl/certs/
COPY ./tools/dklimkin.42.fr.key /etc/ssl/private/

# Copy the HTML files into the correct directory
COPY ./public/html /var/www/html

# Copy and process config file at runtime
COPY ./conf/nginx.config /etc/nginx/conf.d/nginx.config.template

# Document that the container listens on port 443
EXPOSE 443

CMD envsubst '$DOMAIN_NAME' < /etc/nginx/conf.d/nginx.config.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
