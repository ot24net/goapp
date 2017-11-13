package routes

import (
	"github.com/labstack/echo"
	"github.com/ot24net/errors"
	"github.com/ot24net/eweb"
)

// register routes handle
func init() {
	e := eweb.Default()
	e.GET("/login", Login)
}

// Login Handler
func Login(c echo.Context) error {
	return errors.As(c.Render(200, "test/tpl/login", eweb.H{}))
}
