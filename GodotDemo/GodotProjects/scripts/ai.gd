extends Node2D
class_name AI

signal state_changed(state: State)

enum State {
	PATROL,
	ENGAGE,
	ADVANCE,
}

@export var patrol_range: int = 200

@onready var patrol_timer: Timer = $PatrolTimer
@onready var detection_zone: Area2D = $DetectionZone

var state: State = -1:
	set = set_state
var actor: Actor = null
var target: CharacterBody2D = null

# 巡逻状态使用
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false

# 前进状态使用
var next_base_position: Vector2 = Vector2.ZERO


func _ready():
	set_state(State.PATROL)


func _physics_process(_delta):
	if actor.is_player():
		player_control_physics_process()
	else:
		ai_control_physics_process()


func player_control_physics_process():
	get_input()
	actor.move_and_slide()


func get_input():
	actor.look_at(get_global_mouse_position())
	actor.velocity = Input.get_vector("left", "right", "up", "down") * actor.speed


func _unhandled_input(event: InputEvent) -> void:
	if actor.is_player():
		if event.is_action_released("shoot"):
			actor.weapon.shoot()
		elif event.is_action_released("reload"):
			actor.weapon.reload()


func ai_control_physics_process():
	match state:
		State.PATROL:
			if not patrol_location_reached:
				# 4.1 中的 move_and_slide 不需要传参了，直接根据 velocity 移动
				actor.rotate_toward(patrol_location)
				actor.velocity_toward(patrol_location)
				actor.move_and_slide()
				if actor.has_reached_position(patrol_location):
					patrol_location_reached = true
					actor.velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target != null and actor.weapon != null:
				var angle_to_target = actor.rotate_toward(target.global_position)
#				print("sin: ", sin(0.5 * (actor.rotation - angle_to_target)))
				
				# lerp_angle 貌似会让 actor.rotation 超过上限 PI 和下限 -PI
				# 所以这里用 sin(0.5x) 替代 x 来实现原教程类似的效果
				# 使得目标进入一定角度时开枪
				if abs(sin(0.5 * (actor.rotation - angle_to_target))) < 0.08:
					actor.weapon.shoot()
			else:
				print("engaged, but no weapon/target found")
		State.ADVANCE:
			if actor.has_reached_position(next_base_position):
				set_state(State.PATROL)
			else:
				actor.velocity_toward(next_base_position)
				actor.rotate_toward(next_base_position)
				actor.move_and_slide()
		_:
			print("Error: a unexpected state")


func initialize(actor: Actor):
	self.actor = actor

	if not actor.is_player():
		# 如果是 AI，没子弹了立即换弹
		actor.weapon.weapon_out_of_ammo.connect(actor.weapon.start_reload)


func advance_to(target_base: CapturableBase):
	if actor.is_player():
		return
	next_base_position = target_base.global_position
	set_state(State.ADVANCE)


func set_state(new_state: State):
	if new_state == state:
		return

	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	elif new_state == State.ADVANCE:
		if actor.has_reached_position(next_base_position):
			set_state(State.PATROL)

	state = new_state
	state_changed.emit(new_state)


func _on_detection_zone_body_entered(body: Node):
	if actor.is_player():
		return
	if body.has_method("get_team_side") and body.get_team_side() != actor.team.side:
		set_state(State.ENGAGE)
		target = body


func _on_detection_zone_body_exited(body):
	if actor.is_player():
		return
	if target and body == target:
		set_state(State.ADVANCE)
		target = null


func _on_patrol_timer_timeout():
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
