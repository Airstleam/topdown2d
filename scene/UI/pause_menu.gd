extends Control


func _on_resume_pressed():
	Global.resume = true


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scene/other scn/menu.tscn")


func _on_save_pressed():
	Global.save = true

func _on_load_pressed():
	Global.load = true
