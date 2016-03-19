FROM life360/golang:1.6

ENV GOBIN /opt/bin
ENV GOPATH /opt
ENV SRCPATH github.com/teastburn/rgcmap

RUN go get $SRCPATH
WORKDIR $GOPATH/src/$SRCPATH
CMD go install $SRCPATH && $GOBIN/rgcmap

EXPOSE 8080
