 env ?= prod

.PHONY:env
env: ## env展示
	sh scripts/show_env_table.sh

.PHONY:build
build: ## Docker编译
	docker compose -p chsi -f docker-compose.$(env).yml build

.PHONY:build-no-c
build-no-c: ## Docker编译（不使用缓存）
	docker compose -p chsi -f docker-compose.$(env).yml build --no-cache

.PHONY:up
up: ## Docker容器启动
	docker compose -p chsi -f docker-compose.$(env).yml up -d

.PHONY:up-state
up-state: ## Docker容器启动(有状态服务)
	docker compose -p chsi -f docker-compose.state.$(env).yml up -d

.PHONY:down
down: ## Docker容器销毁
	docker compose -p chsi -f docker-compose.$(env).yml down

.PHONY:composer-install
composer-install: ## Composer依赖安装
	docker exec -i php80 sh -c "cd /www/api && composer install --no-dev"

.PHONY:composer-update
composer-update: ## Composer依赖更新
	docker exec -i php80 sh -c "cd /www/api && composer update --no-dev"

.PHONY:clear
clear: ## 后端项目缓存清理
	docker exec -it php80 php /www/server/artisan command:cache_clear

.PHONY:help
.DEFAULT_GOAL:=help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
