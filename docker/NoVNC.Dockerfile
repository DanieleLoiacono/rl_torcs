FROM alpine:3.3

# Setup demo environment variables
ENV HOME=/root \
DEBIAN_FRONTEND=noninteractive \
LANG=en_US.UTF-8 \
LANGUAGE=en_US.UTF-8 \
LC_ALL=C.UTF-8 \
DISPLAY=:0.0 \
DISPLAY_WIDTH=1024 \
DISPLAY_HEIGHT=768

RUN apk --update --upgrade add \
bash \
git \
socat \
supervisor

# Clone noVNC from github
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
&& git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
&& rm -rf /root/noVNC/.git \
&& rm -rf /root/noVNC/utils/websockify/.git \
&& apk del git

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Modify the launch script 'ps -p'
RUN sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh

EXPOSE 8080
EXPOSE 5901

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
