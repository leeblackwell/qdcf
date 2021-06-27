FROM ubuntu:focal
MAINTAINER someone@somewhere.com

COPY cf-configure* static/init.sh init-functions.sh /root/

RUN /root/cf-configure.sh

CMD ["/root/init.sh"]


