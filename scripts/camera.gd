extends Camera2D

@export var smoothing: float = 1.5
@onready var target: Node2D = get_node("../armed_player/Player")


func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.lerp(target.global_position, smoothing * delta)
