extends StaticBody2D

@onready var grow_timer = $GrowTimer
@onready var anim = $AnimatedSprite2D


var wheat = preload("res://scene/collactables/wheat.tscn")

@export var stage = 0  # текущая стадия роста

var can_grows = false

func _ready():
	anim.play(str(stage))
	grow_timer.timeout.connect(_on_grow_timer_timeout)

func _on_grow_timer_timeout():
	if stage < 5 and can_grows == true:
		stage += 1
		anim.play(str(stage))
		
func death():
	var wheat_res = wheat.instantiate()
	get_tree().current_scene.call_deferred("add_child", wheat_res)
	wheat_res.global_position = global_position
	can_grows = false
	stage = 0
	anim.play("0")

func _on_area_2d_area_entered(area):
	if area.name == "Hitbox" and anim.animation == "5":
		death()
	elif area.name == "HitboxWater" and anim.animation == "0":
		anim.play("1")
		can_grows = true
		grow_timer.start()
