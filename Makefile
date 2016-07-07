build:
	docker build -t ruby-test-runner:latest -f Dockerfile .
remove:
	docker rm ruby-test-runner
stop:
	docker stop ruby-test-runner
run:
	  docker run -it -d --name ruby-test-runner ruby-test-runner:latest bash
start:
	docker start ruby-test-runner
rebuild: stop remove build run start
