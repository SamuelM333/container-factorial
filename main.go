package main

import (
    "fmt"
    "math/big"
)

func factorial(n int64) *big.Int {
    x := new(big.Int)
    x.MulRange(1, n)
    return x
}

func main() {
    var n int64
    n = 10
    fmt.Println(factorial(n))
}
