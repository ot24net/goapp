package main

import (
	"fmt"
	"os"
	"os/signal"
)

func main() {
	fmt.Println("OK")

	fmt.Println("[ctrl+c to exit]")
	end := make(chan os.Signal, 2)
	signal.Notify(end, os.Interrupt, os.Kill)
	<-end
}
