package middlewares

// func CheckReservationUserId(next echo.HandlerFunc) echo.HandlerFunc {
// 	return func(c echo.Context) error {
// 		token, error := utils.GetTokenFromHeader(c)
// 		customerId := c.Param("customerId")

// 		customer := services.GetCustomerByID(customerId)

// 		if error != nil {
// 			return echo.NewHTTPError(http.StatusUnauthorized)
// 		}

// 		if token["role"] == "admin" {
// 			return next(c)
// 		}

// 		if token["id"] != customer.User.ID {
// 			return echo.NewHTTPError(http.StatusUnauthorized)
// 		}

// 		return next(c)
// 	}
// }
