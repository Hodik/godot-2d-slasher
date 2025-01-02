extends RigidBody2D
class_name Weapon

@export var damage: float = 10.0
@export var player: CharacterBody2D


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	$DamageArea.body_entered.connect(_on_body_entered)
	$DamageArea.body_exited.connect(_on_body_exited)
	print(get_parent().name)
	player = get_parent().player


func _on_body_entered(body: Node2D) -> void:
	if body is Character and body != player:
		var impact_point = body.global_position - global_position
		var angular_impact = angular_velocity * impact_point.length()
		var total_velocity = linear_velocity + Vector2(angular_impact, angular_impact)
		body.take_damage(self, total_velocity)


func _on_body_exited(body: Node2D) -> void:
	pass
