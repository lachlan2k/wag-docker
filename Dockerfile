FROM golang:1.19 AS builder

WORKDIR /app
RUN git clone https://github.com/NHAS/wag
WORKDIR /app/wag

RUN apt-get update -y
RUN apt-get install -y build-essential llvm clang

RUN make

WORKDIR /app
RUN git clone https://github.com/WireGuard/wireguard-tools
WORKDIR /app/wireguard-tools/src
RUN make

FROM ubi9-minimal:latest
RUN microdnf update -y
RUN microdnf install -y iptables

COPY --from=builder /app/wireguard-tools/src/wg /bin

WORKDIR /app/wag

COPY --from=builder /app/wag/wag /usr/bin/wag
COPY --from=builder /app/wag/example_config.json /tmp

COPY docker_entrypoint.sh /
RUN chmod +x /docker_entrypoint.sh

VOLUME /data

CMD ["/docker_entrypoint.sh"]
