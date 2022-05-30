FROM caddy:2.5.1
COPY Caddyfile /etc/caddy/Caddyfile
COPY docs/.retype /usr/share/caddy