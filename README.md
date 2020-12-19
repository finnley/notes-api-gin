# notes-api-gin

# GO 环境搭建

略

# 初始化

t1_gin_init

## 项目搭建

创建一个自己的目录作为项目根目录，比如 `notes-api-gin`

```
➜  ~ cd Code
➜  mkdir notes-api-gin && cd notes-api-gin
➜  ls
➜  go mod init github.com/finnley/notes-api-gin
go: creating new go.mod: module github.com/finnley/notes-api-gin
➜  ls
go.mod
```

* `mkdir xxx && cd xxx`：创建并切换到项目目录里去。
* `go mod init [MODULE_PATH]`：初始化 `Go modules`，它将会生成 `go.mod` 文件，需要注意的是 `MODULE_PATH` 填写的是模块引入路径，可以根据自己的情况修改路径。

在执行了上述步骤后，初始化工作已完成，我们打开 `go.mod` 文件看看，如下:

```
module github.com/finnley/notes-api-gin

go 1.15
```

默认的 `go.mod` 文件里主要是两块内容，一个是当前的模块路径和预期的 Go 语言版本。

## 常用命令

* 用 `go get` 拉取新的依赖
    * 拉取最新的版本(优先择取 tag)：`go get golang.org/x/text@latest`
    * 拉取 `master` 分支的最新 commit：`go get golang.org/x/text@master`
    * 拉取 tag 为 v0.3.2 的 commit：`go get golang.org/x/text@v0.3.2`
    * 拉取 hash 为 342b231 的 commit，最终会被转换为 v0.3.2：`go get golang.org/x/text@342b2e`
    * 用 `go get -u` 更新现有的依赖
    * 用 `go mod download` 下载 `go.mod` 文件中指明的所有依赖
    * 用 `go mod tidy` 整理现有的依赖
    * 用 `go mod graph` 查看现有的依赖结构
    * 用 `go mod init` 生成 `go.mod` 文件 (Go 1.13 中唯一一个可以生成 go.mod 文件的子命令)
* 用 `go mod edit` 编辑 go.mod 文件
* 用 `go mod vendor` 导出现有的所有依赖 (事实上 Go modules 正在淡化 Vendor 的概念)
* 用 `go mod verify` 校验一个模块是否被篡改过

## 安装 Gin

在刚刚创建的 `notes-api-gin` 目录下，在命令行下执行如下命令：

```
✗ go get -u github.com/gin-gonic/gin
go: github.com/gin-gonic/gin upgrade => v1.6.3
go: github.com/modern-go/reflect2 upgrade => v1.0.1
go: github.com/golang/protobuf upgrade => v1.4.3
go: github.com/go-playground/validator/v10 upgrade => v10.4.1
go: github.com/ugorji/go/codec upgrade => v1.2.1
go: gopkg.in/yaml.v2 upgrade => v2.4.0
go: github.com/json-iterator/go upgrade => v1.1.10
go: github.com/modern-go/concurrent upgrade => v0.0.0-20180306012644-bacd9c7ef1dd
go: golang.org/x/sys upgrade => v0.0.0-20201211090839-8ad439b19e0f
go: downloading golang.org/x/sys v0.0.0-20201211090839-8ad439b19e0f
go: google.golang.org/protobuf upgrade => v1.25.0
go: golang.org/x/crypto upgrade => v0.0.0-20201208171446-5f87f3452ae9
go: downloading golang.org/x/crypto v0.0.0-20201208171446-5f87f3452ae9
```

1. go.sum

这时候再检查一下该目录下，会发现多个了个 `go.sum` 文件，如下：

```
cloud.google.com/go v0.26.0/go.mod h1:aQUYkXzVsufM+DwF1aE+0xfcU+56JwCaLick0ClmMTw=
github.com/BurntSushi/toml v0.3.1/go.mod h1:xHWCNGjB5oqiDr8zfno3MHue2Ht5sIBksp03qcyfWMU=
github.com/census-instrumentation/opencensus-proto v0.2.1/go.mod h1:f6KPmirojxKA12rnyqOA5BBL4O983OfeGPqjHWSTneU=
github.com/client9/misspell v0.3.4/go.mod h1:qj6jICC3Q7zFZvVWo7KLAzC3yx5G7kyvSDkc90ppPyw=
github.com/davecgh/go-spew v1.1.0/go.mod h1:J7Y8YcW2NihsgmVo/mv3lAwl/skON4iLHjSsI+c5H38=
...
```

`go.sum` 文件详细罗列了当前项目直接或间接依赖的所有模块版本，并写明了那些模块版本的 SHA-256 哈希值以备 Go 在今后的操作中保证项目所依赖的那些模块版本不会被篡改。

2. go.mod

下载玩依赖包，`go.mod` 文件也会有所改变，内容如下：

```
module github.com/finnley/notes-api-gin

go 1.15

require (
	github.com/gin-gonic/gin v1.6.3 // indirect
	github.com/go-playground/validator/v10 v10.4.1 // indirect
	github.com/golang/protobuf v1.4.3 // indirect
	github.com/json-iterator/go v1.1.10 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.1 // indirect
	github.com/ugorji/go v1.2.1 // indirect
	golang.org/x/crypto v0.0.0-20201208171446-5f87f3452ae9 // indirect
	golang.org/x/sys v0.0.0-20201211090839-8ad439b19e0f // indirect
	google.golang.org/protobuf v1.25.0 // indirect
	gopkg.in/yaml.v2 v2.4.0 // indirect
)
```

确确实实发生了改变，那多出来的东西又是什么呢，`go.mod` 文件又保存了什么信息呢，实际上 `go.mod` 文件是启用了 `Go modules` 的项目所必须的最重要的文件，因为它描述了当前项目（也就是当前模块）的元信息，每一行都以一个动词开头，目前有以下 5 个动词:

* module：用于定义当前项目的模块路径。
* go：用于设置预期的 Go 版本。
* require：用于设置一个特定的模块版本。
* exclude：用于从使用中排除一个特定的模块版本。
* replace：用于将一个模块版本替换为另外一个模块版本。

会看到好多依赖后面都带上 `indirect`，它又是什么东西呢？ `indirect` 的意思是传递依赖，也就是非直接依赖。

## 测试

assume the following codes in `example.go` file

```
package main

import "github.com/gin-gonic/gin"

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
```

执行 `example.go`

```
✗ go run example.go 
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
- using env:   export GIN_MODE=release
- using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /ping                     --> main.main.func1 (3 handlers)
[GIN-debug] Environment variable PORT is undefined. Using port :8080 by default
[GIN-debug] Listening and serving HTTP on :8080
```

访问 `$HOST:8080/ping`，若返回 `{"message":"pong"}` 则正确

```
✗ curl 127.0.0.1:8080/ping
{"message":"pong"}
```

至此，我们的环境安装和初步运行都基本完成了。

## 扩展

在执行了命令 `go get -u github.com/gin-gonic/gin` 后，查看 `go.mod` 文件，如下：

```
...
require (
	github.com/gin-gonic/gin v1.6.3 // indirect
	github.com/go-playground/validator/v10 v10.4.1 // indirect
	...
)
```

会发现 `go.mod` 里的 `github.com/gin-gonic/gin` 是 `indirect` 模式，这显然不对，因为我们的应用程序已经实际的编写了 `gin server` 代码了，我就想把它调对，怎么办呢，在应用根目录下执行如下命令：

```
go mod tidy
```

该命令主要的作用是整理现有的依赖，非常的常用，执行后 `go.mod` 文件内容为：

```
...
require (
	github.com/gin-gonic/gin v1.6.3
	github.com/go-playground/validator/v10 v10.4.1 // indirect
	github.com/golang/protobuf v1.4.3 // indirect
    ...
)
```

可以看到 `github.com/gin-gonic/gin` 已经变成了直接依赖，调整完毕。

# 基础框架搭建

t2_project_init

## 目标

* 编写一个简单的 API 错误码包。
* 完成一个 Demo 示例。
* 讲解 Demo 所涉及的知识点。

## 引入

基本每个项目都有自己的一套框架，如果没有框架，可能会出现下面的一些问题：

* 将所有的程序的文本配置写在代码中；
* API的错误码硬编码在程序中；
* DB句柄谁去 OPEN,没有统一管理；
* 获取分页等公共参数，每个模块写一套相同的逻辑；
...

显然在较正规的项目中，这些问题的答案都是不允许的，为了解决这些问题，挑选一款读写配置文件的库，目前比较火的有 [viper](https://github.com/spf13/viper)

## 初始化项目目录

现在已经初始化了一个 `notes-api-gin` 项目，接下来需要继续新增如下目录结构：

```
notes-api-gin
├── conf
├── middleware
├── models
├── pkg
├── routers
└── runtime
```

* conf：用于存储配置文件
* middleware：应用中间件
* models：应用数据库模型
* pkg：第三方包
* routers 路由逻辑处理 (类似controller的作用)
* runtime：应用运行时数据

## 编写配置包

在 `notes-api-gin` 应用目录下，拉取 `joho/godotenv` 的依赖包，如下：

[joho/godotenv](https://github.com/joho/godotenv)

```
go get github.com/joho/godotenv
```

接下来编写基础的应用配置文件，在 `notes-api-gin` 的根目录下新建 `.env` 文件，写入内容：

```
# debug or release
RUN_MODE=debug

JWT_SECRET=!@)*#)!@U#@*!@!)

HTTP_PORT=8000
READ_TIMEOUT=60
WRITE_TIMEOUT=60

DB_CONNECTION=mysql
# 127.0.0.1:3306
DB_HOST=127.0.0.1
DB_USERNAME=root
DB_PASSWORD=123
DB_PORT=3306
DB_DATABASE=notes
# DB_TABLE_PREFIX=notes_

PAGE_SIZE=10
```

接着在 `notes-api-gin` 应用目录下，拉取 `go-ini/ini` 的依赖包，如下：

```
✗ go get -u github.com/go-ini/ini
go: github.com/go-ini/ini upgrade => v1.62.0
```

接下来编写基础的应用配置文件，在 `notes-api-gin` 的 `conf` 目录下新建 `app.ini` 文件，写入内容：

```
#debug or release
RUN_MODE = debug

[app]
JWT_SECRET = 23347$040412
PAGE_SIZE =

[server]
HTTP_PORT = 8000
READ_TIMEOUT = 60
WRITE_TIMEOUT = 60

[database]
DB_CONNECTION = mysql
DB_HOST =
DB_USERNAME =
DB_PASSWORD =
DB_PORT =
DB_DATABASE =
DB_TABLE_PREFIX = 
```

建立调用配置的 `setting` 模块，在 `notes-api-gin` 的 `pkg` 目录下新建 `setting` 目录，新建 `setting.go` 文件，写入内容：

```
package setting

import (
	"github.com/go-ini/ini"
	"github.com/joho/godotenv"
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
	
	err = godotenv.Load()
	if err != nil {
		log.Fatalf("Fail to parse 'env': %v", err)
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
```

当前目录结构：

```
.
├── README.md
├── conf
│   └── app.ini
├── example.go
├── go.mod
├── go.sum
├── middleware
├── models
├── pkg
│   └── setting
│       └── setting.go
├── routers
└── runtime
```

## 编写 API 错误码包

建立错误码的 `e` 模块，在 `notes-api-gin` 的 `pkg` 目录下新建 `e` 目录，新建 `code.go` 和 `msg.go` 文件，写入内容：

1、code.go

```
package e

const (
	SUCCESS = 200
	ERROR = 500
	INVALID_PARAMS = 400

	ERROR_EXIST_TAG = 10001
	ERROR_NOT_EXIST_TAG = 10002
	ERROR_NOT_EXIST_ARTICLE = 10003

	ERROR_AUTH_CHECK_TOKEN_FAIL = 20001
	ERROR_AUTH_CHECK_TOKEN_TIMEOUT = 20002
	ERROR_AUTH_TOKEN = 20003
	ERROR_AUTH = 20004
)
```

2、 msg.go

```
package e

var MsgFlags = map[int]string {
	SUCCESS : "ok",
	ERROR : "fail",
	INVALID_PARAMS : "请求参数错误",
	ERROR_EXIST_TAG : "已存在该标签名称",
	ERROR_NOT_EXIST_TAG : "该标签不存在",
	ERROR_NOT_EXIST_ARTICLE : "该文章不存在",
	ERROR_AUTH_CHECK_TOKEN_FAIL : "Token鉴权失败",
	ERROR_AUTH_CHECK_TOKEN_TIMEOUT : "Token已超时",
	ERROR_AUTH_TOKEN : "Token生成失败",
	ERROR_AUTH : "Token错误",
}

func GetMsg(code int) string {
	msg, ok := MsgFlags[code]
	if ok {
		return msg
	}

	return MsgFlags[ERROR]
}
```

## 编写工具包

在 `notes-api-gin` 的 `pkg` 目录下新建 `util` 目录，并拉取 `com` 的依赖包，如下：

[unknwon/com](https://github.com/unknwon/com)

```
go get -u github.com/unknwon/com
```

#### 分页页码获取

在 `util` 目录下新建 `pagination.go`，写入内容：

```
package util

import (
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/gin-gonic/gin"
	"github.com/unknwon/com"
)

func GetPage(c *gin.Context) int {
	result := 0
	page, _ := com.StrTo(c.Query("page")).Int()
	if page > 0 {
		result = (page - 1) * setting.PageSize
	}

	return result
}
```

#### 自定义时间格式

`Gorm` 中 `time.Time` 类型的字段在 `JSON` 序列化后呈现的格式为 `2020-03-11T18:26:13+08:00`，在 [Go 标准库文档 - time 的 MarshaJSON 方法](https://studygolang.com/static/pkgdoc/pkg/time.htm#Time.MarshalJSON) 下面有这样一段描述：

    MarshalJSON 实现了json.Marshaler 接口。返回值是用双引号括起来的采用 RFC 3339 格式进行格式化的时间表示，如果需要会提供小于秒的精度。
    
这个 RFC 3339 格式并不符合日常使用习惯，下面介绍如何将其转换成常用的 "yyyy-MM-dd HH:mm:ss" 格式。

###### 思路

1. 创建 `time.Time` 类型的副本 FormatTime；
2. 为 `FormatTime` 重写 `MarshaJSON` 方法，在此方法中实现自定义格式的转换；
3. 为 `FormatTime` 实现 `Value` 方法，写入数据库时会调用该方法将自定义时间类型转换并写入数据库；
4. 为 `FormatTime` 实现 `Scan` 方法，读取数据库时会调用该方法将时间数据转换成自定义时间类型；
5. 自定义 `BaseModel`，结构和 `gorm.Model` 一致，将 `time.Time` 替换为 `FormatTime`；
6. 模型定义中使用 `BaseModel` 替代 `gorm.Model`；
7. 模型定义中其他的 `time.Time` 类型字段也都使用 `FormatTime` 替代。

###### 实现

在 `pkg` 目录下的 `util` 目录中创建 `time.go` 文件，内容如下：

```
package util

import (
	"database/sql/driver"
	"fmt"
	"time"
)

// 1. 创建 time.Time 类型的副本 XTime
type FormatTime struct {
	time.Time
}

// 2. 为 FormatTime 重写 MarshaJSON 方法，在此方法中实现自定义格式的转换
func (t FormatTime) MarshalJSON() ([]byte, error) {
	output := fmt.Sprintf("\"%s\"", t.Format("2006-01-02 15:04:05"))
	return []byte(output), nil
}

// 3. 为 FormatTime 实现 Value 方法，写入数据库时会调用该方法将自定义时间类型转换并写入数据库；
func (t FormatTime) Value() (driver.Value, error) {
	var zeroTime time.Time
	if t.Time.UnixNano() == zeroTime.UnixNano() {
		return nil, nil
	}
	return t.Time, nil
}

// 4. 为 FormatTime 实现 Scan 方法，读取数据库时会调用该方法将时间数据转换成自定义时间类型；
func (t *FormatTime) Scan(v interface{}) error {
	value, ok := v.(time.Time)
	if ok {
		*t = FormatTime{Time: value}
		return nil
	}
	return fmt.Errorf("can not convert %v to timestamp", v)
}
```

#### 编写 models init

拉取 `gorm` 的依赖包，如下：

```
go get -u github.com/jinzhu/gorm
```

拉取 `MySQL` 驱动的依赖包，如下：

```
go get -u github.com/go-sql-driver/mysql
```

完成后，在 `notes-api-gin` 的 `models` 目录下新建 `models.go`，用于 `models` 的初始化使用

```
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

	dbConnection = sec.Key("DB_CONNECTION").String()
	dbUserName = sec.Key("DB_USERNAME").MustString(os.Getenv("DB_USERNAME"))
	dbPassword = sec.Key("DB_PASSWORD").MustString(os.Getenv("DB_PASSWORD"))
	dbHost = sec.Key("DB_HOST").MustString(os.Getenv("DB_HOST"))
	dbPort = sec.Key("DB_PORT").MustString(os.Getenv("DB_PORT"))
	dbDatabase = sec.Key("DB_DATABASE").MustString(os.Getenv("DB_DATABASE"))

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
```

## 编写项目启动、路由文件

在 `notes-api-gin` 下建立 `main.go`作为启动文件（也就是 `main` 包），写入文件内容：

```
package main

import (
	"fmt"
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/gin-gonic/gin"
	"net/http"
)

func main() {
	router := gin.Default()
	router.GET("/test", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "test",
		})
	})

	s := &http.Server{
		Addr:           fmt.Sprintf(":%d", setting.HTTPPort),
		Handler:        router,
		ReadTimeout:    setting.ReadTimeout,
		WriteTimeout:   setting.WriteTimeout,
		MaxHeaderBytes: 1 << 20,
	}

	s.ListenAndServe()
}
```

执行 `go run main.go`，查看命令行是否显示

```
✗ go run main.go 
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /test                     --> main.main.func1 (3 handlers)

```

在本机执行 `curl 127.0.0.1:8000/test`，检查是否返回 `{"message":"test"}`。

#### 标准库

* fmt：实现了类似 C 语言 printf 和 scanf 的格式化 I/O。格式化动作（‘verb’）源自 C 语言但更简单
* net/http：提供了 HTTP 客户端和服务端的实现

#### Gin

* gin.Default()：返回 Gin 的 `type Engine struct{...}`，里面包含 `RouterGroup`，相当于创建一个路由 `Handlers`，可以后期绑定各类的路由规则和函数、中间件等
* router.GET(…){…}：创建不同的 HTTP 方法绑定到 `Handlers` 中，也支持 `POST`、`PUT`、`DELETE`、`PATCH`、`OPTIONS`、`HEAD` 等常用的 `Restful` 方法
* gin.H{…}：就是一个 `map[string]interface{}`
* gin.Context：`Context` 是 `gin` 中的上下文，它允许我们在中间件之间传递变量、管理流、验证 JSON 请求、响应 JSON 请求等，在gin中包含大量 `Context` 的方法，例如我们常用的 `DefaultQuery`、`Query`、`DefaultPostForm`、`PostForm` 等等

#### &http.Server 和 ListenAndServe ？

1、http.Server

```
type Server struct {
	Addr string
	Handler Handler // handler to invoke, http.DefaultServeMux if nil
	TLSConfig *tls.Config
	ReadTimeout time.Duration
	ReadHeaderTimeout time.Duration
	WriteTimeout time.Duration
	IdleTimeout time.Duration
	MaxHeaderBytes int
	TLSNextProto map[string]func(*Server, *tls.Conn, Handler)
	ConnState func(net.Conn, ConnState)
	ErrorLog *log.Logger
	BaseContext func(net.Listener) context.Context
	ConnContext func(ctx context.Context, c net.Conn) context.Context
	inShutdown atomicBool // true when when server is in shutdown
	disableKeepAlives int32     // accessed atomically.
	nextProtoOnce     sync.Once // guards setupHTTP2_* init
	nextProtoErr      error     // result of http2.ConfigureServer if used
	mu         sync.Mutex
	listeners  map[*net.Listener]struct{}
	activeConn map[*conn]struct{}
	doneChan   chan struct{}
	onShutdown []func()
}
```

* Addr：监听的 TCP 地址，格式为:8000
* Handler：http 句柄，实质为ServeHTTP，用于处理程序响应 HTTP 请求
* TLSConfig：安全传输层协议（TLS）的配置
* ReadTimeout：允许读取的最大时间
* ReadHeaderTimeout：允许读取请求头的最大时间
* WriteTimeout：允许写入的最大时间
* IdleTimeout：等待的最大时间
* MaxHeaderBytes：请求头的最大字节数
* ConnState：指定一个可选的回调函数，当客户端连接发生变化时调用
* ErrorLog：指定一个可选的日志记录器，用于接收程序的意外行为和底层系统错误；如果未设置或为nil则默认以日志包的标准日志记录器完成（也就是在控制台输出）

2、ListenAndServe

```
func (srv *Server) ListenAndServe() error {
	if srv.shuttingDown() {
		return ErrServerClosed
	}
	addr := srv.Addr
	if addr == "" {
		addr = ":http"
	}
	ln, err := net.Listen("tcp", addr)
	if err != nil {
		return err
	}
	return srv.Serve(ln)
}
```

开始监听服务，监听 `TCP` 网络地址，`Addr` 和调用应用程序处理连接上的请求。

我们在源码中看到 `Addr` 是调用我们在 `&http.Server` 中设置的参数，因此我们在设置时要用&，我们要改变参数的值，因为我们 `ListenAndServe` 和其他一些方法需要用到 `&http.Server` 中的参数，他们是相互影响的。

3、http.ListenAndServe和 连载一 的 `r.Run()` 区别

`r.Run` 的实现:

```
func (engine *Engine) Run(addr ...string) (err error) {
	defer func() { debugPrintError(err) }()

	address := resolveAddress(addr)
	debugPrint("Listening and serving HTTP on %s\n", address)
	err = http.ListenAndServe(address, engine)
	return
}
```

通过分析源码，发现本质上没有区别，同时也得知启动 `gin` 时的监听 `debug` 信息在这里输出。

4、Demo 里会有 `WARNING`

看下 `Default()` 的实现

```
// Default returns an Engine instance with the Logger and Recovery middleware already attached.
func Default() *Engine {
	debugPrintWARNINGDefault()
	engine := New()
	engine.Use(Logger(), Recovery())
	return engine
}
```

可以看到默认情况下，已经附加了日志、恢复中间件的引擎实例。并且在开头调用了 `debugPrintWARNINGDefault()`，而它的实现就是输出该行日志

```
func debugPrintWARNINGDefault() {
	if v, e := getMinVer(runtime.Version()); e == nil && v <= ginSupportMinGoVer {
		debugPrint(`[WARNING] Now Gin requires Go 1.11 or later and Go 1.12 will be required soon.

`)
	}
	debugPrint(`[WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

`)
}
```

而另外一个 `Running in "debug" mode. Switch to "release" mode in production.`，是运行模式原因，并不难理解，已在配置文件的管控下 :-)，运维人员随时就可以修改它的配置。

5、Demo 的 `router.GET` 等路由规则可以不写在main包中吗？

发现 `router.GET` 等路由规则，在 Demo 中被编写在了 `main` 包中，感觉很奇怪，可以去抽离这部分逻辑！

在 `notes-api-gin` 下 `routers` 目录新建 `router.go` 文件，写入内容：

```
package routers

import (
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/gin-gonic/gin"
)

func InitRouter() *gin.Engine {
	r := gin.New()

	r.Use(gin.Logger())

	r.Use(gin.Recovery())

	gin.SetMode(setting.RunMode)

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	return r
}
```

修改main.go的文件内容：

```
package main

import (
	"fmt"
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/finnley/notes-api-gin/routers"
	"net/http"
)

func main() {
	//router := gin.Default()
	//router.GET("/test", func(c *gin.Context) {
	//	c.JSON(http.StatusOK, gin.H{
	//		"message": "test",
	//	})
	//})
	router := routers.InitRouter()

	s := &http.Server{
		Addr:           fmt.Sprintf(":%d", setting.HTTPPort),
		Handler:        router,
		ReadTimeout:    setting.ReadTimeout,
		WriteTimeout:   setting.WriteTimeout,
		MaxHeaderBytes: 1 << 20,
	}

	s.ListenAndServe()
}
```

当前目录结构：

```
.
├── README.md
├── conf
│   └── app.ini
├── example.go
├── go.mod
├── go.sum
├── main.go
├── middleware
├── models
│   └── models.go
├── pkg
│   ├── e
│   │   ├── code.go
│   │   └── msg.go
│   ├── setting
│   │   └── setting.go
│   └── util
│       ├── pagination.go
│       └── time.go
├── routers
│   └── router.go
└── runtime
```

重启服务，执行 `curl 127.0.0.1:8000/ping` 查看是否正确返回。

```
curl 127.0.0.1:8000/ping
{"message":"pong"}
```

# Module

t3_modules

## 接口定义

* 获取模块列表：GET("/modules”)
* 新建模块：POST("/modules”)
* 更新指定模块：PUT("/modules/:id”)
* 删除指定模块：DELETE("/modules/:id”)

## 初始项目数据库

新建 `notes` 数据库，编码为 `utf8_general_ci`，在 `notes` 数据库下，新建 `module` 表

```
DROP TABLE IF EXISTS `module`;
CREATE TABLE `module` (
  `uuid` char(36) NOT NULL COMMENT '主键ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `english_name` varchar(255) NOT NULL DEFAULT '' COMMENT '英文名称',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '介绍',
  `english_description` varchar(255) NOT NULL DEFAULT '' COMMENT '英文介绍',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT 'image path,icon',
  `cover` varchar(255) NOT NULL DEFAULT '' COMMENT '封面',
  `new_feature_deadline` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新模块截止日期',
  `landing_page_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转页面 url',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '状态，0-关闭 1-启用',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`uuid`),
  KEY `idx_deleted_at` (`deleted_at`),
  KEY `idx_name` (`name`),
  KEY `idx_status` (`status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模块';
```

## 编写空壳路由

开始编写路由文件逻辑，在 `routers` 下新建 `api` 目录，因为当前是第一个 `API` 大版本，因此在 `api` 下新建 `v1` 目录，再新建 `module.go` 文件，写入内容：

```
package v1

import "github.com/gin-gonic/gin"

//新增模块
func AddModule(c *gin.Context)  {

}

//修改模块
func EditModule(c *gin.Context)  {

}

//删除模块
func DeleteModule(c *gin.Context)  {

}

//获取多个模块列表
func GetModules(c *gin.Context)  {

}
```

## 注册路由

打开 `routers` 下的 `router.go` 文件，修改文件内容为：

```
package routers

import (
	"github.com/finnley/notes-api-gin/pkg/setting"
	v1 "github.com/finnley/notes-api-gin/routers/api/v1"
	"github.com/gin-gonic/gin"
)

func InitRouter() *gin.Engine {
	r := gin.New()

	r.Use(gin.Logger())

	r.Use(gin.Recovery())

	gin.SetMode(setting.RunMode)

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	apiv1 := r.Group("/api/v1")
	{
		//新增模块
		apiv1.POST("/modules", v1.AddModule)
		//修改模块
		apiv1.PUT("/modules/:id", v1.EditModule)
		//删除模块
		apiv1.DELETE("/modules/:id", v1.DeleteModule)
		//获取多个模块列表
		apiv1.GET("/modules", v1.GetModules)
	}

	return r
}
```

当前目录结构：

```
.
├── README.md
├── conf
│   └── app.ini
├── example.go
├── go.mod
├── go.sum
├── main.go
├── middleware
├── models
│   └── models.go
├── pkg
│   ├── e
│   │   ├── code.go
│   │   └── msg.go
│   ├── setting
│   │   └── setting.go
│   └── util
│       ├── pagination.go
│       └── time.go
├── routers
│   ├── api
│   │   └── v1
│   │       └── module.go
│   └── router.go
└── runtime
```

## 检验路由是否注册成功

执行 `go run main.go`，检查路由规则是否注册成功。

```
✗ go run main.go
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /ping                     --> github.com/finnley/notes-api-gin/routers.InitRouter.func1 (3 handlers)
[GIN-debug] GET    /api/v1/modules           --> github.com/finnley/notes-api-gin/routers/api/v1.GetModules (3 handlers)
[GIN-debug] POST   /api/v1/modules           --> github.com/finnley/notes-api-gin/routers/api/v1.AddModule (3 handlers)
[GIN-debug] PUT    /api/v1/modules/:id       --> github.com/finnley/notes-api-gin/routers/api/v1.EditModule (3 handlers)
[GIN-debug] DELETE /api/v1/modules/:id       --> github.com/finnley/notes-api-gin/routers/api/v1.DeleteModule (3 handlers)

```

## 下载依赖包

拉取 `validation` 的依赖包，在后面的接口里会使用到表单验证

```
go get -u github.com/astaxie/beego/validation
```

## 功能实现

提前添加需要使用的硬编码和提示消息

1、 code.go

修改 `code.go` 文件

```
package e

const (
	SUCCESS = 200
	ERROR = 500
	INVALID_PARAMS = 400

	ERROR_EXIST_MODULE = 10001
	ERROR_NOT_EXIST_MODULE = 10002
	ERROR_NOT_EXIST_ARTICLE = 10003

	ERROR_AUTH_CHECK_TOKEN_FAIL = 20001
	ERROR_AUTH_CHECK_TOKEN_TIMEOUT = 20002
	ERROR_AUTH_TOKEN = 20003
	ERROR_AUTH = 20004
)
```

2、msg.go

修改 `msg.go` 文件

```
package e

var MsgFlags = map[int]string {
	SUCCESS : "ok",
	ERROR : "fail",
	INVALID_PARAMS : "请求参数错误",
	ERROR_EXIST_MODULE: "已存在该模块",
	ERROR_NOT_EXIST_MODULE: "该模块不存在",
	ERROR_NOT_EXIST_ARTICLE : "该文章不存在",
	ERROR_AUTH_CHECK_TOKEN_FAIL : "Token鉴权失败",
	ERROR_AUTH_CHECK_TOKEN_TIMEOUT : "Token已超时",
	ERROR_AUTH_TOKEN : "Token生成失败",
	ERROR_AUTH : "Token错误",
}

func GetMsg(code int) string {
	msg, ok := MsgFlags[code]
	if ok {
		return msg
	}

	return MsgFlags[ERROR]
}
```

#### 新增模块

因为表中 `uuid` 字段是 string 类型，所以先拉取下依赖

```
go get -u github.com/satori/go.uuid
```

* models

打开 `models` 目录新增 `module.go`，修改文件（增加 2 个方法）：

```
package models

type Module struct {
	BaseModel

	Name               string `json:"name" gorm:"name" comment:"名称" example:"notes" validate:"required"`
	EnglishName        string `json:"english_name" gorm:"english_name" comment:"英文名称" example:"notes" validate:"required"`
	Description        string `json:"description" gorm:"description" comment:"描述" example:"notes"`
	EnglishDescription string `json:"english_description" gorm:"english_description" comment:"英文描述" example:"notes"`
	Icon               string `json:"icon" gorm:"icon" comment:"图标" example:"icon"`
	Cover              string `json:"cover" gorm:"cover" comment:"封面" example:"cover"`
	NewFeatureDeadline int `json:"new_feature_deadline" gorm:"new_feature_deadline" comment:"新功能截止日期" example:"new_feature_deadline"`
	LandingPageUrl     string `json:"landing_page_url" gorm:"landing_page_url" comment:"新模块跳转链接" example:"landing_page_url"`
	State              int    `json:"state" gorm:"state" comment:"状态" example:"1"`
	Sort               int    `json:"sort" gorm:"sort" comment:"状态" example:"1"`
}

//根据名称判断模块是否存在
func ExistModuleByName(name string) bool {
	var module Module
	db.Select("uuid").Where("name = ?", name).First(&module)
	if module.Uuid != "" {
		return true
	}
	return false
}

//新增模块
func AddModule(name string, englishName string, description string, englishDescription string, icon string, cover string, newFeatureDeadline int, landingPageUrl string, state int, sort int) bool {
	db.Create(&Module{
		Name:  name,
		EnglishName: englishName,
		Description: description,
		EnglishDescription: englishDescription,
		Icon: icon,
		Cover: cover,
		NewFeatureDeadline: newFeatureDeadline,
		LandingPageUrl: landingPageUrl,
		State: state,
		Sort: sort,
	})
	return true
}
```

创建了一个 `Module struct{}`，用于 `Gorm` 的使用。并给予了附属属性 `json`，这样子在`c.JSON` 的时候就会自动转换格式，非常的便利

* routers

打开 `routers` 目录下的 `module.go`，修改文件（变动 AddModule 方法）：

```
package v1

import (
	"github.com/finnley/notes-api-gin/models"
	"github.com/finnley/notes-api-gin/pkg/e"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

//新增模块
func AddModule(c *gin.Context)  {
	var module models.Module
	err := c.ShouldBind(&module)

	code := e.INVALID_PARAMS
	if err != nil {
		log.Fatalf("INVALID_PARAMS: %v", err)
	}

	if !models.ExistModuleByName(module.Name) {
		code = e.SUCCESS
		models.AddModule(module)
	} else {
		code = e.ERROR_NOT_EXIST_MODULE
	}

	c.JSON(http.StatusOK, gin.H{
		"code": code,
		"msg": e.GetMsg(code),
		"data": make(map[string]string),
	})
}

//修改模块
func EditModule(c *gin.Context)  {

}

//删除模块
func DeleteModule(c *gin.Context)  {

}

//获取多个模块列表
func GetModules(c *gin.Context)  {

}
```

用 `Postman` 用 `POST` 访问 `http://127.0.0.1:8000/api/v1/modules`，查看 `code` 是否返回 `200` 及 `module` 表中是否有值

请求后发现表中并没有添加数据，这是因为 `gmt_create`,`gmt_modified` 两个字段是非空字段，此时显然是没有插入成功的

执行的 `SQL` 如下：

```
INSERT INTO `module` ( `gmt_create`, `gmt_modified`, `deleted_at`, `name`, `english_name`, `description`, `english_description`, `icon`, `cover`, `new_feature_deadline`, `landing_page_url`, `status`, `sort` )
VALUES
	(
		NULL,
		NULL,
		NULL,
		'Hanfu',
		'',
		'',
		'',
		'',
		'',
		0,
		'',
	0,
	0)
```

因为每个表添加记录的时候都会把 `gmt_create` 设置为插入到数据表的时候，执行更新操作的时候都会把 `gmt_modified` 修改为当前时间，所以下面对编写统一的时间设置

#### models callbacks

打开 `models` 目录下的 `models.go` 文件，修改文件内容（修改包引用和增加 2 个方法）：

```
package models

import (
	"fmt"
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/finnley/notes-api-gin/pkg/util"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	uuid "github.com/satori/go.uuid"
	"log"
	"os"
	"time"
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

	dbConnection = sec.Key("DB_CONNECTION").String()
	dbUserName = sec.Key("DB_USERNAME").MustString(os.Getenv("DB_USERNAME"))
	dbPassword = sec.Key("DB_PASSWORD").MustString(os.Getenv("DB_PASSWORD"))
	dbHost = sec.Key("DB_HOST").MustString(os.Getenv("DB_HOST"))
	dbPort = sec.Key("DB_PORT").MustString(os.Getenv("DB_PORT"))
	dbDatabase = sec.Key("DB_DATABASE").MustString(os.Getenv("DB_DATABASE"))
	tablePrefix = sec.Key("TABLE_PREFIX").String()

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

func (model *BaseModel) BeforeCreate(scope *gorm.Scope) error {
	// Creating UUID Version 4
	uuid := uuid.NewV4().String()
	scope.SetColumn("Uuid", uuid)
	//scope.SetColumn("GmtCreate", time.Now().Format("2006-01-02 15:04:05"))
	//scope.SetColumn("GmtModified", time.Now().Format("2006-01-02 15:04:05"))
	//scope.SetColumn("DeletedAt", sql.NullString{String: "", Valid: false})
	//scope.SetColumn("DeletedAt", time.Now())
	scope.SetColumn("GmtCreate", time.Now())
	scope.SetColumn("GmtModified", time.Now())

	return nil
}

func (model *BaseModel) BeforeUpdate(scope *gorm.Scope) error {
	//scope.SetColumn("GmtModified", time.Now().Format("2006-01-02 15:04:05"))
	scope.SetColumn("GmtModified", time.Now())

	return nil
}

func CloseDB() {
	defer db.Close()
}
```

重启服务，再在用 `Postman` 用 `POST` 访问 `http://127.0.0.1:8000/api/v1/modules` ，

Request:

```
{
    "module_name": "note",
    "state": 1
}
```

此时在终端会输出执行的添加SQL:

```
INSERT INTO `module` (`uuid`,`gmt_create`,`gmt_modified`,`deleted_at`,`name`,`english_name`,`description`,`english_description`,`icon`,`cover`,`new_feature_deadline`,`landing_page_url`,`status`,`sort`) VALUES ('19cf3dc1-63fb-4540-bd17-c3c4622c5a0c','2020-12-12 16:42:31.341289 +0800 CST m=+5.489377305','2020-12-12 16:42:31.341292 +0800 CST m=+5.489380847',NULL,'Hanfu','','','','','',0,'',0,0)
```

这会到表中也会看到已经添加了一条数据

观察是否添加成功

```
mysql> select * from module;
+--------------------------------------+-------------+-------+---------------------+---------------------+------------+
| uuid                                 | module_name | state | gmt_create          | gmt_modified        | deleted_at |
+--------------------------------------+-------------+-------+---------------------+---------------------+------------+
| 3f72ba3c-e1f1-484f-b4cc-c243d95bea02 | note        |     1 | 2020-11-26 00:46:24 | 2020-11-26 00:46:24 | NULL       |
+--------------------------------------+-------------+-------+---------------------+---------------------+------------+
1 row in set (0.00 sec)

mysql>
```

这属于gorm的Callbacks，可以将回调方法定义为模型结构的指针，在创建、更新、查询、删除时将被调用，如果任何回调返回错误，gorm 将停止未来操作并回滚所有更改。

gorm 所支持的回调方法：

* 创建：BeforeSave、BeforeCreate、AfterCreate、AfterSave
* 更新：BeforeSave、BeforeUpdate、AfterUpdate、AfterSave
* 删除：BeforeDelete、AfterDelete
* 查询：AfterFind

当添加同一个模块时，会看到提示该模块已存在的信息

```
{
    "code": 10002,
    "data": {},
    "msg": "该模块不存在"
}
```

#### 编辑模块

1、打开 `routers` 目录下 `v1` 版本的 `module.go`文件，修改内容：

```
package v1

import (
	"fmt"
	"github.com/finnley/notes-api-gin/models"
	"github.com/finnley/notes-api-gin/pkg/e"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

//新增模块
func AddModule(c *gin.Context)  {
	var module models.Module
	err := c.ShouldBind(&module)

	code := e.INVALID_PARAMS
	if err != nil {
		log.Fatalf("INVALID_PARAMS: %v", err)
	}

	if !models.ExistModuleByName(module.Name) {
		code = e.SUCCESS
		models.AddModule(
			module.Name,
			module.EnglishDescription,
			module.Description,
			module.EnglishDescription,
			module.Icon,
			module.Cover,
			module.NewFeatureDeadline,
			module.LandingPageUrl,
			module.Status,
			module.Sort)
	} else {
		code = e.ERROR_NOT_EXIST_MODULE
	}

	c.JSON(http.StatusOK, gin.H{
		"code": code,
		"msg": e.GetMsg(code),
		"data": make(map[string]string),
	})
}

//修改模块
func EditModule(c *gin.Context)  {
	id := c.Param("id")

	module := make(map[string]interface{})
	c.ShouldBind(&module)
	fmt.Printf("%#v\n", module)

	//TODO 数据校验

	code := e.INVALID_PARAMS
	if models.ExistModuleByID(id) {
		code = e.SUCCESS
		models.EditModule(id, module)
	} else {
		code = e.ERROR_NOT_EXIST_ARTICLE
	}

	c.JSON(http.StatusOK, gin.H{
		"code": code,
		"msg": e.GetMsg(code),
		"data": make(map[string]string),
	})
}

//删除模块
func DeleteModule(c *gin.Context)  {

}

//获取多个模块列表
func GetModules(c *gin.Context)  {

}
```

2、打开 `models` 下的 `moduele.go`, 修改文件内容：

```
...
func ExistModuleByID(uuid string) bool {
	var module Module
	db.Select("uuid").Where("uuid = ?", uuid).First(&module)
	if module.Uuid != "" {
		return true
	}
	return false
}

func EditModule(uuid string, data interface{}) bool {
	db.Model(&Module{}).Where("uuid = ?", uuid).Updates(data)
	return true
}
```

#### 删除模块

1、routers

打开 `routers` 目录下 `v1` 版本的 `module.go`文件，修改内容：

```
package v1

import (
	"fmt"
	"github.com/finnley/notes-api-gin/models"
	"github.com/finnley/notes-api-gin/pkg/e"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

//新增模块
func AddModule(c *gin.Context)  {
	var module models.Module
	err := c.ShouldBind(&module)

	code := e.INVALID_PARAMS
	if err != nil {
		log.Fatalf("INVALID_PARAMS: %v", err)
	}

	if !models.ExistModuleByName(module.Name) {
		code = e.SUCCESS
		models.AddModule(
			module.Name,
			module.EnglishDescription,
			module.Description,
			module.EnglishDescription,
			module.Icon,
			module.Cover,
			module.NewFeatureDeadline,
			module.LandingPageUrl,
			module.Status,
			module.Sort)
	} else {
		code = e.ERROR_NOT_EXIST_MODULE
	}

	c.JSON(http.StatusOK, gin.H{
		"code": code,
		"msg": e.GetMsg(code),
		"data": make(map[string]string),
	})
}

//修改模块
func EditModule(c *gin.Context)  {
	id := c.Param("id")

	module := make(map[string]interface{})
	c.ShouldBind(&module)
	fmt.Printf("%#v\n", module)

	//TODO 数据校验

	code := e.INVALID_PARAMS
	if models.ExistModuleByID(id) {
		code = e.SUCCESS
		models.EditModule(id, module)
	} else {
		code = e.ERROR_NOT_EXIST_ARTICLE
	}

	c.JSON(http.StatusOK, gin.H{
		"code": code,
		"msg": e.GetMsg(code),
		"data": make(map[string]string),
	})
}

//删除模块
func DeleteModule(c *gin.Context)  {
	id := c.Param("id")

	code := e.INVALID_PARAMS

	// TODO 数据校验

	if models.ExistModuleByID(id) {
		code = e.SUCCESS
		models.DeleteModule(id)
	} else {
		code = e.ERROR_NOT_EXIST_MODULE
	}

	c.JSON(http.StatusOK, gin.H{
		"code": code,
		"msg": e.GetMsg(code),
		"data": make(map[string]string),
	})
}

//获取多个模块列表
func GetModules(c *gin.Context)  {

}
```

2、打开 `models` 下的 `module.go`, 修改文件内容：

```
...
func DeleteModule(uuid string) bool {
	db.Where("uuid = ?", uuid).Delete(&Module{})
	return true
}
```

#### 验证功能

重启服务，用 `Postman`

* `DELETE` 访问 `http://127.0.0.1:8000/api/v1/module/fa4a89b6-83e6-452d-b1d5-eb9ccea71bb0` ，查看 code 是否返回 200

#### 获取多个模块列表

* models

在 `models` 目录下的 `module.go`，写入文件内容：

```
package models

type Module struct {
	BaseModel

	Name               string `json:"name" gorm:"name" comment:"名称" example:"notes" validate:"required"`
	EnglishName        string `json:"english_name" gorm:"english_name" comment:"英文名称" example:"notes" validate:"required"`
	Description        string `json:"description" gorm:"description" comment:"描述" example:"notes"`
	EnglishDescription string `json:"english_description" gorm:"english_description" comment:"英文描述" example:"notes"`
	Icon               string `json:"icon" gorm:"icon" comment:"图标" example:"icon"`
	Cover              string `json:"cover" gorm:"cover" comment:"封面" example:"cover"`
	NewFeatureDeadline int    `json:"new_feature_deadline" gorm:"new_feature_deadline" comment:"新功能截止日期" example:"new_feature_deadline"`
	LandingPageUrl     string `json:"landing_page_url" gorm:"landing_page_url" comment:"新模块跳转链接" example:"landing_page_url"`
	Status             int    `json:"status" gorm:"state" comment:"状态" example:"1"`
	Sort               int    `json:"sort" gorm:"sort" comment:"状态" example:"1"`
}

// 返回模块列表数据
type ModuleData struct {
	Uuid           string `json:"uuid"`
	Name           string `json:"name"`
	Description    string `json:"description"`
	Icon           string `json:"icon"`
	Cover          string `json:"cover"`
	IsNew          int    `json:"is_new"`
	LandingPageUrl string `json:"landing_page_url"`
}

...

func GetModules(pageNum int, pageSize int, maps interface{}) (modules []Module) {
	db.Where(maps).Offset(pageNum).Limit(pageSize).Find(&modules)

	return
}

func GetModuleTotal(maps interface{}) (count int) {
	db.Model(&Module{}).Where(maps).Count(&count)

	return
}
```

看到 `return`，而后面没有跟着变量，可以看到在函数末端，我们已经显示声明了返回值，这个变量在函数体内也可以直接使用，因为它在一开始就被声明了

db 是哪里来的? 因为在同个 `models` 包下，因此 `db *gorm.DB` 是可以直接使用的

* router

打开 `routers` 目录下 `v1` 版本的 `module.go`

```
...

//获取多个模块列表
func GetModules(c *gin.Context)  {
	moduleName := c.Query("name")

	maps := make(map[string]interface{})
	data := make(map[string]interface{})

	if moduleName != "" {
		maps["module_name"] = moduleName
	}

	var state int = -1
	if arg := c.Query("status"); arg != "" {
		state = com.StrTo(arg).MustInt()
		maps["status"] = state
	}

	code := e.SUCCESS

	//data["lists"] = models.GetModules(util.GetPage(c), setting.PageSize, maps)
	modules := models.GetModules(util.GetPage(c), setting.PageSize, maps)

	var list []models.ModuleData

	for key, val := range modules {
		var module models.ModuleData
		module.Uuid = val.Uuid
		module.Name = val.Name
		module.Description = val.Description
		module.Icon = val.Icon
		module.Cover = val.Cover
		if modules[key].NewFeatureDeadline > time.Now().Second() {
			module.IsNew = 1
		} else {
			module.IsNew = 0
		}
		module.LandingPageUrl = val.LandingPageUrl

		list = append(list, module)
	}
	data["lists"] = list
	data["total"] = models.GetModuleTotal(maps)

	c.JSON(http.StatusOK, gin.H{
		"code": code,
		"msg": e.GetMsg(code),
		"data": data,
	})
}
```

1. `c.Query` 可用于获取 `?name=test&state=1` 这类 URL 参数，而 `c.DefaultQuery` 则支持设置一个默认值
2. `code` 变量使用了 `e` 模块的错误编码，这正是先前规划好的错误码，方便排错和识别记录
3. `util.GetPage` 保证了各接口的 page 处理是一致的
4. `c *gin.Context` 是 `Gin` 很重要的组成部分，可以理解为上下文，它允许我们在中间件之间传递变量、管理流、验证请求的 JSON 和呈现 JSON 响应

在本机执行 `curl 127.0.0.1:8000/api/v1/modules`，正确的返回值为 `{"code":200,"data":{"lists":[...],"total":0},"msg":"ok"}`。

在获取模块列表接口中，我们可以根据 `name`、`state`、`page` 来筛选查询条件，分页的步长可通过 `app.ini` 进行配置，以 `lists`、`total` 的组合返回达到分页效果。

# Docker 部署

t4_deploy

## 目标

将 `notes-api-gin` 应用部署到 `Docker`

## Docker 

![](https://images.notes.xuepincat.com/docker/docker.jpeg)

`Docker` 是一个开源的轻量级容器技术，让开发者可以打包他们的应用以及应用运行的上下文环境到一个可移植的镜像中，然后发布到任何支持 `Docker` 的系统上运行。 通过容器技术，在几乎没有性能开销的情况下，`Docker` 为应用提供了一个隔离运行环境

* 简化配置
* 代码流水线管理
* 提高开发效率
* 隔离应用
* 快速、持续部署

## 编写 Dockerfile

在 `notes-api-gin` 项目根目录创建 `Dockerfile` 文件，写入内容

```
FROM golang:latest

ENV GOPROXY https://goproxy.cn,direct
WORKDIR $GOPATH/src/github.com/finnley/notes-api-gin
COPY . $GOPATH/src/github.com/finnley/notes-api-gin
RUN go build .

EXPOSE 8000
ENTRYPOINT ["./notes-api-gin"]
```

#### 作用

`golang:latest` 镜像为基础镜像，将工作目录设置为 `$GOPATH/src/notes-api-gin`，并将当前上下文目录的内容复制到 `$GOPATH/src/notes-api-gin` 中

在进行 `go build` 编译完毕后，将容器启动程序设置为 `./notes-api-gin`，也就是我们所编译的可执行文件

注意 `notes-api-gi`n` 在 `docker` 容器里编译，并没有在宿主机现场编译

#### 说明

`Dockerfile` 文件是用于定义 `Docker` 镜像生成流程的配置文件，文件内容是一条条指令，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建；这些指令应用于基础镜像并最终创建一个新的镜像

可以认为用于快速创建自定义的 `Docker` 镜像

* FROM

指定基础镜像（必须有的指令，并且必须是第一条指令）

* WORKDIR

格式为 `WORKDIR <工作目录路径>`

使用 `WORKDIR` 指令可以来指定工作目录（或者称为当前目录），以后各层的当前目录就被改为指定的目录，如果目录不存在，`WORKDIR` 会帮你建立目录

* COPY

格式：

```
COPY <源路径>... <目标路径>
COPY ["<源路径1>",... "<目标路径>"]
```

`COPY` 指令将从构建上下文目录中 <源路径> 的文件/目录 `复制` 到新的一层的镜像内的 <目标路径> 位置

* RUN

用于执行命令行命令

格式：`RUN <命令>`

* EXPOSE

格式为 `EXPOSE <端口 1> [<端口 2>…]`

`EXPOSE` 指令是声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务

在 `Dockerfile` 中写入这样的声明有两个好处

1. 帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射
2. 运行时使用随机端口映射时，也就是 `docker run -P` 时，会自动随机映射 `EXPOSE` 的端口

* ENTRYPOINT

`ENTRYPOINT` 的格式和 `RUN` 指令格式一样，分为两种格式

1. exec 格式：

```
<ENTRYPOINT> "<CMD>"
```

2. shell 格式：

```
ENTRYPOINT [ "curl", "-s", "http://ip.cn" ]
```

`ENTRYPOINT` 指令是指定容器启动程序及参数

## 构建镜像

`notes-api-gin` 的项目根目录下执行 `docker build -t notes-api-docker .`

该命令作用是创建/构建镜像，`-t` 指定名称为 `notes-api-docker`，. 构建内容为当前上下文目录

```
✗ docker build -t notes-api-docker .
Sending build context to Docker daemon  593.4kB
Step 1/7 : FROM golang:latest
 ---> 6d8772fbd285
Step 2/7 : ENV GOPROXY https://goproxy.cn,direct
 ---> Using cache
 ---> 935022d58444
Step 3/7 : WORKDIR $GOPATH/src/github.com/finnley/notes-api-gin
 ---> Using cache
 ---> 48f8ff19e858
Step 4/7 : COPY . $GOPATH/src/github.com/finnley/notes-api-gin
 ---> fab1dc54377a
Step 5/7 : RUN go build .
 ---> Running in 9316ca0085fd
go: downloading github.com/joho/godotenv v1.3.0
go: downloading github.com/go-ini/ini v1.62.0
go: downloading github.com/unknwon/com v1.0.1
go: downloading github.com/gin-gonic/gin v1.6.3
go: downloading github.com/satori/go.uuid v1.2.0
go: downloading github.com/jinzhu/gorm v1.9.16
go: downloading github.com/gin-contrib/sse v0.1.0
go: downloading github.com/mattn/go-isatty v0.0.12
go: downloading github.com/ugorji/go v1.2.1
go: downloading github.com/golang/protobuf v1.4.3
go: downloading gopkg.in/yaml.v2 v2.4.0
go: downloading github.com/go-playground/validator/v10 v10.4.1
go: downloading github.com/go-sql-driver/mysql v1.5.0
go: downloading github.com/jinzhu/inflection v1.0.0
go: downloading github.com/ugorji/go/codec v1.2.1
go: downloading golang.org/x/sys v0.0.0-20201211090839-8ad439b19e0f
go: downloading google.golang.org/protobuf v1.25.0
go: downloading github.com/go-playground/universal-translator v0.17.0
go: downloading golang.org/x/crypto v0.0.0-20201208171446-5f87f3452ae9
go: downloading github.com/leodido/go-urn v1.2.0
go: downloading github.com/go-playground/locales v0.13.0
# github.com/finnley/notes-api-gin
./main.go:10:6: main redeclared in this block
	previous declaration at ./example.go:5:6
The command '/bin/sh -c go build .' returned a non-zero code: 2
```

构建的时候提示下面错误，只需要将根目录下的 `example.go` 文件删掉即可，这个文件是之前测试用的

删除之后重新构建

`docker build -t notes-api-docker .`

```
✗ docker build -t notes-api-docker .
Sending build context to Docker daemon  594.4kB
Step 1/7 : FROM golang:latest
 ---> 6d8772fbd285
Step 2/7 : ENV GOPROXY https://goproxy.cn,direct
 ---> Using cache
 ---> 935022d58444
Step 3/7 : WORKDIR $GOPATH/src/github.com/finnley/notes-api-gin
 ---> Using cache
 ---> 48f8ff19e858
Step 4/7 : COPY . $GOPATH/src/github.com/finnley/notes-api-gin
 ---> fa5638f4c809
Step 5/7 : RUN go build .
 ---> Running in 04ab66b77af5
go: downloading github.com/gin-gonic/gin v1.6.3
go: downloading github.com/go-ini/ini v1.62.0
go: downloading github.com/joho/godotenv v1.3.0
go: downloading github.com/satori/go.uuid v1.2.0
go: downloading github.com/jinzhu/gorm v1.9.16
go: downloading github.com/unknwon/com v1.0.1
go: downloading github.com/gin-contrib/sse v0.1.0
go: downloading github.com/mattn/go-isatty v0.0.12
go: downloading github.com/ugorji/go v1.2.1
go: downloading gopkg.in/yaml.v2 v2.4.0
go: downloading github.com/golang/protobuf v1.4.3
go: downloading github.com/go-playground/validator/v10 v10.4.1
go: downloading github.com/go-sql-driver/mysql v1.5.0
go: downloading github.com/jinzhu/inflection v1.0.0
go: downloading github.com/ugorji/go/codec v1.2.1
go: downloading golang.org/x/sys v0.0.0-20201211090839-8ad439b19e0f
go: downloading google.golang.org/protobuf v1.25.0
go: downloading github.com/go-playground/universal-translator v0.17.0
go: downloading golang.org/x/crypto v0.0.0-20201208171446-5f87f3452ae9
go: downloading github.com/go-playground/locales v0.13.0
go: downloading github.com/leodido/go-urn v1.2.0
Removing intermediate container 04ab66b77af5
 ---> a31fe52805b1
Step 6/7 : EXPOSE 8000
 ---> Running in 2f16e32a8be6
Removing intermediate container 2f16e32a8be6
 ---> 9a15272ad6db
Step 7/7 : ENTRYPOINT ["./notes-api-gin"]
 ---> Running in a9a1cefee6f0
Removing intermediate container a9a1cefee6f0
 ---> 97838407ad1f
Successfully built 97838407ad1f
Successfully tagged notes-api-docker:latest
```

## 验证镜像

查看所有的镜像，确定刚刚构建的 `notes-api-docker` 镜像是否存在

```
docker images
✗ docker images
REPOSITORY                     TAG       IMAGE ID       CREATED              SIZE
notes-api-docker               latest    97838407ad1f   About a minute ago   955MB
...
```

## 创建并运行一个新容器

执行命令 `docker run -p 8000:8000 notes-api-docker`

```
docker run -p 8000:8000 notes-api-docker
2020/12/15 15:52:57 dial tcp 127.0.0.1:3306: connect: connection refused
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /ping                     --> github.com/finnley/notes-api-gin/routers.InitRouter.func1 (3 handlers)
[GIN-debug] POST   /api/v1/modules           --> github.com/finnley/notes-api-gin/routers/api/v1.AddModule (3 handlers)
[GIN-debug] PUT    /api/v1/modules/:id       --> github.com/finnley/notes-api-gin/routers/api/v1.EditModule (3 handlers)
[GIN-debug] DELETE /api/v1/modules/:id       --> github.com/finnley/notes-api-gin/routers/api/v1.DeleteModule (3 handlers)
[GIN-debug] GET    /api/v1/modules           --> github.com/finnley/notes-api-gin/routers/api/v1.GetModules (3 handlers)

```

运行成功，你以为大功告成了吗？

你想太多了，仔细看看控制台的输出了一条错误 `dial tcp 127.0.0.1:3306: connect: connection refused`

发现是 `MySQL` 的问题

## MySQL

#### 拉取镜像

从 `Docker` 的公共仓库 `Dockerhub` 下载 `MySQL:5.7` 镜像（国内建议配个镜像）

```
docker pull mysql:5.7
```

#### 创建并运行一个新容器

运行 `MySQL` 容器，并设置执行成功后返回容器 `ID`

```
docker run --name mysql -p 33060:3306 -e MYSQL_ROOT_PASSWORD=123 -d mysql:5.7
6c1dca0c5c0172080c3b71370370e73a3e70f9b48086bf5f3a535971e86f1f4f
```

#### 连接 MySQL

略

## 删除镜像

由于原本的镜像存在问题，我们需要删除它，此处有几种做法

* 删除原本有问题的镜像，重新构建一个新镜像
* 重新构建一个不同 name、tag 的新镜像

删除原本的有问题的镜像，`-f` 是强制删除及其关联状态

若不执行 `-f`，需要执行 `docker ps -a` 查到所关联的容器，将其 `rm` 解除两者依赖关系

```
✗ docker rmi -f notes-api-docker
Untagged: notes-api-docker:latest
Deleted: sha256:97838407ad1ff5c7919234b0ed6e5105e6356fa0e02cf2d682468a7a1f32dff5
Deleted: sha256:9a15272ad6db8a0a8b38d012bd72c8f6c521cd892e8503e3392014e1fa68135e
Deleted: sha256:a31fe52805b1cfb94e86a77d675980731bafc581287a89eea29732df1610c8db
Deleted: sha256:7a01168947d5e02de7fc2d53b2d11856a9df3b09b1d0e7a7dbf0ca24273bc6f7
Deleted: sha256:fa5638f4c809ce4f1ee290b5201b007fbf3197270c4d65a0c7c59a6a9842df15
Deleted: sha256:106cb795a6d443c2c0ecb9defb8463d0471626b4208669d72cd31efe689a469d
```

## 修改配置文件

将项目的配置文件 `.env`，内容修改为

```
# debug or release
RUN_MODE=debug

JWT_SECRET=!@)*#)!@U#@*!@!)

HTTP_PORT=8000
READ_TIMEOUT=60
WRITE_TIMEOUT=60

DB_CONNECTION=mysql
# 127.0.0.1:3306
DB_HOST=mysql
DB_USERNAME=root
DB_PASSWORD=123
DB_PORT=3306
DB_DATABASE=notes
# DB_TABLE_PREFIX=notes_

PAGE_SIZE=10
```

## 重新构建镜像

重复先前的步骤，回到 `notes-api-gin` 的项目根目录下执行 `docker build -t notes-api-docker .`

## 创建并运行一个新容器

#### 关联

* 将 `Golang` 容器和 `MySQL` 容器关联起来，那么我们需要怎么做呢？

增加命令 `--link mysql:mysql` 让 `Golang` 容器与 `MySQL` 容器互联；通过 `--link`，可以在容器内直接使用其关联的容器别名进行访问，而不通过 IP，但是 `--link` 只能解决单机容器间的关联，在分布式多机的情况下，需要通过别的方式进行连接

#### 运行

执行命令 `docker run --link mysql:mysql -p 8000:8000 notes-api-docker`

```
✗ docker run --link mysql:mysql -p 8000:8000 notes-api-docker
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /ping                     --> github.com/finnley/notes-api-gin/routers.InitRouter.func1 (3 handlers)
[GIN-debug] POST   /api/v1/modules           --> github.com/finnley/notes-api-gin/routers/api/v1.AddModule (3 handlers)
[GIN-debug] PUT    /api/v1/modules/:id       --> github.com/finnley/notes-api-gin/routers/api/v1.EditModule (3 handlers)
[GIN-debug] DELETE /api/v1/modules/:id       --> github.com/finnley/notes-api-gin/routers/api/v1.DeleteModule (3 handlers)
[GIN-debug] GET    /api/v1/modules           --> github.com/finnley/notes-api-gin/routers/api/v1.GetModules (3 handlers)
2020/12/15 16:11:10 dial tcp 127.0.0.1:3306: connect: connection refused

```

#### 结果

检查启动输出、接口测试、数据库内数据，均正常；我们的 `Golang` 容器和 `MySQL` 容器成功关联运行，大功告成 :)

## Review

#### 思考

* 为什么 `notes-api-docker` 占用空间这么大？（可用 docker ps -as | grep notes-api-docker 查看）
* MySQL 容器直接这么使用，数据存储到哪里去了？

## 创建超小的 Golang 镜像

* 为什么 `notes-api-docker` 占用空间这么大？（可用 docker ps -as | grep notes-api-docker 查看）

这是因为 `FROM golang:latest` 拉取的是官方 golang 镜像，包含 Golang 的编译和运行环境，外加一堆 GCC、build 工具，相当齐全

这是有问题的，我们可以不在 Golang 容器中现场编译的，压根用不到那些东西，我们只需要一个能够运行可执行文件的环境即可

#### 构建 Scratch 镜像

`Scratch` 镜像，简洁、小巧，基本是个空镜像

* 修改 `Dockerfile`

```
FROM scratch

WORKDIR $GOPATH/src/github.com/finnley/notes-api-gin
COPY . $GOPATH/src/github.com/finnley/notes-api-gin

EXPOSE 8000
CMD ["./notes-api-gin"]
```

* 编译可执行文件

```
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o notes-api-gin .
```

编译所生成的可执行文件会依赖一些库，并且是动态链接。在这里因为使用的是 `scratch` 镜像，它是空镜像，因此我们需要将生成的可执行文件静态链接所依赖的库

* 构建镜像

```
✗ docker build -t notes-api-docker-scratch .
Sending build context to Docker daemon  17.19MB
Step 1/5 : FROM scratch
 --->
Step 2/5 : WORKDIR $GOPATH/src/github.com/finnley/notes-api-gin
 ---> Using cache
 ---> 29ece8ab7341
Step 3/5 : COPY . $GOPATH/src/github.com/finnley/notes-api-gin
 ---> ef8d0ac7bdfb
Step 4/5 : EXPOSE 8000
 ---> Running in 2065f55c20af
Removing intermediate container 2065f55c20af
 ---> 867acc3146ca
Step 5/5 : CMD ["./notes-api-gin"]
 ---> Running in 17f72a1557c2
Removing intermediate container 17f72a1557c2
 ---> 6c47c90aaedb
Successfully built 6c47c90aaedb
Successfully tagged notes-api-docker-scratch:latest
```

注意，假设 `Golang` 应用没有依赖任何的配置等文件，是可以直接把可执行文件给拷贝进去即可，其他都不必关心

这里可以有好几种解决方案

* 依赖文件统一管理挂载
* go-bindata 一下
...

因此这里如果解决了文件依赖的问题后，就不需要把目录给 `COPY` 进去了

#### 运行

```
✗ docker run --link mysql:mysql -p 8000:8000 notes-api-docker-scratch
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GIN_MODE=release
 - using code:	gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /ping                     --> github.com/finnley/notes-api-gin/routers.InitRouter.func1 (3 handlers)
[GIN-debug] POST   /api/v1/modules           --> github.com/finnley/notes-api-gin/routers/api/v1.AddModule (3 handlers)
[GIN-debug] PUT    /api/v1/modules/:id       --> github.com/finnley/notes-api-gin/routers/api/v1.EditModule (3 handlers)
[GIN-debug] DELETE /api/v1/modules/:id       --> github.com/finnley/notes-api-gin/routers/api/v1.DeleteModule (3 handlers)
[GIN-debug] GET    /api/v1/modules           --> github.com/finnley/notes-api-gin/routers/api/v1.GetModules (3 handlers)
```

成功运行，程序也正常接收请求

接下来我们再看看占用大小，执行 `docker ps -as` 命令

```
✗ docker ps -as
CONTAINER ID   IMAGE                      COMMAND                  CREATED              STATUS                     PORTS                                     NAMES                SIZE
9102c806964a   notes-api-docker-scratch   "./notes-api-gin"        About a minute ago   Up About a minute          0.0.0.0:8000->8000/tcp                    thirsty_cartwright   0B (virtual 17MB)
19468f2322e2   notes-api-docker           "./notes-api-gin"        12 minutes ago       Exited (2) 4 minutes ago                                             elegant_heisenberg   0B (virtual 955MB)
```

从结果而言，占用大小以 `Scratch` 镜像为基础的容器完胜，完成目标

## MySQL 挂载数据卷

倘若不做任何干涉，在每次启动一个 `MySQL` 容器时，数据库都是空的。另外容器删除之后，数据就丢失了（还有各类意外情况），非常糟糕！

#### 数据卷

数据卷 是被设计用来持久化数据的，它的生命周期独立于容器，`Docker` 不会在容器被删除后自动删除 数据卷，并且也不存在垃圾回收这样的机制来处理没有任何容器引用的 数据卷。如果需要在删除容器的同时移除数据卷。可以在删除容器的时候使用 `docker rm -v` 这个命令

数据卷 是一个可供一个或多个容器使用的特殊目录，它绕过 UFS，可以提供很多有用的特性：

* 数据卷 可以在容器之间共享和重用
* 对 数据卷 的修改会立马生效
* 对 数据卷 的更新，不会影响镜像
* 数据卷 默认会一直存在，即使容器被删除

    注意：数据卷 的使用，类似于 Linux 下对目录或文件进行 mount，镜像中的被指定为挂载点的目录中的文件会隐藏掉，能显示看的是挂载的 数据卷。
    
#### 如何挂载

首先创建一个目录用于存放数据卷；示例目录 `/data/docker-mysql`，注意 `--name` 原本名称为 `mysql` 的容器，需要将其删除 `docker rm`

```
docker stop mysql
docker rm mysql
```

运行 MySQL 容器并挂载

```
✗ docker run --name mysql -p 33060:3306 -e MYSQL_ROOT_PASSWORD=123 -v mysql-data:/var/lib/mysql -d mysql:5.7
3c01dc9f70844c0ea50fbe18ebccec96d26856f0114bd9187dedf273294c6c97
```
 
创建成功，检查目录 `mysql-data`，下面多了不少数据库文件

#### 验证

接下来交由你进行验证，目标是创建一些测试表和数据，然后删除当前容器，重新创建的容器，数据库数据也依然存在（当然了数据卷指向要一致）

## docker-compose

## 创建 docker-compose.yml

```
version: '3'

services:
  notes-api:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - 8000:8000
    networks:
      - my-bridge

  mysql:
    image: mysql:5.7
    ports:
      - 33060:3306
    environment:
      MYSQL_ROOT_PASSWORD: 123
      MYSQL_DATABASE: notes
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - my-bridge

volumes:
  mysql-data:

networks:
  my-bridge:
    driver: bridge
```

## 启动

# JWT 身份校验

## 目标

前面已经完成了模块API的编写，但是还存在一些非常严重的问题，比如现在的API是可以随意调用的，这显然不安全，所以接下来打算通过 `jwt-go(GoDoc)` 的方式来解决这个问题

## 准备

修改 `.env` 文件中数据库连接配置，因为之前容器部署将数据库连接配置改成了 `DB_HOST=mysql`，现在需要改成 `DB_HOST=127.0.0.1`

## 创建 auth 表

```
CREATE TABLE `auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT '' COMMENT '账号',
  `password` varchar(50) DEFAULT '' COMMENT '密码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `auth` (`id`, `username`, `password`) VALUES (null, 'test', 'test123456');
```

## 下载依赖包

首先下载 `jwt-go` 的依赖包

```
go get -u github.com/dgrijalva/jwt-go
```

## 编写 jwt 工具包

编写一个 `jwt` 的工具包，在 `pkg`下的 `util` 目录新建 `jwt.go`，写入文件内容：

```
package util

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/finnley/notes-api-gin/pkg/setting"
	"time"
)

var jwtSecret = []byte(setting.JwtSecret)

type Claims struct {
	Username string `json:"username"`
	Password string `json:"password"`
	jwt.StandardClaims
}

func GenerateToken(username, password string) (string, error) {
	nowTime := time.Now()
	expireTime := nowTime.Add(3 * time.Hour)

	claims := Claims{
		username,
		password,
		jwt.StandardClaims {
			ExpiresAt : expireTime.Unix(),
			Issuer : "gin-blog",
		},
	}

	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	token, err := tokenClaims.SignedString(jwtSecret)

	return token, err
}

func ParseToken(token string) (*Claims, error) {
	tokenClaims, err := jwt.ParseWithClaims(token, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})

	if tokenClaims != nil {
		if claims, ok := tokenClaims.Claims.(*Claims); ok && tokenClaims.Valid {
			return claims, nil
		}
	}

	return nil, err
}
```

在这个工具包，涉及到下面知识点

* `NewWithClaims(method SigningMethod, claims Claims)`，`method` 对应着 `SigningMethodHMAC struct{}`，其包含 `SigningMethodHS256`、`SigningMethodHS384`、`SigningMethodHS512` 三种 `crypto.Hash` 方案
* `func (t *Token) SignedString(key interface{})` 该方法内部生成签名字符串，再用于获取完整、已签名的token
* `func (p *Parser) ParseWithClaims` 用于解析鉴权的声明，方法内部主要是具体的解码和校验的过程，最终返回 `*Token`
* `func (m MapClaims) Valid()` 验证基于时间的声明 `exp`, `iat`, `nbf`，注意如果没有任何声明在令牌中，仍然会被认为是有效的。并且对于时区偏差没有计算方法

有了 `jwt` 工具包，接下来我们要编写要用于 `Gin` 的中间件，我们在 `middleware` 下新建 `jwt` 目录，新建 `jwt.go` 文件，写入内容：

```
package jwt

import (
	"github.com/finnley/notes-api-gin/pkg/e"
	"github.com/finnley/notes-api-gin/pkg/util"
	"github.com/gin-gonic/gin"
	"net/http"
	"time"
)

func JWT() gin.HandlerFunc {
	return func(c *gin.Context) {
		var code int
		var data interface{}

		code = e.SUCCESS
		token := c.Query("token")
		if token == "" {
			code = e.INVALID_PARAMS
		} else {
			claims, err := util.ParseToken(token)
			if err != nil {
				code = e.ERROR_AUTH_CHECK_TOKEN_FAIL
			} else if time.Now().Unix() > claims.ExpiresAt {
				code = e.ERROR_AUTH_CHECK_TOKEN_TIMEOUT
			}
		}

		if code != e.SUCCESS {
			c.JSON(http.StatusUnauthorized, gin.H{
				"code" : code,
				"msg" : e.GetMsg(code),
				"data" : data,
			})

			c.Abort()
			return
		}

		c.Next()
	}
}
```

## 获取Token

如何调用?，我们还要获取Token?

1. 新增一个获取Token的 API

在 `models` 下新建 `auth.go` 文件，写入内容：

```
package models

type Auth struct {
	ID int `gorm:"primary_key" json:"id"`
	Username string `json:"username"`
	Password string `json:"password"`
}

func CheckAuth(username, password string) bool {
	var auth Auth
	db.Select("id").Where(Auth{Username: username, Password: password}).First(&auth)
	if auth.ID > 0 {
		return true
	}

	return false
}
```

在 `routers` 下的 `api` 目录新建 `auth.go` 文件，写入内容：

```
package api

import (
	"github.com/astaxie/beego/validation"
	"github.com/finnley/notes-api-gin/models"
	"github.com/finnley/notes-api-gin/pkg/e"
	"github.com/finnley/notes-api-gin/pkg/util"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

type auth struct {
	Username string `valid:"Required" MaxSize(50)`
	Password string `valid:"Required" MaxSize(50)`
}

func GetAuth(c *gin.Context)  {
	username := c.Query("username")
	password := c.Query("password")

	valid := validation.Validation{}
	a := auth{Username: username, Password: password}
	ok, _ := valid.Valid(&a)

	data := make(map[string]interface{})
	code := e.INVALID_PARAMS
	if ok {
		isExist := models.CheckAuth(username, password)
		if isExist {
			token, err := util.GenerateToken(username, password)
			if err != nil {
				code = e.ERROR_AUTH_TOKEN
			} else {
				data["token"] = token
				code = e.SUCCESS
			}
		} else {
			code = e.ERROR_AUTH
		}
	} else {
		for _, err := range valid.Errors {
			log.Printf(err.Key, err.Message)
		}
	}
	c.JSON(http.StatusOK, gin.H{
		"code": "code",
		"msg": e.GetMsg(code),
		"data": data,
	})
}
```

打开 `routers` 目录下的 `router.go` 文件，修改文件内容（新增获取 token 的方法）：

```
package routers

import (
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/finnley/notes-api-gin/routers/api"
	v1 "github.com/finnley/notes-api-gin/routers/api/v1"
	"github.com/gin-gonic/gin"
)

func InitRouter() *gin.Engine {
	r := gin.New()

	r.Use(gin.Logger())

	r.Use(gin.Recovery())

	gin.SetMode(setting.RunMode)

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

    // 获取 token
	r.GET("/auth", api.GetAuth)

	apiv1 := r.Group("/api/v1")
	{
		...
	}

	return r
}
```

## 验证 Token

获取 `token` 的 `API` 方法就到这里啦，让我们来测试下是否可以正常使用吧！

重启服务后，用 `GET` 方式访问 `http://127.0.0.1:8000/auth?username=test&password=test123456`，查看返回值是否正确

```
{
    "code": "code",
    "data": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJwYXNzd29yZCI6InRlc3QxMjM0NTYiLCJleHAiOjE2MDgzNjEyOTUsImlzcyI6Imdpbi1ibG9nIn0.iZN7Hgvv7p8C_Qfiy31WpftTBkR-AseRYhbibBenjhk"
    },
    "msg": "ok"
}
```

有了 `token` 的 `API`，表示调用成功了

## 将中间件接入 Gin

接下来将中间件接入到 `Gin` 的访问流程中

打开 `routers` 目录下的 `router.go` 文件，修改文件内容（新增引用包和中间件引用）

```
package routers

import (
	"github.com/finnley/notes-api-gin/middleware/jwt"
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/finnley/notes-api-gin/routers/api"
	v1 "github.com/finnley/notes-api-gin/routers/api/v1"
	"github.com/gin-gonic/gin"
)

func InitRouter() *gin.Engine {
	r := gin.New()

	r.Use(gin.Logger())

	r.Use(gin.Recovery())

	gin.SetMode(setting.RunMode)

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	// 获取 token
	r.GET("/auth", api.GetAuth)

	apiv1 := r.Group("/api/v1")
	apiv1.Use(jwt.JWT())
	{
		...
	}

	return r
}
```

当前目录结构：

```
.
├── Dockerfile
├── Dockerfile.bak
├── README.md
├── conf
│   └── app.ini
├── data
│   └── notes.sql
├── docker-compose.yml
├── go.mod
├── go.sum
├── main.go
├── middleware
│   └── jwt
│       └── jwt.go
├── models
│   ├── auth.go
│   ├── models.go
│   └── module.go
├── notes-api-gin
├── pkg
│   ├── e
│   │   ├── code.go
│   │   └── msg.go
│   ├── setting
│   │   └── setting.go
│   └── util
│       ├── jwt.go
│       ├── pagination.go
│       └── time.go
├── routers
│   ├── api
│   │   ├── auth.go
│   │   └── v1
│   │       └── module.go
│   └── router.go
└── runtime
```

到这里，`JWT` 编写就完成啦！

## 验证功能

* http://127.0.0.1:8000/api/v1/modules?status=1

```
{
    "code": 400,
    "data": null,
    "msg": "请求参数错误"
}
```

* http://127.0.0.1:8000/api/v1/modules?status=1&token=123

```
{
    "code": 20001,
    "data": null,
    "msg": "Token鉴权失败"
}
```

需要访问 `http://127.0.0.1:8000/auth?username=test&password=test123456`，得到 `token`

```
{
    "code": "code",
    "data": {
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJwYXNzd29yZCI6InRlc3QxMjM0NTYiLCJleHAiOjE2MDgzNjIwOTgsImlzcyI6Imdpbi1ibG9nIn0.DXR8-cWbESSevS85PAKDLPA3tihumQYOmnyX5Xi5X3A"
    },
    "msg": "ok"
}
```

再用包含token的 URL 参数去访问我们的应用 API，

访问 `http://127.0.0.1:8000/api/v1/modules?status=1&token=eyJhbGciOi...`，检查接口返回值

```
{
    "code": 200,
    "data": {
        "lists": [
            {
                "uuid": "0eb56800-aedd-44cb-bdf6-98c6ce233f07",
                "name": "music",
                "description": "",
                "icon": "",
                "cover": "",
                "is_new": 0,
                "landing_page_url": ""
            },
            {
                "uuid": "a8cbb6c8-2a3c-4cab-b1e8-78992b8db8c4",
                "name": "video",
                "description": "",
                "icon": "",
                "cover": "",
                "is_new": 1,
                "landing_page_url": ""
            },
            {
                "uuid": "f99db74f-1ab8-422d-9a28-893d038ff810",
                "name": "note",
                "description": "",
                "icon": "",
                "cover": "",
                "is_new": 0,
                "landing_page_url": ""
            }
        ],
        "total": 3
    },
    "msg": "ok"
}
```

返回正确，至此我们的 `jwt-go` 在 `Gin` 中的就完成了！

