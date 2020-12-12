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
DB_HOST=127.0.0.1:3306
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
# 127.0.0.1:3306
DB_HOST = 127.0.0.1:3306
DB_USERNAME =
DB_PASSWORD =
DB_PORT = 3306
DB_DATABASE = notes
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