FROM alpine:3.20

#--no-cache = no cache saved so smaller image
#mariadb is the server and mariadb-client is the tool to interact with the server
RUN apk update && apk add --no-cache mariadb mariadb-client

#initialize database system files
#--user=mysql for safety we create the as user and not root
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh
    
CMD ["sh", "/setup.sh"]