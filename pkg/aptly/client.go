package aptly

import "net/http"

type Client struct {
	c *http.Client
}

type Option func(c *Client)

func NewClient(url string, opts ...Option) *Client {
	
	return &Client{
		c: &http.Client{},
	}
}
