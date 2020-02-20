FROM ubuntu:18.04

LABEL maintainer="Aziz Faozi <admin@labseni.com>"

RUN apt-get update

ADD . /aishiteru
WORKDIR /aishiteru

