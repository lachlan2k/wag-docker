FROM golang:1.19 AS builder

WORKDIR /app
RUN git clone https://github.com/NHAS/wag
WORKDIR /app/wag

RUN apt-get update -y

# see PR #1
RUN ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/asm

# added libbpf-dev, PR #1
RUN apt-get install -y build-essential llvm clang libbpf-dev npm
RUN npm install gulp-cli -g

RUN make

WORKDIR /app
RUN git clone https://github.com/WireGuard/wireguard-tools
WORKDIR /app/wireguard-tools/src
RUN make

FROM redhat/ubi9-minimal:latest
RUN microdnf update -y
RUN microdnf install -y iptables nc

COPY --from=builder /app/wireguard-tools/src/wg /bin

WORKDIR /app/wag

COPY --from=builder /app/wag/wag /usr/bin/wag
COPY --from=builder /app/wag/example_config.json /tmp

COPY docker_entrypoint.sh /
RUN chmod +x /docker_entrypoint.sh

VOLUME /data
VOLUME /cfg

CMD ["/docker_entrypoint.sh"]
