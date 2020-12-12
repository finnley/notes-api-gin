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
		models.AddModule(
			module.Name,
			module.EnglishDescription,
			module.Description,
			module.EnglishDescription,
			module.Icon,
			module.Cover,
			module.NewFeatureDeadline,
			module.LandingPageUrl,
			module.State,
			module.Sort,)
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