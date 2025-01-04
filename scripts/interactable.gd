extends RigidBody2D
class_name Interactable


@onready var interactable_area: Area2D = $InteractableArea


func _ready() -> void:
	if not interactable_area:
		push_error("Interactable area not found")
		return
	interactable_area.body_entered.connect(_on_body_entered)
	interactable_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is Hand:
		body.in_area_of.append(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Hand:
		body.in_area_of.erase(self)
