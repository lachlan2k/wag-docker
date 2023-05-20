# wag-docker
A Dockerization of https://github.com/NHAS/wag

## Build

```sh
docker-compose build
```

## Run

Note: As Wag manages its own Wireguard network interface, and uses an XDP BPF firewall, it needs a few capabilities.

The capabilities required have been already listed in the docker-compose.yml file. If needed, please update accordingly.
Or if you're encountering issues, `--privileged` should do the trick as it lifts-up all restrictions. Please see docker-compose.yml file.

```sh
mkdir ./cfg && mkdir ./data
docker-compose up -d
```

Additionaly, if you are using Podman with Selinux, you will need to either run the container with `--security-opt label=disable`, or explicitly add a series of Selinux policies to allow the container to set up the XDP BPF.


On first run:
- the example config file will be copied to `cfg`, which can be then configured for your needs.
- please setup .env file with user/password for the webadmin. The user will be automatically added to webadmin.

## Limitations

This repo is unofficial, and not supported by the Wag maintainer.

Notably, running Wag in a container removes the ability to do live upgrades, as of the time of writing.
