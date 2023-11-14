class_name LandscapeDO
extends MySimSQL.EnumDO


# 视图层名字缩写
var short_name: String
# 粮食产量
var food: int = 0
# 生产力产量
var production: int = 0
# 金币产量
var gold: int = 0
# 防御力加成
var defence_bonus: int = 0
# 移动消耗
var move_cost: int = 0
# 对周围地块魅力值的影响
var charm_influence: int = 0
# 能否移动到此
var movable: bool = true

