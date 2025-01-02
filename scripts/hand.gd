extends RigidBody2D
class_name Hand

@export var max_radius: float = 100.0
@export var move_speed: float = 2.5
@export var rotation_speed: float = 30.0
@export var max_angular_velocity: float = 15.0
@export var player: Character
@export var weapon: Weapon

@export var movement_behavior: Callable = follow_mouse

@onready var pinjoint1: PinJoint2D
@onready var pinjoint2: PinJoint2D


var in_area_of: Array[Node2D] = []


func _ready() -> void:
	angular_damp = 20.0
	linear_damp = 5.0
	if weapon != null:
		attach_weapon(weapon)


func attach_weapon(_weapon: Weapon) -> void:
	self.weapon = _weapon
	_weapon.player = player
	_weapon.global_position = global_position
	pinjoint1 = PinJoint2D.new()
	pinjoint2 = PinJoint2D.new()
	pinjoint1.global_position = global_position - Vector2(2, 0)
	pinjoint2.global_position = global_position + Vector2(2, 0)
	pinjoint1.node_a = self.get_path()
	pinjoint2.node_b = _weapon.get_path()
	pinjoint1.node_b = _weapon.get_path()
	pinjoint2.node_a = self.get_path()
	add_child(pinjoint1)
	add_child(pinjoint2)


func detach_weapon() -> void:
	remove_child(pinjoint1)
	remove_child(pinjoint2)
	self.weapon = null


func _physics_process(delta: float) -> void:
	movement_behavior.call(delta)
	clamp_position()

	if Input.is_action_just_pressed("move_weapon"):
		if weapon != null:
			detach_weapon()
		else:
			attach_weapon(in_area_of[len(in_area_of) - 1])

func set_movement_behavior(behavior: Callable) -> void:
	movement_behavior = behavior

func follow_mouse(_delta: float) -> void:
	var target_position = get_global_mouse_position()
	var to_target = (target_position - global_position).length()
	linear_velocity = (target_position - global_position).normalized() * to_target * move_speed / (weapon.mass if weapon else 1.0)

	var target_angle = (target_position - global_position).angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	angular_velocity = clamp(angle_diff * rotation_speed, -max_angular_velocity, max_angular_velocity)


func orbit_character(_delta: float) -> void:
	if player != null:
		var time = Time.get_ticks_msec() / 1000.0
		var angle = time * rotation_speed
		var offset = Vector2(cos(angle), sin(angle)) * max_radius
		angular_velocity = clamp(offset.angle() * rotation_speed, -max_angular_velocity, max_angular_velocity)


func clamp_position() -> void:
	if player != null:
		var to_player = player.global_position - global_position
		var distance = to_player.length()
		if distance > max_radius:
			var clamped_position = player.global_position - (to_player.normalized() * max_radius)
			global_position = clamped_position
