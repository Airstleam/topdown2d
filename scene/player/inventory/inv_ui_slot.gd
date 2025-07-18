extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_desplay
@onready var amount_text: Label = $CenterContainer/Panel/Label

var slot_data: InvSlot
var is_from_player := true
var inv_ui: Node

func update_visual(slot: InvSlot):
	slot_data = slot
	if slot_data.item:
		item_visual.visible = true
		item_visual.texture = slot_data.item.texture
		item_visual.scale = Vector2(32, 32) / slot_data.item.texture.get_size()
		amount_text.text = str(slot_data.amount)
	else:
		item_visual.visible = false
		amount_text.visible = false


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if slot_data.item:
			Global.active_item = slot_data.item
			Global.is_using_inventory = true
			await get_tree().create_timer(0.01).timeout
			Global.is_using_inventory = false
