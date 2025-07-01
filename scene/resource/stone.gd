extends StaticBody2D

@onready var anim = $AnimatedSprite2D

var stone = preload("res://scene/collactables/stone_ore.tscn")

var health = 3

	
func _process(delta):
	if health == 3:
		anim.play("full")
	elif health == 2:
		anim.play("half_full")
	elif health == 1:
		anim.play("min_full")
	elif health <= 0:
		death()
		
func death():
	var stone_res = stone.instantiate()
	get_tree().current_scene.add_child(stone_res)
	stone_res.global_position = global_position
	queue_free()
		
func take_damage_ore():
	print(health)
	health -= Global.player_damage_pickax
