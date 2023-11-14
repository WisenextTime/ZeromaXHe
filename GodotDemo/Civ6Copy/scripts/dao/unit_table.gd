class_name UnitTable
extends MySimSQL.Table


var tile_id_index := MySimSQL.Index.new("tile_id", MySimSQL.Index.Type.NORMAL)
var player_id_index := MySimSQL.Index.new("player_id", MySimSQL.Index.Type.NORMAL)


func _init() -> void:
	elem_type = UnitDO
	create_index(tile_id_index)
	create_index(player_id_index)
