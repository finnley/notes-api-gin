package models

import (
	"fmt"
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/finnley/notes-api-gin/pkg/util"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"log"
	"os"
)

var db *gorm.DB

type BaseModel struct {
	Uuid        string           `json:"uuid" gorm:"primary_key" `
	GmtCreate   util.FormatTime  `json:"gmt_create"`
	GmtModified util.FormatTime  `json:"gmt_modified"`
	DeletedAt   *util.FormatTime `json:"deleted_at"`
}

func init() {
	var (
		err                                                                   error
		dbConnection, dbHost, dbPort, dbUserName, dbPassword, dbDatabase, tablePrefix string
	)

	sec, err := setting.Cfg.GetSection("database")
	if err != nil {
		log.Fatal(2, "Fail to get section 'database': %v", err)
	}

	fmt.Printf("username: " + os.Getenv("DB_USERNAME"))
	dbConnection = sec.Key("DB_CONNECTION").String()
	dbUserName = sec.Key("DB_USERNAME").MustString(os.Getenv("DB_USERNAME"))
	dbPassword = sec.Key("DB_PASSWORD").MustString(os.Getenv("DB_PASSWORD"))
	dbHost = sec.Key("DB_HOST").MustString(os.Getenv("DB_HOST"))
	dbPort = sec.Key("DB_PORT").MustString(os.Getenv("DB_PORT"))
	dbDatabase = sec.Key("DB_DATABASE").MustString(os.Getenv("DB_DATABASE"))

	log.Printf(fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8&parseTime=True&loc=Local",
		dbUserName,
		dbPassword,
		dbHost,
		dbPort,
		dbDatabase))
	db, err = gorm.Open(dbConnection, fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8&parseTime=True&loc=Local",
		dbUserName,
		dbPassword,
		dbHost,
		dbPort,
		dbDatabase))

	if err != nil {
		log.Println(err)
	}

	gorm.DefaultTableNameHandler = func(db *gorm.DB, defaultTableName string) string {
		return tablePrefix + defaultTableName
	}

	db.SingularTable(true)
	db.LogMode(true)
	db.DB().SetMaxIdleConns(10)
	db.DB().SetMaxOpenConns(100)
}

func CloseDB() {
	defer db.Close()
}
