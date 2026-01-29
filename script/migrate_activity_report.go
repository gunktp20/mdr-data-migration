package main

import (
	"database/sql"
	"fmt"
	"os"
	"regexp"
	"strings"
	"time"

	_ "github.com/microsoft/go-mssqldb"
)

// Old system structures
type ActivityReport struct {
	ReportID                    int
	DisciplineID                int
	ReportDate                  sql.NullTime
	ReportWON                   sql.NullString
	ReportSubject               string
	ReportDescription           string
	ReportRemark                sql.NullString
	ReportPerformer             sql.NullString
	ActivityTypeID              int
	WorkStatusID                int
	TagID                       sql.NullInt64
	ReportRecordUser            sql.NullString
	ReportUpdatedUser           sql.NullString
	ReportUpdatedTime           sql.NullTime
	ReportRecordTime            sql.NullTime
	AttachedFiles               sql.NullString
	ReportAttach1               sql.NullString
	ReportAttach2               sql.NullString
	SiteID                      sql.NullInt64
	IsDeleted                   sql.NullInt64
	ReportDescriptionWithoutImage sql.NullString
}

type ActivityReportTagData struct {
	ID       int
	TagID    sql.NullInt64
	ReportID sql.NullInt64
}

type TagData struct {
	TagID         int
	TagNo         string
	TagName       string
	LocationID    int
	SiteID        sql.NullInt64
	Status        sql.NullInt64
	ParentID      sql.NullInt64
	Level         sql.NullInt64
	Sort          sql.NullInt64
	SrcTag        sql.NullString
	SyncDate      sql.NullTime
	SrcChangedOn  sql.NullTime
}

type Discipline struct {
	DisciplineID   int
	DisciplineName string
	SiteID         sql.NullInt64
	Status         sql.NullInt64
}

type ActivityType struct {
	ActivityTypeID          int
	ActivityTypeName        string
	ActivityTypeDescription string
	SiteID                  sql.NullInt64
	Status                  sql.NullInt64
}

type WorkStatus struct {
	WorkStatusID   int
	WorkStatusName string
	SiteID         sql.NullInt64
	Status         sql.NullInt64
}

type Location struct {
	LocationID          int
	LocationName        string
	LocationDescription string
	SiteID              sql.NullInt64
	Status              sql.NullInt64
}

type MasterSite struct {
	ID        int
	SiteName  sql.NullString
	SiteAbbr  sql.NullString
}

func main() {
	// Connect to old SQL Server database
	// Database: PTTEPi_MDR_20260114 (old system)
	connString := "server=localhost;port=1433;user id=sa;password=StrongPass!123;database=PTTEPi_MDR_20260114;encrypt=disable"
	
	db, err := sql.Open("sqlserver", connString)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error connecting to database: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	// Test connection
	if err := db.Ping(); err != nil {
		fmt.Fprintf(os.Stderr, "Error pinging database: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("Connected to old database successfully!")

	// Load lookup data
	disciplines, err := loadDisciplines(db)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading disciplines: %v\n", err)
		os.Exit(1)
	}

	activityTypes, err := loadActivityTypes(db)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading activity types: %v\n", err)
		os.Exit(1)
	}

	workStatuses, err := loadWorkStatuses(db)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading work statuses: %v\n", err)
		os.Exit(1)
	}

	tagDataMap, err := loadTagData(db)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading tag data: %v\n", err)
		os.Exit(1)
	}

	locations, err := loadLocations(db)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading locations: %v\n", err)
		os.Exit(1)
	}

	masterSites, err := loadMasterSites(db)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading master sites: %v\n", err)
		os.Exit(1)
	}

	// Load activity reports
	reports, err := loadActivityReports(db)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading activity reports: %v\n", err)
		os.Exit(1)
	}

	// Load activity_report_tagdata relationships
	reportTagMap, err := loadActivityReportTagData(db)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading activity report tag data: %v\n", err)
		os.Exit(1)
	}

	// Generate SQL files - split into files of 5000 records each
	const recordsPerFile = 5000
	reportCount := 0
	fileIndex := 1
	var currentFile *os.File = nil
	recordsInCurrentFile := 0

	// Helper function to create new file
	createNewFile := func() (*os.File, error) {
		outputFile := fmt.Sprintf("migration_output_%03d.sql", fileIndex)
		file, err := os.Create(outputFile)
		if err != nil {
			return nil, err
		}
		file.WriteString("-- Migration SQL generated from old system\n")
		file.WriteString("-- Source Database: PTTEPi_MDR_20260114 (SQL Server)\n")
		file.WriteString("-- Target Database: PostgreSQL (daily_reports, tags, tags_master tables)\n")
		file.WriteString(fmt.Sprintf("-- File: %d of %d (records %d-%d)\n", fileIndex, (len(reports)+recordsPerFile-1)/recordsPerFile, reportCount+1, reportCount+recordsPerFile))
		file.WriteString("-- Generated at: " + time.Now().Format("2006-01-02 15:04:05") + "\n\n")
		file.WriteString("BEGIN;\n\n")
		return file, nil
	}

	// Create first file
	currentFile, err = createNewFile()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating output file: %v\n", err)
		os.Exit(1)
	}

	for _, report := range reports {
		// Skip deleted reports
		if report.IsDeleted.Valid && report.IsDeleted.Int64 == 1 {
			continue
		}

		// Map discipline
		disciplineName := ""
		if d, ok := disciplines[report.DisciplineID]; ok {
			disciplineName = d.DisciplineName
		}

		// Map activity type
		activityTypeName := ""
		if at, ok := activityTypes[report.ActivityTypeID]; ok {
			activityTypeName = at.ActivityTypeName
		}

		// Map work status
		workStatusName := ""
		if ws, ok := workStatuses[report.WorkStatusID]; ok {
			workStatusName = ws.WorkStatusName
		}

		// Prepare values
		workOrderNo := "NULL"
		if report.ReportWON.Valid {
			workOrderNo = escapeSQLString(report.ReportWON.String)
		}

		reportCreated := "NULL"
		if report.ReportDate.Valid {
			reportCreated = fmt.Sprintf("'%s'", report.ReportDate.Time.Format("2006-01-02"))
		}

		activitiesSubject := escapeSQLString(report.ReportSubject)
		// Clean HTML: remove base64 images and clean up HTML tags
		cleanedDescription := removeBase64Images(report.ReportDescription)
		taskDescription := escapeSQLString(cleanedDescription)
		
		taskRemark := "NULL"
		if report.ReportRemark.Valid {
			// Clean task_remark as well
			cleanedRemark := removeBase64Images(report.ReportRemark.String)
			taskRemark = escapeSQLString(cleanedRemark)
		}

		createdDate := "CURRENT_TIMESTAMP"
		if report.ReportRecordTime.Valid {
			createdDate = fmt.Sprintf("'%s'", report.ReportRecordTime.Time.Format("2006-01-02 15:04:05"))
		}

		updatedDate := "CURRENT_TIMESTAMP"
		if report.ReportUpdatedTime.Valid {
			updatedDate = fmt.Sprintf("'%s'", report.ReportUpdatedTime.Time.Format("2006-01-02 15:04:05"))
		}

		createdAt := "NULL"
		if report.ReportRecordUser.Valid {
			createdAt = escapeSQLString(report.ReportRecordUser.String)
		}

		updatedAt := "NULL"
		if report.ReportUpdatedUser.Valid {
			updatedAt = escapeSQLString(report.ReportUpdatedUser.String)
		}

		discipline := escapeSQLString(disciplineName)
		activitiesType := escapeSQLString(activityTypeName)
		workStatus := escapeSQLString(workStatusName)

		// Map siteID to asset (use site_abbr from master_site)
		// Convert ZOC and ZMS to ATL
		asset := "NULL"
		if report.SiteID.Valid {
			if site, ok := masterSites[int(report.SiteID.Int64)]; ok {
				siteAbbr := ""
				if site.SiteAbbr.Valid && site.SiteAbbr.String != "" {
					siteAbbr = site.SiteAbbr.String
				} else if site.SiteName.Valid && site.SiteName.String != "" {
					// Fallback to site_name if site_abbr is not available
					siteAbbr = site.SiteName.String
				}
				
				// Convert ZOC and ZMS to ATL
				if siteAbbr == "ZOC" || siteAbbr == "ZMS" {
					siteAbbr = "ATL"
				}
				
				if siteAbbr != "" {
					asset = escapeSQLString(siteAbbr)
				}
			}
		}

		// Check if we need to create a new file (every 5000 records)
		if recordsInCurrentFile >= recordsPerFile {
			// Close current file
			currentFile.WriteString("\nCOMMIT;\n")
			currentFile.Close()
			fmt.Printf("Created file %d with %d records\n", fileIndex, recordsInCurrentFile)
			
			// Create new file
			fileIndex++
			recordsInCurrentFile = 0
			currentFile, err = createNewFile()
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error creating output file: %v\n", err)
				os.Exit(1)
			}
		}

		// Generate INSERT for daily_reports using DO block to capture the new ID
		currentFile.WriteString(fmt.Sprintf("-- Inserting report ID %d\n", report.ReportID))
		currentFile.WriteString(fmt.Sprintf("DO $$\nDECLARE\n  new_report_id INTEGER;\nBEGIN\n"))
		currentFile.WriteString(fmt.Sprintf("  INSERT INTO daily_reports (work_order_no, activities_subject, discipline, activities_type, work_status, report_created, task_description, task_remark, created_date, updated_date, created_at, updated_at, is_deleted, asset) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, false, %s) RETURNING id INTO new_report_id;\n",
			workOrderNo,
			activitiesSubject,
			discipline,
			activitiesType,
			workStatus,
			reportCreated,
			taskDescription,
			taskRemark,
			createdDate,
			updatedDate,
			createdAt,
			updatedAt,
			asset,
		))

		// Generate INSERT for tags within the DO block
		// Get tags from activity_report_tagdata
		if tagIDs, ok := reportTagMap[report.ReportID]; ok {
			for _, tagID := range tagIDs {
				if tagData, ok := tagDataMap[tagID]; ok {
					// Get location name
					locationName := ""
					if loc, ok := locations[tagData.LocationID]; ok {
						locationName = loc.LocationName
					}

					// Map tagdata to tags table structure
					// TagNo -> equipment_no and technical_id_no
					// TagName -> technical_object_description and text
					// Location -> location
					tagInsertSQL := fmt.Sprintf(
						"  INSERT INTO tags (report_id, equipment_no, technical_id_no, technical_object_description, superior_functional_location, superior_equipment, text, location, children, created_date, updated_date) VALUES (new_report_id, %s, %s, %s, %s, %s, %s, %s, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);\n",
						escapeSQLString(tagData.TagNo),                    // equipment_no
						escapeSQLString(tagData.TagNo),                    // technical_id_no
						escapeSQLString(tagData.TagName),                  // technical_object_description
						"NULL",                                            // superior_functional_location (not available in old system)
						"NULL",                                            // superior_equipment (not available in old system)
						escapeSQLString(tagData.TagName),                  // text
						escapeSQLString(locationName),                     // location
					)
					currentFile.WriteString(tagInsertSQL)
				}
			}
		} else if report.TagID.Valid {
			// Fallback to single tagID from activity_report
			if tagData, ok := tagDataMap[int(report.TagID.Int64)]; ok {
				locationName := ""
				if loc, ok := locations[tagData.LocationID]; ok {
					locationName = loc.LocationName
				}

				// Map tagdata to tags table structure (fallback for single tagID)
				tagInsertSQL := fmt.Sprintf(
					"  INSERT INTO tags (report_id, equipment_no, technical_id_no, technical_object_description, superior_functional_location, superior_equipment, text, location, children, created_date, updated_date) VALUES (new_report_id, %s, %s, %s, %s, %s, %s, %s, false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);\n",
					escapeSQLString(tagData.TagNo),                    // equipment_no
					escapeSQLString(tagData.TagNo),                    // technical_id_no
					escapeSQLString(tagData.TagName),                  // technical_object_description
					"NULL",                                            // superior_functional_location (not available in old system)
					"NULL",                                            // superior_equipment (not available in old system)
					escapeSQLString(tagData.TagName),                  // text
					escapeSQLString(locationName),                     // location
				)
				currentFile.WriteString(tagInsertSQL)
			}
		}

		currentFile.WriteString("END $$;\n\n")

		reportCount++
		recordsInCurrentFile++
	}

	// Close the last file
	if currentFile != nil {
		currentFile.WriteString("\nCOMMIT;\n")
		currentFile.Close()
		fmt.Printf("Created file %d with %d records\n", fileIndex, recordsInCurrentFile)
	}

	// Generate INSERT for tags_master (from tagdata) - create separate file
	tagsMasterFile := "migration_tags_master.sql"
	file, err := os.Create(tagsMasterFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating tags_master file: %v\n", err)
		os.Exit(1)
	}
	defer file.Close()

	file.WriteString("-- Migration SQL for tags_master table\n")
	file.WriteString("-- Source Database: PTTEPi_MDR_20260114 (SQL Server)\n")
	file.WriteString("-- Target Database: PostgreSQL (tags_master table)\n")
	file.WriteString("-- Generated at: " + time.Now().Format("2006-01-02 15:04:05") + "\n\n")
	file.WriteString("BEGIN;\n\n")
	file.WriteString("-- Insert tags_master data\n")

	tagsMasterCount := 0
	for _, tagData := range tagDataMap {
		// Skip if status is not active (assuming 0 or NULL is active)
		if tagData.Status.Valid && tagData.Status.Int64 != 0 {
			continue
		}

		locationName := ""
		if loc, ok := locations[tagData.LocationID]; ok {
			locationName = loc.LocationName
		}

		site := "NULL"
		if tagData.SiteID.Valid {
			site = fmt.Sprintf("'%d'", tagData.SiteID.Int64)
		}

		status := "NULL"
		if tagData.Status.Valid {
			status = fmt.Sprintf("'%d'", tagData.Status.Int64)
		}

		parent := "NULL"
		if tagData.ParentID.Valid {
			parent = fmt.Sprintf("%d", tagData.ParentID.Int64)
		}

		// Note: If tags_master has a unique constraint on tag_no, you can add ON CONFLICT DO NOTHING
		tagMasterSQL := fmt.Sprintf(
			"INSERT INTO tags_master (tag_no, tag_name, location, site, status, parent, created_date, updated_date) VALUES (%s, %s, %s, %s, %s, %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);\n",
			escapeSQLString(tagData.TagNo),
			escapeSQLString(tagData.TagName),
			escapeSQLString(locationName),
			site,
			status,
			parent,
		)
		file.WriteString(tagMasterSQL)
		tagsMasterCount++
	}

	file.WriteString("\nCOMMIT;\n")
	fmt.Printf("\nMigration SQL generated successfully!\n")
	fmt.Printf("Total reports migrated: %d\n", reportCount)
	fmt.Printf("Total files created: %d (migration_output_001.sql to migration_output_%03d.sql)\n", fileIndex, fileIndex)
	fmt.Printf("Tags master file: %s (%d tags)\n", tagsMasterFile, tagsMasterCount)
}

func loadActivityReports(db *sql.DB) ([]ActivityReport, error) {
	query := `
		SELECT 
			reportID, disciplineID, reportDate, reportWON, reportSubject, 
			reportDescription, reportRemark, reportPerformer, activitytypeID, 
			workstatusID, tagID, reportRecordUser, reportUpdatedUser, 
			reportUpdatedTime, reportRecordTime, attached_files, reportAttach1, 
			reportAttach2, siteID, IsDeleted, reportDescriptionWithoutImage
		FROM activity_report
		WHERE IsDeleted IS NULL OR IsDeleted != 1
		ORDER BY reportID
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var reports []ActivityReport
	for rows.Next() {
		var r ActivityReport
		err := rows.Scan(
			&r.ReportID, &r.DisciplineID, &r.ReportDate, &r.ReportWON, &r.ReportSubject,
			&r.ReportDescription, &r.ReportRemark, &r.ReportPerformer, &r.ActivityTypeID,
			&r.WorkStatusID, &r.TagID, &r.ReportRecordUser, &r.ReportUpdatedUser,
			&r.ReportUpdatedTime, &r.ReportRecordTime, &r.AttachedFiles, &r.ReportAttach1,
			&r.ReportAttach2, &r.SiteID, &r.IsDeleted, &r.ReportDescriptionWithoutImage,
		)
		if err != nil {
			return nil, err
		}
		reports = append(reports, r)
	}

	return reports, rows.Err()
}

func loadActivityReportTagData(db *sql.DB) (map[int][]int, error) {
	query := `
		SELECT reportID, tagID 
		FROM activity_report_tagdata
		WHERE reportID IS NOT NULL AND tagID IS NOT NULL
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make(map[int][]int)
	for rows.Next() {
		var reportID, tagID sql.NullInt64
		err := rows.Scan(&reportID, &tagID)
		if err != nil {
			return nil, err
		}
		if reportID.Valid && tagID.Valid {
			result[int(reportID.Int64)] = append(result[int(reportID.Int64)], int(tagID.Int64))
		}
	}

	return result, rows.Err()
}

func loadTagData(db *sql.DB) (map[int]TagData, error) {
	query := `
		SELECT tagID, tagNo, tagName, locationID, siteID, status, parentID, [level], sort, srcTag, syncDate, srcChangedOn
		FROM tagdata
	`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make(map[int]TagData)
	for rows.Next() {
		var t TagData
		err := rows.Scan(
			&t.TagID, &t.TagNo, &t.TagName, &t.LocationID, &t.SiteID, &t.Status,
			&t.ParentID, &t.Level, &t.Sort, &t.SrcTag, &t.SyncDate, &t.SrcChangedOn,
		)
		if err != nil {
			return nil, err
		}
		result[t.TagID] = t
	}

	return result, rows.Err()
}

func loadDisciplines(db *sql.DB) (map[int]Discipline, error) {
	query := `SELECT disciplineID, disciplineName, siteID, status FROM discipline`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make(map[int]Discipline)
	for rows.Next() {
		var d Discipline
		err := rows.Scan(&d.DisciplineID, &d.DisciplineName, &d.SiteID, &d.Status)
		if err != nil {
			return nil, err
		}
		result[d.DisciplineID] = d
	}

	return result, rows.Err()
}

func loadActivityTypes(db *sql.DB) (map[int]ActivityType, error) {
	query := `SELECT activitytypeID, activitytypeName, activitytypeDescription, siteID, status FROM activity_type`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make(map[int]ActivityType)
	for rows.Next() {
		var at ActivityType
		err := rows.Scan(&at.ActivityTypeID, &at.ActivityTypeName, &at.ActivityTypeDescription, &at.SiteID, &at.Status)
		if err != nil {
			return nil, err
		}
		result[at.ActivityTypeID] = at
	}

	return result, rows.Err()
}

func loadWorkStatuses(db *sql.DB) (map[int]WorkStatus, error) {
	query := `SELECT workstatusID, workstatusName, siteID, status FROM workstatus`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make(map[int]WorkStatus)
	for rows.Next() {
		var ws WorkStatus
		err := rows.Scan(&ws.WorkStatusID, &ws.WorkStatusName, &ws.SiteID, &ws.Status)
		if err != nil {
			return nil, err
		}
		result[ws.WorkStatusID] = ws
	}

	return result, rows.Err()
}

func loadLocations(db *sql.DB) (map[int]Location, error) {
	query := `SELECT locationID, locationName, locationDescription, siteID, status FROM location`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make(map[int]Location)
	for rows.Next() {
		var l Location
		err := rows.Scan(&l.LocationID, &l.LocationName, &l.LocationDescription, &l.SiteID, &l.Status)
		if err != nil {
			return nil, err
		}
		result[l.LocationID] = l
	}

	return result, rows.Err()
}

func loadMasterSites(db *sql.DB) (map[int]MasterSite, error) {
	query := `SELECT id, site_name, site_abbr FROM master_site`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	result := make(map[int]MasterSite)
	for rows.Next() {
		var ms MasterSite
		err := rows.Scan(&ms.ID, &ms.SiteName, &ms.SiteAbbr)
		if err != nil {
			return nil, err
		}
		result[ms.ID] = ms
	}

	return result, rows.Err()
}

func removeBase64Images(html string) string {
	if html == "" {
		return ""
	}
	
	// Pattern 1: Remove img tags with base64 images (double quotes)
	re1 := regexp.MustCompile(`<img[^>]*src\s*=\s*"(data:image\/[^;]+;base64[^"]*)"[^>]*>`)
	cleaned := re1.ReplaceAllString(html, "")
	
	// Pattern 2: Remove img tags with base64 images (single quotes)
	re2 := regexp.MustCompile(`<img[^>]*src\s*=\s*'(data:image\/[^;]+;base64[^']*)'[^>]*>`)
	cleaned = re2.ReplaceAllString(cleaned, "")
	
	// Pattern 3: Remove base64 data URLs in CSS style attributes (background-image, etc.)
	// Handles: background-image: url("data:image/svg+xml;base64,...")
	re3 := regexp.MustCompile(`url\(["']?data:image\/[^;]+;base64[^"')]*["']?\)`)
	cleaned = re3.ReplaceAllString(cleaned, "")
	
	// Pattern 4: Remove base64 strings in style attributes (more aggressive)
	// Handles: style="...background-image: var(--url,url("data:image/svg+xml;base64,..."))..."
	re4 := regexp.MustCompile(`background-image[^:]*:[^;]*data:image\/[^;]+;base64[^;)]*[;)]`)
	cleaned = re4.ReplaceAllString(cleaned, "")
	
	// Pattern 5: Remove any remaining base64 data URLs in src attributes
	re5 := regexp.MustCompile(`src\s*=\s*["']data:image\/[^;]+;base64[^"']*["']`)
	cleaned = re5.ReplaceAllString(cleaned, "")
	
	// Pattern 6: Remove base64 strings that might be embedded anywhere
	// This is more aggressive and removes any base64 image data
	re6 := regexp.MustCompile(`data:image\/[^;]+;base64,[A-Za-z0-9+/=\s]+`)
	cleaned = re6.ReplaceAllString(cleaned, "")
	
	// Pattern 7: Remove empty img tags that might be left behind
	re7 := regexp.MustCompile(`<img[^>]*>\s*`)
	cleaned = re7.ReplaceAllString(cleaned, "")
	
	// Pattern 8: Clean up empty style attributes
	re8 := regexp.MustCompile(`style\s*=\s*["'][^"']*["']`)
	cleaned = re8.ReplaceAllStringFunc(cleaned, func(match string) string {
		// Remove style attribute if it's empty or only contains base64 references
		styleContent := match
		if strings.Contains(strings.ToLower(styleContent), "base64") || 
		   strings.TrimSpace(strings.Trim(styleContent, `style="'`)) == "" {
			return ""
		}
		return match
	})
	
	return cleaned
}

func escapeSQLString(s string) string {
	if s == "" {
		return "NULL"
	}
	// Replace single quotes with double single quotes for SQL
	escaped := strings.ReplaceAll(s, "'", "''")
	// Replace backslashes (important for PostgreSQL)
	escaped = strings.ReplaceAll(escaped, "\\", "\\\\")
	// Replace NULL bytes
	escaped = strings.ReplaceAll(escaped, "\x00", "")
	// Escape comment markers that could break SQL (but keep them in the string)
	// We don't remove -- but ensure it's properly quoted
	return fmt.Sprintf("'%s'", escaped)
}
