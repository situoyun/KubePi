# FROM node:14.18.1 as stage-web-build
# ARG NPM_REGISTRY="https://registry.npmmirror.com"
# ENV NPM_REGISTY=$NPM_REGISTRY

# LABEL stage=stage-web-build
# RUN set -ex \
#     && npm config set registry ${NPM_REGISTRY}

# WORKDIR /build/kubepi/web

# COPY . .

# RUN make build_web

# RUN rm -fr web

FROM golang:1.16 as stage-bin-build

ENV GOPROXY="https://goproxy.cn,direct"

ENV CGO_ENABLED=0

ENV GO111MODULE=on

LABEL stage=stage-bin-build

WORKDIR /build/kubepi/bin

COPY . .

# RUN go mod download

RUN make build_gotty
RUN make build_bin

FROM d.autops.xyz/kubepi-base:master

WORKDIR /

COPY --from=stage-bin-build /build/kubepi/bin/dist/usr /usr

RUN chmod +x /usr/local/bin/gotty 

COPY conf/app.yml /etc/kubepi/app.yml

COPY vimrc.local /etc/vim

EXPOSE 80

USER root

ENTRYPOINT ["tini", "-g", "--"]
CMD ["kubepi-server"]