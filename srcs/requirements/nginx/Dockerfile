FROM alpine:3.20

RUN apk update && apk add --no-cache nginx openssl

COPY conf/nginx.conf /etc/nginx/nginx.conf

#generate the ssl (self signed certificate)
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/cert.key \
    -out /etc/nginx/ssl/cert.crt \
    -subj "/C=CH/ST=Vaud/L=Lausanne/O=42/CN=localhost"

#here we only lsiten to encrypted with TLS we ignore 80 which is not safe
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]