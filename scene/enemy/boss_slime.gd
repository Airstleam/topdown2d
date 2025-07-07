extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
@onready var particle_for_death = $ParticleForDeath

@onready var fast_slime = preload("res://scene/enemy/fast_enemy.tscn")

@export var fireball = preload("res://scene/enemy/fire_ball.tscn")

@onready var timer_cooldown = $TimerCooldown

enum Phase {
	Phase_1,
	Phase_2,
}

var ability = 0
var can_use_ability = true
var current_phase = Phase.Phase_1
var can_teleport = false

@export var speed = 20
@export var health = 1000
@export var damage = 1

var can_move = true
var player_in = false
var death = false

func _physics_process(delta):
	
	if health <= 0 and death == false:	
		die()
		return
	
	if health <= 400 and current_phase != Phase.Phase_2:
		print("new_phase")
		check_phase()
	
	if !can_move:
		return
	else:
		run()
		
	move_and_slide()	

func run():
	var direction = Global.player_position - position
	velocity = direction.normalized() * speed
	
	if position.distance_to(Global.player_position) > 150 and can_teleport:
		can_teleport = false
		teleport_to_player()
		$TimerTeleport.start()
		return
		
	animP.play("move")
	anim.flip_h = direction.x < 0

func die():
	Global.damage = false
	can_move = false
	death = true
	health = 0
	animP.play("death")
	await animP.animation_finished
	await get_tree().create_timer(4).timeout
	print("You win")
	queue_free()
	
func check_phase():
	current_phase = Phase.Phase_2
	speed *= 1.2
	timer_cooldown.wait_time = 1.0
	scale *= 1.5
	$TimerTeleport.wait_time = 2.5

func _on_zone_body_entered(body):
	if body.name == "player":
		player_in = true
		
		if timer_cooldown.is_stopped():
			timer_cooldown.start()
		
func _on_zone_body_exited(body):
	if body.name == "player":
		player_in = false
		timer_cooldown.stop()
	
func attack():
	player_in = true
	can_move = false
	velocity = Vector2.ZERO	
	animP.play("attack")
	await animP.animation_finished
	can_move = true
	Global.damage = false
	
func take_damage():
	health -= Global.player_damage
	print(health)
	
func shaking_true():
	if Global.player_is_dead == false:
		Global.damage = true
	else:
		Global.damage = false
	
func shaking_false():
	Global.damage = false

func _on_hit_box_body_entered(body):
	if body.name == "player":
		Global.player_health -= damage

func summoning_slimes(num: int):
	for i in range(num):
		var fast_enemy = fast_slime.instantiate()
		get_tree().current_scene.call_deferred("add_child", fast_enemy)
		fast_enemy.global_position = global_position

func single_shot():
	var fireball_instance = fireball.instantiate()
	get_tree().current_scene.call_deferred("add_child", fireball_instance)
	fireball_instance.global_position = global_position
	fireball_instance.direction = (Global.player_position - global_position).normalized()
	fireball_instance.rotation = fireball_instance.direction.angle()
	
func burst_shot():
	for i in range(3):
		await get_tree().create_timer(0.1 * i).timeout
		single_shot()

func _on_timer_cooldown_timeout():
	if player_in:
		can_use_ability = true
		activate_ability()
		print("🕒 Способность готова снова")

func activate_ability():
	ability = randi_range(1, 3)
	print("🎯 Способность:", ability)
	match current_phase:
		Phase.Phase_1:
			match ability:
				1: attack()
				2: summoning_slimes(2)
				3: single_shot()
		Phase.Phase_2:
			match ability:
				1: attack()
				2: summoning_slimes(5)
				3: burst_shot()
	
	timer_cooldown.start()

func teleport_to_player():
	
	var tween := get_tree().create_tween()
	
	# 1. Уменьшаем (исчезновение)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)
	
	# 2. Телепорт
	tween.tween_callback(func():
		global_position = Global.player_position
	)
	
	# 3. Увеличение обратно
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

func _on_timer_teleport_timeout():
	can_teleport = true
