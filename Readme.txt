docker save -o <path for generated tar file> <image name>

docker load -i <path to image tar file>

docker run -ti -d --privileged=true images_docker  "/sbin/init"

docker run -p 90:30 -it --name yys-deployment -v /home/yys/build/docker-build:/home/yys/build/docker-build -d --privileged=true yys:2.2 "/sbin/init"
