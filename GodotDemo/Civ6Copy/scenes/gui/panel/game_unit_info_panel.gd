class_name GameUnitInfoPanel
extends PanelContainer


signal city_button_pressed
signal skip_button_pressed
signal sleep_button_pressed


var showing_unit: Unit = null:
	set(unit):
		if showing_unit != null:
			disconnect_showing_unit_signals()
		showing_unit = unit
		if unit == null:
			hide()
		else:
			show_info()


@onready var unit_texture_rect: TextureRect = $UnitInfoVBox/DetailHBox/UnitTextureRect
@onready var unit_city_button: Button = $UnitInfoVBox/ButtonHBox/CityButton
@onready var unit_name_label: Label = $UnitInfoVBox/DetailHBox/DetailVBox/NameLabel
@onready var unit_move_label: Label = $UnitInfoVBox/DetailHBox/DetailVBox/MoveLabel


func show_info() -> void:
	if showing_unit == null:
		printerr("GameUnitInfoPanel | show_info | weird, no showing unit, but show")
		return
	# 刷新内容
	var unit_do: UnitDO = UnitController.get_unit_do(showing_unit.id)
	unit_name_label.text = Unit.get_unit_name(unit_do.type)
	if unit_do.type == UnitTypeTable.Type.SETTLER:
		unit_city_button.show()
	else:
		unit_city_button.hide()
	
	unit_texture_rect.texture = load(Unit.get_unit_pic_200(unit_do.type))
	
	handle_unit_move_capability_changed(unit_do.move)
	# 绑定信号，方便后续更新信息
	connect_showing_unit_signals()
	# 显示出来
	show()


func disconnect_showing_unit_signals() -> void:
	if showing_unit.move_capability_changed.is_connected(handle_unit_move_capability_changed):
		showing_unit.move_capability_changed.disconnect(handle_unit_move_capability_changed)


func connect_showing_unit_signals() -> void:
	if not showing_unit.move_capability_changed.is_connected(handle_unit_move_capability_changed):
		showing_unit.move_capability_changed.connect(handle_unit_move_capability_changed)


func handle_unit_move_capability_changed(move_capability: int) -> void:
	unit_move_label.text = "%d/%d 移动" % [move_capability, UnitController.get_move_range(showing_unit.id)]


func handle_chosen_unit_changed(unit: Unit) -> void:
	showing_unit = unit


## 点击单位的建造城市按钮
func _on_city_button_pressed() -> void:
	city_button_pressed.emit()


## 点击单位的跳过按钮
func _on_skip_button_pressed() -> void:
	skip_button_pressed.emit()


## 点击单位的睡眠按钮
func _on_sleep_button_pressed() -> void:
	sleep_button_pressed.emit()
