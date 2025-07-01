extends StaticBody2D

@onready var grow_timer = $GrowTimer
@onready var anim= $AnimatedSprite2D


var carrot = preload("res://scene/collactables/carrot.tscn")

@export var stage = 1  # текущая стадия роста

func _ready():
	anim.play(str(stage))
	grow_timer.timeout.connect(_on_grow_timer_timeout)

func _on_grow_timer_timeout():
	if stage < 4:
		stage += 1
		anim.play(str(stage))
	else:
		grow_timer.stop()
		
func death():
	var carrot_res = carrot.instantiate()
	get_tree().current_scene.call_deferred("add_child", carrot_res)
	carrot_res.global_position = global_position
	queue_free()

func _on_area_2d_area_entered(area):
	if area.name == "Hitbox" and anim.animation == "4":
		death()
