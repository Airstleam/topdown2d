extends Node

var active_item: InvItem = null
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
var player_is_dead = false
var player_damage_ax = 1
var player_damage_pickax = 1
var player_stone_ore = 0
var player_board = 0
var player_carrot = 0
var player_wheat = 0
var player_gold_ore = 0
var in_home = false
var is_open_some_inv = false
var is_using_inventory = false
var slime_count = 0
var slime_data = []

var animation_position = 0.0
var days_count = 1
var time_count

var end = false
var damage = false
var damage_to_display = 0
