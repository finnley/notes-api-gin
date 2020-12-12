package setting

import (
	"github.com/go-ini/ini"
	"log"
	"os"
	"strconv"
	"time"
)

var (
	Cfg *ini.File

	RunMode string

	HTTPPort     int
	ReadTimeout  time.Duration
	WriteTimeout time.Duration

	JwtSecret string

	PageSize int
)

func init()  {
	var err error
	Cfg, err = ini.Load("conf/app.ini")
	if err != nil {
		log.Fatalf("Fail to parse 'conf/app.ini': %v", err)
	}

	LoadBase()
	LoadServer()
	LoadApp()
}

func LoadBase()  {
	// 典型读取操作，默认分区可以使用空字符串表示
	RunMode = Cfg.Section("").Key("RUN_MODE").MustString(os.Getenv("RUN_MODE"))
}

func LoadServer()  {
	sec, err := Cfg.GetSection("server")
	if err != nil {
		log.Fatalf("Fail to get section 'server': %v", err)
	}

	port, _ := strconv.Atoi(os.Getenv("HTTP_PORT"))
	HTTPPort = sec.Key("HTTP_PORT").MustInt(port)

	// 自动类型转换
	readTimeout, _ := strconv.Atoi(os.Getenv("READ_TIMEOUT"))
	ReadTimeout = time.Duration(sec.Key("READ_TIMEOUT").MustInt(readTimeout)) * time.Second

	writeTimeout, _ := strconv.Atoi(os.Getenv("WRITE_TIMEOUT"))
	WriteTimeout = time.Duration(sec.Key("WRITE_TIMEOUT").MustInt(writeTimeout)) * time.Second
}

func LoadApp()  {
	sec, err := Cfg.GetSection("app")
	if err != nil {
		log.Fatalf("Fail to get section 'app': %v", err)
	}

	JwtSecret = sec.Key("JWT_SECRET").MustString(os.Getenv("JWT_SECRET"))

	pageSize, _ := strconv.Atoi(os.Getenv("PAGE_SIZE"))
	PageSize = sec.Key("PAGE_SIZE").MustInt(pageSize)
}