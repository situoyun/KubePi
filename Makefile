GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOARCH=$(shell go env GOARCH)
GOOS=$(shell go env GOOS )

BASEPATH := $(shell pwd)
BUILDDIR=$(BASEPATH)/dist/usr/local/bin
KUBEPIDIR=$(BASEPATH)/web/kubepi
DASHBOARDDIR=$(BASEPATH)/web/dashboard
TERMINALDIR=$(BASEPATH)/web/terminal
GOTTYDIR=$(BASEPATH)/thirdparty/gotty
MAIN= $(BASEPATH)/cmd/server/main.go
APP_NAME=kubepi-server

build_web_kubepi:
	cd $(KUBEPIDIR) && npm install && npm run-script build
build_web_dashboard:
	cd $(DASHBOARDDIR) && npm install && npm run-script build
build_web_terminal:
	cd $(TERMINALDIR) && npm install && npm run-script build

build_web: build_web_kubepi build_web_dashboard build_web_terminal

build_bin:
	GOOS=$(GOOS) GOARCH=$(GOARCH)  $(GOBUILD) -trimpath  -ldflags "-s -w"  -o $(BUILDDIR)/$(APP_NAME) $(MAIN)

build_gotty:
	cd $(GOTTYDIR) && make && mkdir -p  ${BUILDDIR} && mv gotty ${BUILDDIR}

build_all: build_web build_gotty build_bin

build_docker: build_web
	docker build -t d.autops.xyz/kubepi-server:master .

build_base:
	docker build -f Dockerfile.base -t d.autops.xyz/kubepi-base:master .
