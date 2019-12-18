package main

import (
	// Flags usage of k8s plugins `micro --registry=memory --selector=static`
	_ "github.com/micro/go-plugins/client/selector/static"

	// Flags `micro --broker=googlepubsub`
	_ "github.com/micro/go-plugins/broker/googlepubsub"
)

func init() {
	// lets not hard-code kubernetes, so that we can use same `micro` binary with consul
	// set values for registry/selector
	// os.Setenv("MICRO_REGISTRY", "kubernetes")
	// os.Setenv("MICRO_SELECTOR", "static")
}
