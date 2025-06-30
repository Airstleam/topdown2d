extends StaticBody2D

var stone = preload("res://scene/collactables/gold_ore.tscn")

var health = 3

	
func _process(delta):
	if health <= 0:
		death()
		
func death():
	var gold_res = stone.instantiate()
	get_tree().current_scene.add_child(gold_res)
	gold_res.global_position = global_position
	queue_free()
		
func take_damage_ore():
	print(health)
	health -= Global.player_damage_pickax
