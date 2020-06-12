FROM ubuntu

WORKDIR /InfernalChatFiles

RUN apt-get -y update

RUN apt-get -y install apt-utils lsb-release net-tools

COPY . .

ADD build /build
ADD infChat /infChat
ADD nginx-config /nginx-config
ADD www-static /www-static

RUN chmod +x /build/createEnv.sh

WORKDIR /build
ENTRYPOINT ["bash"]

CMD ["createEnv.sh -D"]
