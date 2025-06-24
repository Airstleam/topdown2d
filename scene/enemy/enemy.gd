extends CharacterBody2D
class_name Enemy

@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
@onready var hp_bar = $hp_bar
@onready var hp_animation = $Node2D/hp_animation
@onready var hp_damage = $Node2D/hp_damage

@export var speed = 50
@export var health = 100
@export var damage = 40

var player = null
var can_move = true
var death = false
var player_in = false
var show_damage = false
var coin = preload("res://scene/coin.tscn")


func _physics_process(delta):
	update_slime_data()
	hp_bar.value = health
	
	if show_damage == true:
		hp_damage.text = "-" + str(Global.damage_to_display)
		hp_damage.visible = true
		hp_bar.visible = true
		hp_animation.play("take_damage")
	if health <= 0:	
		if not death:
			death = true
			die()
		return
		
	if death:
		animP.stop()
	
	if !can_move:
		return
		
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		animP.play("Walk")
		anim.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		animP.play("Idle")
	move_and_slide()	

func update_slime_data():
	var found = false 
	for i in range(Global.slime_data.size()):
		if Global.slime_data[i].position.distance_to(position) < 10:
			Global.slime_data[i].health = health
			Global.slime_data[i].position = position
			found = true
			break
			
	if not found:
		Global.slime_data.append({
			"position": position,
			"health": health
		})

func die():
	Global.damage = false
	can_move = false
	hp_bar.visible = false
	health = 0
	remove_slime_data()
	animP.play("Dead")
	await animP.animation_finished
	queue_free()
	var money = coin.instantiate()
	get_tree().current_scene.add_child(money)
	money.global_position = global_position
	
func remove_slime_data():
	for i in range(Global.slime_data.size()):
		if Global.slime_data[i].position.distance_to(position) < 10:
			Global.slime_data.remove_at(i)
			break
			
func _on_detector_body_entered(body):
	if body.name == "player":
		player = body

func _on_detector_body_exited(body):
	if body.name == "player":
		player = null

func _on_hitbox_body_entered(body):
	if body.name == "player":
		Global.player_health -= damage

func _on_zone_body_entered(body):
	player_in = true
	attack()
	
func _on_zone_body_exited(body):
	if body.name == "player":
		player_in = false
	
func attack():
	while player_in:
		player_in = true
		can_move = false
		velocity = Vector2.ZERO	
		animP.play("Attack")
		await animP.animation_finished
	can_move = true
	Global.damage = false
	
func take_damage():
	health -= Global.player_damage
	show_damage = true
	await get_tree().create_timer(1).timeout
	show_damage = false
	if health <= 0:
		Global.slime_count -= 1
	
func shaking_true():
	Global.damage = true
	
func shaking_false():
	Global.damage = false
