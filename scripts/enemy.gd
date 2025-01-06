extends Character

@export var SPEED: float = 3.0
@export var MIN_DISTANCE: float = 200.0
@export var DETECTION_RADIUS: float = 300.0

var tracking_player: Player

@onready var starting_position: Vector2 = global_position
@onready var detection_area: Area2D = $PlayerDetectionArea
@onready var hand: Hand = get_node("../hand")


func _ready() -> void:
    super._ready()
    detection_area.body_entered.connect(_on_player_detection_area_body_entered)
    detection_area.body_exited.connect(_on_player_detection_area_body_exited)
    health_changed.connect(_on_health_changed)
    died.connect(_on_died)
    hand.set_movement_behavior(hand.orbit_character)


func _on_health_changed(new_health: float, max_health: float) -> void:
    print("Enemy health: ", new_health, "/", max_health)

func _on_died() -> void:
    print("Enemy died!")

func _on_player_detection_area_body_entered(body: Node) -> void:
    if body is Player:
        tracking_player = body

func _on_player_detection_area_body_exited(body: Node) -> void:
    if body is Player:
        tracking_player = null

func _physics_process(delta: float) -> void:
    super._physics_process(delta)

    var target: Vector2 = target_position()
    if not is_dead:
        var to_target = (target - global_position)
        if not reached_target():
            velocity = to_target.normalized() * SPEED
            move_and_collide(velocity)
    else:
        velocity = Vector2.ZERO


func target_position() -> Vector2:
    return tracking_player.global_position if tracking_player != null and not tracking_player.is_dead else starting_position


func reached_target() -> bool:
    var distance: float = global_position.distance_to(target_position())
    if tracking_player != null and not tracking_player.is_dead:
        return distance < MIN_DISTANCE
    return distance < 10.0