extends Node2D

@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days

@onready var boss = preload("res://scene/enemy/boss_slime.tscn")

var last_position = 0
var house = false
var slime_preload = preload("res://scene/enemy/enemy.tscn")
var rain = preload("res://scene/rain.tscn")
var raining = false

func _ready():
	load_slime()
	animP.play("day-night")
	animP.seek(Global.animation_position)
	last_position = Global.animation_position
	if raining == false:
		$Music/MusicCommonDay.play()

func _process(delta):
	
	if Global.end:
		get_tree().change_scene_to_file("res://scene/other scn/death_scene.tscn")
		Global.player_position = Vector2(997.0, 571.0)
		return
	
	else:
		animP.play("day-night")
		
		if animP.current_animation_position < last_position:
			Global.days_count += 1
			
		last_position = animP.current_animation_position
		
		Global.animation_position = animP.current_animation_position
		
		days.text = str(Global.days_count) + " DAY"
	
	if house and Input.is_action_just_pressed("E"):
		house = false
		$Area2D/TextHome/AudioStreamPlayer.play()
		$Area2D/TextHome/AudioStreamPlayer/TimerOpen.start()
		await $Area2D/TextHome/AudioStreamPlayer/TimerOpen.timeout
		house = true
		get_tree().change_scene_to_file("res://scene/other scn/house.tscn")
		Global.player_position = Vector2(176.0, 80.0)
	
	if Global.days_count == 5:
		boss_day()
	elif Global.days_count == 3:
		rain_event()
	
func slime_spawn():
	var max_slimes = 5 * Global.days_count
	
	if Global.slime_count >= max_slimes:
		return
	
	var spawn_amount = min(max_slimes - Global.slime_count, 5)
	
	for i in range(spawn_amount):
		var slime = slime_preload.instantiate()
		slime.position = Vector2(randf_range(0, 1100), randf_range(600, 50))
		$Enemies.add_child(slime)
		Global.slime_count += 1
		
		Global.slime_data.append({
			"position": slime.position,
			"health": 100
		})
		
func load_slime():
	for slime_info in Global.slime_data:
		var slime = slime_preload.instantiate()
		slime.position = slime_info.position
		slime.health = slime_info.health
		$Enemies.add_child(slime)
		print("slime at:", slime.position, "health:", slime.health)


func _on_area_2d_body_entered(body):
	if body.name == "player":
		$Area2D/TextHome.visible = true
		house = true


func _on_area_2d_body_exited(body):
	if body.name == "player":
		$Area2D/TextHome.visible = false
		house = false

func rain_event():
	raining = true
	$Music/RainMusic.play()
	var rain_event = rain.instantiate()
	get_tree().current_scene.add_child(rain_event)
	rain_event.global_position = Vector2.ZERO

func boss_day():
	var boss_instance = boss.instantiate()
	get_tree().current_scene.call_deferred("add_child", boss_instance)
	boss_instance.global_position = Vector2(1094.0, 261.0)
