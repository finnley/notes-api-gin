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