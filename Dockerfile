FROM pulumi/pulumi:latest as gcp
RUN pulumi plugin install resource gcp 0.16.2

FROM golang:1.11-stretch as go
ARG PROJECTNAME=github.com/pollosp/pulumi-poc2
WORKDIR /go/src/${PROJECTNAME}
COPY . .
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN dep ensure -v && go build

FROM gcp as pulumiactions
WORKDIR /app/
ARG PROJECTNAME=github.com/pollosp/pulumi-poc2
COPY --from=go /go/src/${PROJECTNAME}/pulumi-poc2 .
COPY Pulumi.* /app/
