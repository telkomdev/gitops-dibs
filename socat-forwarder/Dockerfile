FROM alpine:3.19

RUN apk add --no-cache socat bash curl

COPY entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /healthcheck.sh

RUN chmod +x /entrypoint.sh /healthcheck.sh

HEALTHCHECK CMD /healthcheck.sh

ENTRYPOINT ["/entrypoint.sh"]