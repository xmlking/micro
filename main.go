package main

import (
	"crypto/tls"
	"os"

	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/server"

	"github.com/micro/micro/cmd"

	gc "github.com/micro/go-micro/client/grpc"
	gs "github.com/micro/go-micro/server/grpc"
)

func main() {
	// setup client/server to use grpc
	if _, found := os.LookupEnv("INSECURE_SKIP_VERIFY"); found {
		client.DefaultClient = gc.NewClient(
			gc.AuthTLS(&tls.Config{InsecureSkipVerify: true}),
		)
	} else {
		client.DefaultClient = gc.NewClient()
	}

	server.DefaultServer = gs.NewServer()

	cmd.Init(
	// proxy.WithClient(gc.NewClient(
	// 	gc.AuthTLS(&tls.Config{InsecureSkipVerify: true}),
	// )),
	)
}
