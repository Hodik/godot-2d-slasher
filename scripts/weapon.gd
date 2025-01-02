extends Interactable
class_name Weapon

@export var damage: float = 10.0
@export var player: CharacterBody2D
@export var disabled_velocity_threshold: float = 0.5


var disabled: bool


func _ready() -> void:
	super._ready()
	contact_monitor = true
	max_contacts_reported = 10
	$DamageArea.body_entered.connect(_on_dmg_body_entered)
	$DamageArea.body_exited.connect(_on_dmg_body_exited)

	if not player:
		disabled = true

		
func _physics_process(_delta: float) -> void:
	if player:
		return
		
	var total_velocity = linear_velocity.length() + abs(angular_velocity)
	if total_velocity < disabled_velocity_threshold:
		disabled = true
	else:
		disabled = false


func _on_dmg_body_entered(body: Node2D) -> void:
	if body is Character and body != player and not disabled:
		var impact_point = body.global_position - global_position
		var angular_impact = angular_velocity * impact_point.length()
		var total_velocity = linear_velocity + Vector2(angular_impact, angular_impact)
		body.take_damage(self, total_velocity)


func _on_dmg_body_exited(_body: Node2D) -> void:
	pass
