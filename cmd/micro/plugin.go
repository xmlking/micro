package main

import (
	_ "github.com/micro/go-plugins/registry/kubernetes"
	// static selector offloads load balancing to k8s services
	// enable with MICRO_SELECTOR=static or --selector=static
	// requires user to create k8s services
	_ "github.com/micro/go-plugins/client/selector/static"
)

func init() {
	// set values for registry/selector
	// os.Setenv("MICRO_REGISTRY", "kubernetes")
	// os.Setenv("MICRO_SELECTOR", "static")
}
