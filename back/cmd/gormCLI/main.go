package gormcli

import (
	"github.com/spf13/cobra"
)

func init() {
	var rootCmd = &cobra.Command{
		Use:   "gorm-cli",
		Short: "Custom gorm CLI",
	}

	rootCmd.Execute()
}
