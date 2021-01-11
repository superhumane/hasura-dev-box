# build docker image for Hasura and push to docker hub

image:
	docker pull ubuntu:20.04 && \
	docker build -t superhumane/hasura-dev-box . #--no-cache . && \
	docker push superhumane/hasura-dev-box

stop:
	docker stop hasura

rm:
	docker image rm -f superhumane/hasura-dev-box

bash:
	docker run -it superhumane/hasura-dev-box bash


