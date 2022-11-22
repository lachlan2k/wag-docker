# wag-docker
A Dockerization of https://github.com/NHAS/wag

## Build

```sh
docker build -t wag-docker .
```

## Run

Note: As Wag manages its own Wireguard network interface, and uses an XDP BPF firewall, it needs a few capabilities.

If you're lazy, `--privileged` should do the trick, however, it is better to explicitly add the relevant container capabilities, as shown with `--cap-add` below:

```sh
mkdir ./wag-config
docker run --name wag -v ./wag-config:/data:z -p53230:53230/udp -p6910:6910/tcp --cap-add=NET_ADMIN,NET_RAW,SYS_ADMIN wag-docker
```

Additionaly, if you are using Podman with Selinux, you will need to either run the container with `--security-opt label=disable`, or explicitly add a series of Selinux policies to allow the container to set up the XDP BPF.


On first run, the example config file will be copied to `wag-config`, which can be then configured for your needs.

Once Wag is running, you can use it's CLI to enroll users, and interact with the control socket like so:

```sh
docker exec wag wag registration -add -username john.doe
```

## Limitations

This repo is unofficial, and not supported by the Wag maintainer.

Notably, running Wag in a container removes the ability to do live upgrades, as of the time of writing.
