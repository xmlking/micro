package main

import (
	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/server"
	"github.com/micro/micro/cmd"

	cli "github.com/micro/go-micro/client/grpc"
	srv "github.com/micro/go-micro/server/grpc"
)

func main() {
	// setup client/server to use grpc
	client.DefaultClient = cli.NewClient()
	server.DefaultServer = srv.NewServer()

	cmd.Init()

}
