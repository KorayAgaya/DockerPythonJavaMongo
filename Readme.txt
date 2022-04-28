docker save -o <path for generated tar file> <image name>

docker load -i <path to image tar file>

docker run -ti -d --privileged=true images_docker  "/sbin/init"

docker run -p 90:30 -it --name yys-deployment -v /home/yys/build/docker-build:/home/yys/build/docker-build -d --privileged=true yys:2.2 "/sbin/init"

===============================

sudo docker export red_koray > exampleimage.tar
cat exampleimage.tar | sudo docker import - exampleimagelocal:new

===============================

DOCKER CONTAINER TO A LOCAL NETWORK

Link 1 : https://blog.oddbit.com/post/2014-08-11-four-ways-to-connect-a-docker/

Link 2 : https://3vium.com/blog/how-to-set-up-a-linux-server-with-few-interfaces-in-the-same-ipv4-network-subnet/

Host Machine

Command 1 : docker network create --driver macvlan --subnet 10.X.X.0/24 --gateway 10.X.X.1 -o parent=enp9s0  vmnet

Command 2 : docker networks ls

60d504f378fa   vmnet     macvlan   local

Commands 3 : Insert belleow command into /etc/sysctl.conf last line

net.ipv4.conf.all.arp_ignore = 1

net.ipv4.conf.all.arp_filter = 1

#net.ipv4.ip_forward = 1

#net.ipv4.conf.all.arp_announce = 2

Commands 4 : Insert belleow command into /etc/iproute2/rt_tables last line

200 eno1t
201 enp9s0t
202 macvlan0t

Commnads 5 : Insert belleow command into /etc/rc.local ( Host run commnads starting  )

ip rule add from 10.X.X.73 table eno1t
ip route add 10.X.X.0/24 dev eno1 table eno1t
ip route add default via 10.X.X.1 dev eno1 table eno1t

ip rule add from 10.X.X.74 table enp9s0t
ip route add 10.X.X.0/24 dev enp9s0 table enp9s0t
ip route add default via 10.X.X.1 dev enp9s0 table enp9s0t

ip link add macvlan0 link enp9s0 type macvlan mode bridge
ip addr add 10.X.X.100/24 dev macvlan0
ip l set macvlan0 up

ip rule add from 10.X.X.100 table macvlan0t
ip route add 10.X.X.0/24 dev macvlan0 table macvlan0t
ip route add default via 10.X.X.1 dev macvlan0 table macvlan0t

Command 6 : docker run -it --name xxx-msg --network vmnet --ip=10.X.X.72 -d --privileged=true xxxnet:1.0 "/sbin/init"
