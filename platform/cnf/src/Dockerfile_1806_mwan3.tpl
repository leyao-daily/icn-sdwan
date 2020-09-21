FROM openwrt-1806-4-base

#EXPOSE 80
ENV http_proxy={docker_proxy}
ENV https_proxy={docker_proxy}
ENV no_proxy=localhost,120.0.0.1,192.168.*

RUN mkdir /var/lock && \
    opkg update && \
    opkg install uhttpd-mod-lua && \
    uci set uhttpd.main.interpreter='.lua=/usr/bin/lua' && \
    uci commit uhttpd && \
    opkg install mwan3 jq bash && \
    opkg install strongswan-default && \
    opkg install luci-app-mwan3; exit 0

COPY system /etc/config/system
COPY ipsec /etc/config/ipsec
COPY ipsec_exec /etc/init.d/ipsec
COPY sdewan.user /etc/sdewan.user
COPY sdewan_svc.info /etc/sdewan_svc.info
COPY default_firewall /etc/config/firewall
COPY rest_v1 /usr/lib/lua/luci/controller/rest_v1

ENV http_proxy=
ENV https_proxy=
ENV no_proxy=

USER root

# using exec format so that /sbin/init is proc 1 (see procd docs)
CMD ["/sbin/init"]
