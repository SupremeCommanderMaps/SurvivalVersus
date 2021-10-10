.PHONY: test shell test-loop

test:
	docker-compose run --rm app busted

shell:
	docker-compose run --rm app sh

test-loop:
	docker-compose run --rm app sh -c 'while true; do busted; sleep 1; done'
