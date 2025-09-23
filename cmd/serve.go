package cmd

import (
	"suitable/cmd/serve"

	"github.com/spf13/cobra"
)

// serveCmd represents the serve command
var serveCmd = &cobra.Command{
	Use:   "serve",
	Short: "Start the server",
	Run:   serve.Main,
}

func init() {
	rootCmd.AddCommand(serveCmd)
}
