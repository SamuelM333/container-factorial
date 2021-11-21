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

	router.GET("/factorial/:n", func(c *gin.Context) {
		n := c.Param("n")
        param, err := strconv.ParseInt(n, 10, 64)
        // Handle non numbers strings and negatives
        if err != nil || param < 0 {
            c.String(http.StatusBadRequest, "Must provide a number greater or equal than 0")
            return
        }

		c.String(http.StatusOK, factorial(param).String())
	})

	router.Run(":8080")
}
