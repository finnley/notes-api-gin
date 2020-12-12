package models

import (
	"github.com/jinzhu/gorm"
	uuid "github.com/satori/go.uuid"
	"time"
)

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
		Name:               name,
		EnglishName:        englishName,
		Description:        description,
		EnglishDescription: englishDescription,
		Icon:               icon,
		Cover:              cover,
		NewFeatureDeadline: newFeatureDeadline,
		LandingPageUrl:     landingPageUrl,
		State:              state,
		Sort:               sort,
	})

	return true
}

func (module *Module) BeforeCreate(scope *gorm.Scope) error {
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

func (module *Module) BeforeUpdate(scope *gorm.Scope) error {
	//scope.SetColumn("GmtModified", time.Now().Format("2006-01-02 15:04:05"))
	scope.SetColumn("GmtModified", time.Now())

	return nil
}
