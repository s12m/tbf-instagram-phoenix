init:
	docker-compose run web mix deps.get
	docker-compose run web mix ecto.setup
	docker-compose run web /bin/sh -c "cd assets && npm install"

up:
	docker-compose up web

spec:
	docker-compose run web mix test MIX_ENV=test