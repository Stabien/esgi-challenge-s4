// Package docs Code generated by swaggo/swag. DO NOT EDIT
package docs

import "github.com/swaggo/swag"

const docTemplate = `{
    "schemes": {{ marshal .Schemes }},
    "swagger": "2.0",
    "info": {
        "description": "{{escape .Description}}",
        "title": "{{.Title}}",
        "contact": {},
        "version": "{{.Version}}"
    },
    "host": "{{.Host}}",
    "basePath": "{{.BasePath}}",
    "paths": {
        "/auth": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Auth"
                ],
                "summary": "Authenticate a user",
                "parameters": [
                    {
                        "description": "User credentials",
                        "name": "body",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/controllers.Credentials"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "$ref": "#/definitions/controllers.authSuccessResponse"
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {}
                    },
                    "404": {
                        "description": "Not Found",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal Server Error",
                        "schema": {}
                    }
                }
            }
        },
        "/customers": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Users"
                ],
                "summary": "Register as customer",
                "parameters": [
                    {
                        "description": "Registration payload",
                        "name": "body",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/controllers.RegistrationPayload"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "object"
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {}
                    },
                    "404": {
                        "description": "Not Found",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal Server Error",
                        "schema": {}
                    }
                }
            }
        },
        "/event/{id}": {
            "get": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Event"
                ],
                "summary": "Get an event by ID",
                "parameters": [
                    {
                        "type": "string",
                        "description": "Event ID",
                        "name": "id",
                        "in": "path",
                        "required": true
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Event found",
                        "schema": {
                            "type": "object"
                        }
                    },
                    "400": {
                        "description": "Bad request",
                        "schema": {}
                    },
                    "404": {
                        "description": "Event not found",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal server error",
                        "schema": {}
                    }
                }
            }
        },
        "/events": {
            "get": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Event"
                ],
                "summary": "Get events",
                "parameters": [
                    {
                        "type": "string",
                        "description": "Event name",
                        "name": "name",
                        "in": "query"
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Event found",
                        "schema": {
                            "type": "object"
                        }
                    },
                    "400": {
                        "description": "Bad request",
                        "schema": {}
                    },
                    "404": {
                        "description": "Event not found",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal server error",
                        "schema": {}
                    }
                }
            }
        },
        "/organizers": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Users"
                ],
                "summary": "Register as organizer",
                "parameters": [
                    {
                        "description": "Registration payload",
                        "name": "body",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/controllers.RegistrationPayload"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "OK",
                        "schema": {
                            "type": "object"
                        }
                    },
                    "400": {
                        "description": "Bad Request",
                        "schema": {}
                    },
                    "409": {
                        "description": "Conflict",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal Server Error",
                        "schema": {}
                    }
                }
            }
        },
        "/reservations": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Reservation"
                ],
                "summary": "add reservation",
                "parameters": [
                    {
                        "description": "Reservation object",
                        "name": "body",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/models.Reservation"
                        }
                    }
                ],
                "responses": {
                    "201": {
                        "description": "Successfully created",
                        "schema": {
                            "$ref": "#/definitions/models.Reservation"
                        }
                    },
                    "400": {
                        "description": "Bad request",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal server error",
                        "schema": {}
                    }
                }
            },
            "delete": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Reservation"
                ],
                "summary": "delete reservation",
                "parameters": [
                    {
                        "description": "Reservation request object",
                        "name": "body",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/models.Reservation"
                        }
                    }
                ],
                "responses": {
                    "204": {
                        "description": "Successfully deleted"
                    },
                    "400": {
                        "description": "Bad request",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal server error",
                        "schema": {}
                    }
                }
            }
        },
        "/reservations/isreserv": {
            "get": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Reservation"
                ],
                "summary": "get reservation by user exist",
                "parameters": [
                    {
                        "description": "Reservation object",
                        "name": "body",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/models.Reservation"
                        }
                    }
                ],
                "responses": {
                    "204": {
                        "description": "Successfully get"
                    },
                    "400": {
                        "description": "Bad request",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal server error",
                        "schema": {}
                    }
                }
            }
        },
        "/reservations/{customerId}": {
            "get": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Reservation"
                ],
                "summary": "get reservation by user",
                "parameters": [
                    {
                        "type": "string",
                        "description": "customerId",
                        "name": "customerId",
                        "in": "path",
                        "required": true
                    }
                ],
                "responses": {
                    "204": {
                        "description": "Successfully get"
                    },
                    "400": {
                        "description": "Bad request",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal server error",
                        "schema": {}
                    }
                }
            }
        }
    },
    "definitions": {
        "controllers.Credentials": {
            "type": "object",
            "required": [
                "email"
            ],
            "properties": {
                "email": {
                    "type": "string"
                },
                "password": {
                    "type": "string"
                }
            }
        },
        "controllers.RegistrationPayload": {
            "type": "object",
            "required": [
                "email",
                "firstname",
                "lastname"
            ],
            "properties": {
                "email": {
                    "type": "string"
                },
                "firstname": {
                    "type": "string"
                },
                "lastname": {
                    "type": "string"
                },
                "password": {
                    "type": "string"
                }
            }
        },
        "controllers.authSuccessResponse": {
            "type": "object",
            "properties": {
                "token": {
                    "type": "string"
                }
            }
        },
        "models.Reservation": {
            "type": "object"
        }
    }
}`

// SwaggerInfo holds exported Swagger Info so clients can modify it
var SwaggerInfo = &swag.Spec{
	Version:          "1.0",
	Host:             "localhost:3000",
	BasePath:         "/",
	Schemes:          []string{},
	Title:            "Swagger Example API",
	Description:      "This is a sample server for using Swagger with Echo.",
	InfoInstanceName: "swagger",
	SwaggerTemplate:  docTemplate,
	LeftDelim:        "{{",
	RightDelim:       "}}",
}

func init() {
	swag.Register(SwaggerInfo.InstanceName(), SwaggerInfo)
}
