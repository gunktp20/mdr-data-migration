package main

import (
	"database/sql"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"sort"
	"time"

	_ "github.com/lib/pq"
)

// Database configuration
const (
	DB_HOST     = "34.158.33.23"
	DB_PORT     = "5432"
	DB_USER     = "devuser"
	DB_PASSWORD = "3nL8LvW2Ka3x3wa1X42H8QzQQDfqf4"
	DB_NAME     = "postgres"
)

func main() {
	// Build connection string from config
	connectionString := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME,
	)

	folders := []string{}

	// Get folders from command line args, or use defaults
	if len(os.Args) > 1 {
		folders = os.Args[1:]
	} else {
		folders = []string{"../114_new_script", "../115_new_script"}
	}

	// Connect to PostgreSQL
	fmt.Println("Connecting to PostgreSQL...")
	db, err := sql.Open("postgres", connectionString)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error connecting to database: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	// Test connection
	err = db.Ping()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error pinging database: %v\n", err)
		os.Exit(1)
	}
	fmt.Println("Connected successfully!")
	fmt.Println()

	totalFiles := 0
	successFiles := 0
	failedFiles := 0

	// Process each folder
	for _, folder := range folders {
		fmt.Printf("========================================\n")
		fmt.Printf("Processing folder: %s\n", folder)
		fmt.Printf("========================================\n")

		// Get all .sql files in the folder
		sqlFiles, err := getSQLFiles(folder)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error reading folder %s: %v\n", folder, err)
			continue
		}

		if len(sqlFiles) == 0 {
			fmt.Printf("No SQL files found in %s\n\n", folder)
			continue
		}

		// Sort files by name (timestamp prefix ensures correct order)
		sort.Strings(sqlFiles)

		fmt.Printf("Found %d SQL files\n\n", len(sqlFiles))

		// Execute each SQL file
		for i, sqlFile := range sqlFiles {
			totalFiles++
			fmt.Printf("[%d/%d] Processing: %s\n", i+1, len(sqlFiles), filepath.Base(sqlFile))

			startTime := time.Now()
			err := executeSQLFile(db, sqlFile)
			duration := time.Since(startTime)

			if err != nil {
				fmt.Printf("  ❌ FAILED (%.2fs): %v\n\n", duration.Seconds(), err)
				failedFiles++
			} else {
				fmt.Printf("  ✅ SUCCESS (%.2fs)\n\n", duration.Seconds())
				successFiles++
			}
		}

		fmt.Println()
	}

	// Print summary
	fmt.Printf("========================================\n")
	fmt.Printf("SUMMARY\n")
	fmt.Printf("========================================\n")
	fmt.Printf("Total files:   %d\n", totalFiles)
	fmt.Printf("Success:       %d\n", successFiles)
	fmt.Printf("Failed:        %d\n", failedFiles)
	fmt.Printf("========================================\n")

	if failedFiles > 0 {
		os.Exit(1)
	}
}

// getSQLFiles returns all .sql files in the given folder
func getSQLFiles(folder string) ([]string, error) {
	var sqlFiles []string

	files, err := ioutil.ReadDir(folder)
	if err != nil {
		return nil, err
	}

	for _, file := range files {
		if !file.IsDir() && filepath.Ext(file.Name()) == ".sql" {
			sqlFiles = append(sqlFiles, filepath.Join(folder, file.Name()))
		}
	}

	return sqlFiles, nil
}

// executeSQLFile reads and executes a SQL file
func executeSQLFile(db *sql.DB, filePath string) error {
	// Read file content
	content, err := ioutil.ReadFile(filePath)
	if err != nil {
		return fmt.Errorf("error reading file: %w", err)
	}

	// Execute SQL
	_, err = db.Exec(string(content))
	if err != nil {
		return fmt.Errorf("error executing SQL: %w", err)
	}

	return nil
}
