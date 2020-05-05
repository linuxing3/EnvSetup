FROM alpine:3.9
ENV HTTPDIR     /usr/share/nginx/html/
ENV EXECFILE	/usr/sbin/httpv
ENV PASSWD="mm123456"
ENV REMOTE_ADDR="127.0.0.1"
ENV REMOTE_PORT="80"
ENV DOMAIN  youdomain.com
ENV TZ=Asia/Shanghai
ENV KEYPASSWD="mm123456"
ARG version=1.15.1

WORKDIR /root
RUN apk add --no-cache --virtual build-dependencies build-base cmake boost-dev openssl-dev mariadb-connector-c-dev && \
    apk add --no-cache mariadb-dev curl openssl \
            openssh-client \
            coreutils \
            bind-tools \
            socat \
            tzdata \
            tar && \
    apk add --no-cache nginx && \
    wget https://github.com/trojan-gfw/trojan/archive/v${version}.tar.gz && \
    tar zxf v${version}.tar.gz && \
    cd trojan-${version} && \
    cmake . && \
    make && \
    strip -s trojan && \
    mv trojan /usr/local/bin && \
    mkdir -p /root/conf && \
    apk del build-dependencies && \
    apk add --no-cache --virtual .trojan-rundeps libstdc++ boost-system boost-program_options mariadb-connector-c && \
    rm -rf /var/cache/apk /usr/share/man /root/trojan-${version} /root/v${version}.tar.gz
    
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

ADD https://github.com/trojan-gfw/trojan/releases/download/v${version}/trojan-${version}-win.zip ${HTTPDIR}
ADD https://github.com/go2world/ss/releases/download/0.0.4/v2rayN-win-with-trojan-v2.zip ${HTTPDIR}
#ADD https://github.com/TheWanderingCoel/Trojan-Qt5/releases/download/v0.0.3-fix/Trojan-Qt5-Windows.zip ${HTTPDIR}
#ADD win.zip ${HTTPDIR}
#
#ADD https://github.com/trojan-gfw/trojan/releases/download/v${version}/trojan-${version}-macos.zip ${HTTPDIR}
#ADD https://github.com/TheWanderingCoel/Trojan-Qt5/releases/download/v0.0.3-fix/Trojan-Qt5-macOS.dmg ${HTTPDIR}
##ADD macos.zip ${HTTPDIR}
#
#ADD https://github.com/trojan-gfw/igniter/releases/download/v0.1.0-pre-alpha13/app-release.apk ${HTTPDIR}
#ADD https://github.com/PharosVip/Pharos-Android-Test/releases/download/v83/PharosPro83.apk ${HTTPDIR}
##ADD android.apk ${HTTPDIR}
#
#ADD https://github.com/FelisCatus/SwitchyOmega/releases/download/v2.5.20/SwitchyOmega_Chromium.crx ${HTTPDIR}
##ADD SwitchyOmega-Chromium-2.5.15.crx ${HTTPDIR}
##doc
#ADD https://docs.google.com/document/export?format=html&id=1sx2klQHAB1I9ukXxxMKcHC12o1qFq5xelSZQ6uiyxho ${HTTPDIR}
## RUN mv export help.pdf
#
RUN mv ${HTTPDIR}/trojan-${version}-win.zip ${HTTPDIR}/win.zip && \
#    mv ${HTTPDIR}/trojan-${version}-macos.zip ${HTTPDIR}/macos.zip && \
#    mv ${HTTPDIR}/app-release.apk ${HTTPDIR}/android.apk && \
    chmod +644 -R ${HTTPDIR}
    
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

ADD server.json /root/conf/config.json
ADD private.crt /root/conf/private.crt
ADD private.key /root/conf/private.key
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443
ENTRYPOINT ["/entrypoint.sh"]
