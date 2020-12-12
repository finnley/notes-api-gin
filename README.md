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