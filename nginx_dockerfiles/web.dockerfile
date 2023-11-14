FROM nginx

RUN apt-get update && apt-get install -y vim 

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf 

COPY nginx/nginx.conf  /etc/nginx/
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]

