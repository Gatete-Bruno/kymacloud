.PHONY: help setup start stop restart logs clean backup scale status

help:
	@echo "KymaCloud WordPress Environment"
	@echo "================================"
	@echo "make setup    - Initial setup (run once)"
	@echo "make start    - Start all services"
	@echo "make stop     - Stop all services"
	@echo "make restart  - Restart all services"
	@echo "make logs     - View logs"
	@echo "make status   - Check service status"
	@echo "make clean    - Remove all containers and volumes"
	@echo "make scale    - Scale WordPress services to 3 replicas each"

setup:
	@bash setup.sh

start:
	docker-compose up -d
	@echo ""
	@echo "Services started. Access:"
	@echo "  Site 1: http://site1.local"
	@echo "  Site 2: http://site2.local"
	@echo "  PHPMyAdmin 1: http://pma1.local"
	@echo "  PHPMyAdmin 2: http://pma2.local"

stop:
	docker-compose down

restart:
	docker-compose restart

logs:
	docker-compose logs -f

status:
	docker-compose ps

clean:
	@echo "WARNING: This will delete all containers and data!"
	@read -p "Are you sure? (yes/no): " confirm && [ "$$confirm" = "yes" ] || exit 1
	docker-compose down -v
	@echo "All containers and volumes removed!"

scale:
	docker-compose up -d --scale wordpress1=3 --scale wordpress2=3
	@echo "WordPress services scaled to 3 replicas each"
