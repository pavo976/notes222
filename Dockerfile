FROM squidfunk/mkdocs-material:latest AS build

ADD data/docs /docs
ADD data/mkdocs.yml /mkdocs.yml
RUN ls -la /docs/ 
RUN mkdocs build -f "/mkdocs.yml"

FROM nginx:alpine

ADD files/nginx/nginx.conf /etc/nginx/nginx.conf
ADD files/nginx/mkdocs.conf /etc/nginx/conf.d/default.conf
WORKDIR /srv/www/docs/htdocs
COPY --from=build /site /srv/www/docs/htdocs/

# https://github.com/nginxinc/docker-nginx/blob/8921999083def7ba43a06fabd5f80e4406651353/mainline/jessie/Dockerfile#L21-L23
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

