extends StaticBody2D

@export var stage = 0  # текущая стадия роста

@onready var grow_timer = $GrowTimer
@onready var anim = $AnimatedSprite2D

var carrot = preload("res://scene/collactables/carrot.tscn")

var can_grows = true

func _ready():
	anim.play(str(stage))
	grow_timer.timeout.connect(_on_grow_timer_timeout)

func _on_grow_timer_timeout():
	if stage < 4 and can_grows == true:
		stage += 1
		anim.play(str(stage))
		
func death():
	var carrot_res = carrot.instantiate()
	get_tree().current_scene.call_deferred("add_child", carrot_res)
	carrot_res.global_position = global_position
	can_grows = false
	stage = 0
	anim.play("0")

func _on_area_2d_area_entered(area):
	if area.name == "Hitbox" and anim.animation == "4":
		death()
	elif area.name == "HitboxWater" and anim.animation == "0":
		print("was water")
		can_grows = true
		grow_timer.start()
