extends StaticBody2D

@onready var anim_icon = $Icon
@onready var carrotseed: InvItem = preload("res://scene/player/inventory/items/carrotseed.tres")
@onready var wheatseed: InvItem = preload("res://scene/player/inventory/items/wheatseed.tres")
@onready var player_inv: Inv = preload("res://scene/player/inventory/playerinv.tres")

var itemnum = 1

var item1price = 100
var item2price = 200


var price

func _ready():
	anim_icon.play("carrot")
	itemnum = 1
			

func _on_button_left_pressed():
	swap_item_back()
func _on_button_right_pressed():
	swap_item_forward()
func _on_buy_button_pressed():
	if itemnum == 1:
		price = item1price
		if Global.player_money >= price:
			buy()
	elif itemnum == 2:
		price = item2price
		if Global.player_money >= price:
			buy()

func swap_item_back():
	if itemnum == 1:
		itemnum = 2
		anim_icon.play("wheat")
	elif itemnum == 2:
		itemnum = 1
		anim_icon.play("carrot")
		
func swap_item_forward():
	if itemnum == 1:
		itemnum = 2
		anim_icon.play("wheat")
	elif itemnum == 2: #максимальное количествое предметов
		itemnum = 1
		anim_icon.play("carrot")
		
func buy():
	Global.player_money -= price
	if itemnum == 1:
		add_item_to_inventory(carrotseed)
	elif itemnum == 2:
		add_item_to_inventory(wheatseed)

func add_item_to_inventory(item: InvItem, amount: int = 1):
 # Сначала попробуем стакнуть
	for slot in player_inv.slots:
		if slot.item == item:
			slot.amount += amount
			return

 # Если нет стака — ищем пустой слот
	for slot in player_inv.slots:
		if slot.item == null:
			slot.item = item
			slot.amount = amount
			return
	
