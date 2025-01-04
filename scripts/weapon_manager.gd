extends Node

signal weapon_picked_up(weapon: Weapon, by: Hand)
signal weapon_dropped(weapon: Weapon, from: Hand)

func pick_up_weapon(weapon: Weapon, hand: Hand) -> void:
	var current_parent = weapon.get_parent()
	current_parent.remove_child(weapon)
	weapon.global_position = Vector2.ZERO
	weapon.rotation = 0.0
	hand.add_child(weapon)
	weapon.attach(hand.player)
	weapon_picked_up.emit(weapon, hand)

func drop_weapon(weapon: Weapon, hand: Hand) -> void:
	var game_scene = get_tree().get_first_node_in_group("game") if get_tree().get_first_node_in_group("game") else get_tree().root
	hand.remove_child(weapon)
	game_scene.add_child(weapon)
	weapon.fly()
	weapon_dropped.emit(weapon, hand)
