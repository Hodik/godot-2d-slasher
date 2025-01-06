extends Character
class_name Player

@export var SPEED: float = 3.0
@export var DASH_SPEED: float = 20.0
@export var DASH_DURATION: float = 0.1
@export var DASH_COOLDOWN: float = 0.5

var movement_vector: Vector2 = Vector2.ZERO
var is_dashing: bool = false
var can_dash: bool = true


@onready var dash_timer: Timer
@onready var dash_cooldown_timer: Timer

func _ready() -> void:
	super._ready()

	# Setup dash timer
	dash_timer = Timer.new()
	dash_timer.one_shot = true
	dash_timer.wait_time = DASH_DURATION
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	add_child(dash_timer)

	# Setup cooldown timer
	dash_cooldown_timer = Timer.new()
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.wait_time = DASH_COOLDOWN
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timeout)
	add_child(dash_cooldown_timer)

func _process(delta: float) -> void:
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"

	$AnimatedSprite2D.flip_h = velocity.x < 0 if velocity.x != 0 else $AnimatedSprite2D.flip_h
	
	# Calculate movement vector but don't apply it here
	calculate_movement()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if movement_vector.length() > 0:
		velocity = movement_vector
		move_and_collide(velocity)
	else:
		velocity = Vector2.ZERO

func calculate_movement() -> void:

	if not is_dashing:
		movement_vector = Vector2.ZERO

		if Input.is_action_pressed("move_right"):
			movement_vector.x += 1
		if Input.is_action_pressed("move_left"):
			movement_vector.x -= 1
		if Input.is_action_pressed("move_up"):
			movement_vector.y -= 1
		if Input.is_action_pressed("move_down"):
			movement_vector.y += 1
		if Input.is_action_just_pressed("dash") and can_dash and movement_vector.length() > 0:
			start_dash()

	if movement_vector.length() > 0:
		movement_vector = movement_vector.normalized() * (DASH_SPEED if is_dashing else SPEED)


func start_dash() -> void:
	is_dashing = true
	can_dash = false
	dash_timer.start()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	dash_cooldown_timer.start()

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
