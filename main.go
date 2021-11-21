package main

import (
    //"encoding/json"
    //"fmt"
    //"log"
    "strconv"
    "math/big"
    "net/http"

    "github.com/gin-gonic/gin"

)

func factorial(n int64) *big.Int {
    x := new(big.Int)
    x.MulRange(1, n)
    return x
}

func main() {
    router := gin.Default()

	// This handler will match /user/john but will not match /user/ or /user
	router.GET("/factorial/:n", func(c *gin.Context) {
		n := c.Param("n")
        param, err := strconv.ParseInt(n, 10, 64)
        if err != nil {
            panic(err)
            c.String(http.StatusBadRequest, "Must provide a number")
        }

		c.String(http.StatusOK, factorial(param).String())
	})

	router.Run(":8080")
}

//func main() {
    //var n int64
    //n = 10000
    //fmt.Println(factorial(n))
//}
