
all : up

up :  
	@mkdir -p /Users/parissachatagny/data/mariadb
	@mkdir -p /Users/parissachatagny/data/wordpress
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

down :
	@docker-compose -f ./srcs/docker-compose.yml down

stop :
	@docker-compose -f ./srcs/docker-compose.yml stop

start :
	@docker-compose -f ./srcs/docker-compose.yml start 

clean:
	@docker-compose -f ./srcs/docker-compose.yml down -v

fclean: clean
	@docker system prune -af

re: fclean up

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs -f

ps:
	@docker-compose -f ./srcs/docker-compose.yml ps

.PHONY: all up down stop start clean fclean re logs ps

