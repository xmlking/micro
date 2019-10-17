module github.com/xmlking/micro

go 1.13.1

replace (
	k8s.io/api => k8s.io/api v0.0.0-20191003035645-10e821c09743
	k8s.io/apimachinery => k8s.io/apimachinery v0.0.0-20191003115452-c31ffd88d5d2
)

require (
	github.com/micro/go-micro v1.12.0
	github.com/micro/go-plugins v1.3.1-0.20191004210925-4b89c7541d81
	github.com/micro/micro v1.12.0
)
