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
func AddModule(name string, englishName string, description string, englishDescription string, icon string, cover string, newFeatureDeadline int, landingPageUrl string, status int, sort int) bool {
	db.Create(&Module{
		Name:               name,
		EnglishName:        englishName,
		Description:        description,
		EnglishDescription: englishDescription,
		Icon:               icon,
		Cover:              cover,
		NewFeatureDeadline: newFeatureDeadline,
		LandingPageUrl:     landingPageUrl,
		Status:             status,
		Sort:               sort,
	})

	return true
}

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

func DeleteModule(uuid string) bool {
	db.Where("uuid = ?", uuid).Delete(&Module{})
	return true
}

func GetModules(pageNum int, pageSize int, maps interface{}) (modules []Module) {
	db.Where(maps).Offset(pageNum).Limit(pageSize).Find(&modules)

	return
}

func GetModuleTotal(maps interface{}) (count int) {
	db.Model(&Module{}).Where(maps).Count(&count)

	return
}