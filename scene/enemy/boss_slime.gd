extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
@onready var particle_for_death = $ParticleForDeath

@onready var fast_slime = preload("res://scene/enemy/fast_enemy.tscn")

@export var fireball = preload("res://scene/enemy/fire_ball.tscn")

@onready var timer_cooldown = $TimerCooldown

var ability = 0
var can_use_ability = true

var speed = 20
var health = 100
var damage = 1

var can_move = true
var player_in = false

func _physics_process(delta):
	
	if health <= 0:	
		die()
		return
	
	if !can_move:
		return
	else:
		var direction = (Global.player_position - position).normalized()
		velocity = direction * speed
		animP.play("move")
		anim.flip_h = direction.x < 0
		
	move_and_slide()	

func die():
	Global.damage = false
	can_move = false
	health = 0
	animP.play("death")
	await animP.animation_finished
	await get_tree().create_timer(4).timeout
	print("You win")
	queue_free()
	
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
	while player_in:
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
	await get_tree().create_timer(1).timeout
	if health <= 0:
		Global.slime_count -= 1
	
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

func summoning_slimes():
	var fast_enemy = fast_slime.instantiate()
	get_tree().current_scene.call_deferred("add_child", fast_enemy)
	fast_enemy.global_position = global_position

func fireball_ability():
	var fireball_instance = fireball.instantiate()
	get_tree().current_scene.call_deferred("add_child", fireball_instance)
	fireball_instance.global_position = global_position
	fireball_instance.direction = (Global.player_position - global_position).normalized()
	fireball_instance.rotation = fireball_instance.direction.angle()
	

func _on_timer_cooldown_timeout():
	if player_in:
		can_use_ability = true
		activate_ability()
		print("🕒 Способность готова снова")

func activate_ability():
	ability = randi_range(1, 4)
	print("🎯 Способность:", ability)

	match ability:
		1: attack()
		2: summoning_slimes()
		3: fireball_ability()
		4: pass

	timer_cooldown.start()
