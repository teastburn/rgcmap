FROM life360/golang:1.6

ENV GOBIN /usr/local/bin
ENV GOPATH /opt/go
ENV PROJNAME rgcmap
ENV SRCPATH github.com/teastburn/$PROJNAME

RUN go get $SRCPATH
RUN go install $SRCPATH
RUN ls -l $GOBIN

CMD $GOBIN/$PROJNAME

EXPOSE 8080
