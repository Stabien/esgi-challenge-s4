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
        "/event": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Event"
                ],
                "summary": "Create a new event",
                "parameters": [
                    {
                        "description": "Event input",
                        "name": "event",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/controllers.EventInput"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Event created successfully!",
                        "schema": {
                            "type": "string"
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
            }
        },
        "/event/join/{code}": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Event"
                ],
                "summary": "Join an event using a code",
                "parameters": [
                    {
                        "type": "string",
                        "description": "Invitation code",
                        "name": "code",
                        "in": "path",
                        "required": true
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Successfully joined the event",
                        "schema": {
                            "type": "string"
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
            },
            "delete": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Event"
                ],
                "summary": "Delete an event",
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
                        "description": "Event deleted successfully!",
                        "schema": {
                            "type": "string"
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
            "patch": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Event"
                ],
                "summary": "Update an existing event",
                "parameters": [
                    {
                        "type": "string",
                        "description": "Event ID",
                        "name": "id",
                        "in": "path",
                        "required": true
                    },
                    {
                        "description": "Event input",
                        "name": "event",
                        "in": "body",
                        "required": true,
                        "schema": {
                            "$ref": "#/definitions/controllers.EventInput"
                        }
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Event updated successfully!",
                        "schema": {
                            "type": "string"
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
            }
        },
        "/event/{id}/code": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Event"
                ],
                "summary": "Generate a random code to join an event",
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
                        "description": "Generated code",
                        "schema": {
                            "type": "object",
                            "additionalProperties": {
                                "type": "string"
                            }
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
                    },
                    {
                        "type": "string",
                        "description": "Event tag",
                        "name": "tag",
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
        "/events/organizer/{id}": {
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
                "summary": "Get events by organizer",
                "parameters": [
                    {
                        "type": "string",
                        "description": "Organizer ID",
                        "name": "id",
                        "in": "path",
                        "required": true
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Events found",
                        "schema": {
                            "type": "object"
                        }
                    },
                    "400": {
                        "description": "Bad request",
                        "schema": {}
                    },
                    "404": {
                        "description": "Events not found",
                        "schema": {}
                    },
                    "500": {
                        "description": "Internal server error",
                        "schema": {}
                    }
                }
            }
        },
        "/events/today": {
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
                "summary": "Get events today",
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
        "/reservations/isreserv/{customerId}/{eventId}": {
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
                    },
                    {
                        "type": "string",
                        "description": "eventId",
                        "name": "eventId",
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
        },
        "/send-notification": {
            "post": {
                "consumes": [
                    "application/json"
                ],
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Notification"
                ],
                "summary": "Send a notification using Firebase Cloud Messaging",
                "responses": {
                    "200": {
                        "description": "Notification sent successfully",
                        "schema": {
                            "type": "string"
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
        "controllers.EventInput": {
            "type": "object",
            "properties": {
                "banner": {
                    "type": "string"
                },
                "date": {
                    "type": "string"
                },
                "description": {
                    "type": "string"
                },
                "image": {
                    "type": "string"
                },
                "lat": {
                    "type": "number"
                },
                "lng": {
                    "type": "number"
                },
                "location": {
                    "type": "string"
                },
                "participant_number": {
                    "type": "integer"
                },
                "place": {
                    "type": "string"
                },
                "tag": {
                    "type": "string"
                },
                "title": {
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
