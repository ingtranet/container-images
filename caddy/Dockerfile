ARG CADDY_VERSION
FROM caddy:$CADDY_VERSION-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-l4/layer4 \
    --with github.com/ueffel/caddy-brotli \
    --with github.com/abiosoft/caddy-exec \
    --with github.com/dulli/caddy-wol

FROM caddy:$CADDY_VERSION

COPY --from=builder /usr/bin/caddy /usr/bin/caddy