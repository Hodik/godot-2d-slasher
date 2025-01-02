extends Node2D
class_name HealthBar

@onready var health_fill = $Fill


func _ready() -> void:
	z_index = 100


func _on_health_changed(current: float, maximum: float) -> void:
	if maximum == 0:
		return

	var percentage = current / maximum
	health_fill.scale.x = percentage
