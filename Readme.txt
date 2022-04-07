docker save -o <path for generated tar file> <image name>

docker load -i <path to image tar file>

docker run -ti -d --privileged=true images_docker  "/sbin/init"

docker run -p 3000-3016:3000-3016 -p 8081-8088:8081-8088 -p 8090-8099:8090-8099 -p 8101-8150:8101-8150 -p 27020:27017 -it --name yys-deployment -v /home/yys/build/docker-build:/home/yys/build/docker-build -d --privileged=true yys:2.2 "/sbin/init"
