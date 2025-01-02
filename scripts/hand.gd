extends RigidBody2D
class_name Hand

@export var max_radius: float = 50.0
@export var move_speed: float = 5.0
@export var rotation_speed: float = 30.0
@export var rotation_smoothing: float = 10.0
@export var max_angular_velocity: float = 15.0
@export var player: Character
@export var weapon: Weapon

@export var movement_behavior: Callable = follow_mouse

func _ready() -> void:
	angular_damp = 20.0
	linear_damp = 5.0

func _physics_process(delta: float) -> void:
	movement_behavior.call(delta)
	clamp_position()

func set_movement_behavior(behavior: Callable) -> void:
	movement_behavior = behavior

func follow_mouse(_delta: float) -> void:
	var target_position = get_global_mouse_position()
	var to_target = (target_position - global_position).length()
	linear_velocity = (target_position - global_position).normalized() * to_target * move_speed / weapon.mass

	var target_angle = (target_position - global_position).angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	if Input.is_action_pressed("move_weapon"):
		angular_velocity = clamp(angle_diff * rotation_speed, -max_angular_velocity, max_angular_velocity)

	print(angular_velocity)
	print(linear_velocity.length())
	print(inertia)


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
