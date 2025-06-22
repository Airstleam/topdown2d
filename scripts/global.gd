extends Node

var player_health = 100
var max_health = 100
var player_money = 100
var player_damage = 20
var player_position = Vector2(368.0, 308.0)
var player_stamina = 100
var max_stamina = 100
var resume = false
var save = false
var load = false

var slime_count = 0
var slime_data = []

var animation_position = 0.0
var days_count = 1
var time_count

var end = false
var damage = false
var damage_to_display = 0
