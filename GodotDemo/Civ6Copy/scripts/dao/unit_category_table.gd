class_name UnitCategoryTable
extends MySimSQL.Table


enum Category {
	GROUND_FORCE, # 地面部队
	SEA_FORCE, # 海上部队
	AIR_FORCE, # 空中部队
	ASSISTANT_FORCE, # 支援部队
	CITIZEN, # 平民
	TRADER, # 商人
	RELIGIOUS, # 宗教单位
}


func _init() -> void:
	for k in Category.keys():
		var do := UnitCategoryDO.new()
		do.name = k
		match Category[k]:
			Category.GROUND_FORCE:
				do.view_name = "地面部队"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Category.SEA_FORCE:
				do.view_name = "海上部队"
				do.icon = "res://assets/self_made_svg/unit_background/unit_sea_military_background.svg"
			Category.AIR_FORCE:
				do.view_name = "空中部队"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Category.ASSISTANT_FORCE:
				do.view_name = "支援部队"
				do.icon = "res://assets/self_made_svg/unit_background/unit_assistant_background.svg"
			Category.CITIZEN:
				do.view_name = "平民"
				do.icon = "res://assets/self_made_svg/unit_background/unit_citizen_background.svg"
			Category.TRADER:
				do.view_name = "商人"
				do.icon = "res://assets/self_made_svg/unit_background/unit_trader_background.svg"
			Category.RELIGIOUS:
				do.view_name = "宗教单位"
				do.icon = "res://assets/self_made_svg/unit_background/unit_religious_background.svg"
		insert(do)


func insert(d: DataObj) -> void:
	printerr("UnitCategoryTable is a enum table, can't insert")


func delete_by_id(id: int) -> void:
	printerr("UnitCategoryTable is a enum table, can't delete")
