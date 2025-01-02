extends CharacterBody2D
class_name Character

signal health_changed(new_health: float, max_health: float)
signal died()
signal healing_started()
signal healing_finished()


@export var max_health: float = 100.0

var current_health: float
var is_dead: bool = false

@onready var health_bar: HealthBar = $HealthBar
@onready var armed_character: Node2D = get_parent()

func _ready() -> void:
	current_health = max_health
	if health_bar != null:
		health_changed.connect(health_bar._on_health_changed)
		health_changed.emit(current_health, max_health)


func take_damage(weapon: Weapon, weapon_velocity: Vector2) -> void:
	if is_dead:
		return

	var impact_force = weapon_velocity.length() * weapon.mass
	var total_damage = weapon.damage * (impact_force / 1000.0)

	current_health = max(0, current_health - total_damage)
	health_changed.emit(current_health, max_health)

	if current_health == 0:
		die()


func die() -> void:
	print("dying: ", self)
	is_dead = true
	died.emit()


func heal(amount: float) -> void:
	if is_dead:
		return

	healing_started.emit()
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)
	healing_finished.emit()
