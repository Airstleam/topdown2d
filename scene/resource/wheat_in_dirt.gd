extends StaticBody2D

@onready var grow_timer = $GrowTimer
@onready var anim = $AnimatedSprite2D


var wheat = preload("res://scene/collactables/wheat.tscn")

@export var stage = 0  # текущая стадия роста

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
	var wheat_res = wheat.instantiate()
	get_tree().current_scene.call_deferred("add_child", wheat_res)
	wheat_res.global_position = global_position
	queue_free()

func _on_area_2d_area_entered(area):
	if area.name == "Hitbox" and anim.animation == "4":
		death()
