package v1

import (
	"fmt"
	"github.com/finnley/notes-api-gin/models"
	"github.com/finnley/notes-api-gin/pkg/e"
	"github.com/finnley/notes-api-gin/pkg/setting"
	"github.com/finnley/notes-api-gin/pkg/util"
	"github.com/gin-gonic/gin"
	"github.com/unknwon/com"
	"log"
	"net/http"
	"time"
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