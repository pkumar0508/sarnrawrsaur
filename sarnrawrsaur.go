package main

import (
	"encoding/base64"
	"github.com/pkumar0508/sarnrawrsaur/message"
	"fmt"
)

func main() {
	encoded := message.SecretMessage
	decoded, err := base64.StdEncoding.DecodeString(encoded)
	if err != nil {
		fmt.Println("decode error:", err)
		return
	}
	fmt.Println(string(decoded))
}
