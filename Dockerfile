FROM scratch

WORKDIR $GOPATH/src/github.com/finnley/notes-api-gin
COPY . $GOPATH/src/github.com/finnley/notes-api-gin

EXPOSE 8000
CMD ["./notes-api-gin"]