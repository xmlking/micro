package main

import (
	"github.com/micro/go-micro/broker"
	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/server"
	bkr "github.com/micro/go-plugins/broker/grpc"
	cli "github.com/micro/go-plugins/client/grpc"
	"github.com/micro/go-plugins/micro/cors"
	srv "github.com/micro/go-plugins/server/grpc"
	"github.com/micro/micro/cmd"
	"github.com/micro/micro/plugin"

	// disable namespace by default
	"github.com/micro/micro/api"
)

func main() {
	// disable namespace
	api.Namespace = ""

	// setup broker/client/server
	broker.DefaultBroker = bkr.NewBroker()
	client.DefaultClient = cli.NewClient()
	server.DefaultServer = srv.NewServer()

	// setup cors plugin
	plugin.Register(cors.NewPlugin())

	// init command
	cmd.Init()
}
