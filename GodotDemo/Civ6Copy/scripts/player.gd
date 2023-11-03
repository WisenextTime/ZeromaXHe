class_name Player


var p_name: String = "默认玩家名"
var main_color: Color = Color.BLACK
var second_color: Color = Color.WHITE
var map_sight_info: MapSightInfo = MapSightInfo.new()
var units: Array[Unit] = []


func get_next_movable_unit(unit: Unit) -> Unit:
	var idx = units.find(unit)
	if idx == -1:
		printerr("get_next_movable_unit | unit unfound in units")
		return null
	var i = (idx + 1) % units.size()
	while i != idx:
		if units[i].move_capability > 0:
			return units[i]
		i = (i + 1) % units.size()
	return null


func refresh_units_move_capabilities() -> void:
	for unit in units:
		unit.move_capability = unit.get_move_range()


class MapSightInfo:
	var sight_type_arr2d: Array = []
	var seen_dict: Dictionary = {}
	var unseen_dict: Dictionary = {}
	var in_sight_dict: Dictionary = {}
	
	
	func initialize(size: Vector2i) -> void:
		for i in range(size.x):
			sight_type_arr2d.append([])
			for j in range(size.y):
				sight_type_arr2d[i].append(Map.SightType.UNSEEN)
				unseen_dict[Vector2i(i, j)] = 1
	
	
	func get_in_sight_cells() -> Array[Vector2i]:
		var cells: Array[Vector2i] = []
		cells.append_array(in_sight_dict.keys())
		return cells
	
	
	func in_sight(coord: Vector2i) -> void:
		match sight_type_arr2d[coord.x][coord.y]:
			Map.SightType.SEEN:
				seen_dict.erase(coord)
			Map.SightType.UNSEEN:
				unseen_dict.erase(coord)
			Map.SightType.IN_SIGHT:
				in_sight_dict[coord] += 1
				return
		sight_type_arr2d[coord.x][coord.y] = Map.SightType.IN_SIGHT
		in_sight_dict[coord] = 1
	
	
	func out_sight(coord: Vector2i) -> void:
		if sight_type_arr2d[coord.x][coord.y] != Map.SightType.IN_SIGHT:
			return
		if in_sight_dict[coord] > 1:
			in_sight_dict[coord] -= 1
			return
		sight_type_arr2d[coord.x][coord.y] = Map.SightType.SEEN
		in_sight_dict.erase(coord)
		seen_dict[coord] = 1

