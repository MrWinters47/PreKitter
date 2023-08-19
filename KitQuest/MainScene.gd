extends Node2D

var logo = preload("res://UIOverlay.tscn")


func _on_Inventory_Button_pressed():
	get_tree().change_scene("res://Inventory.tscn")

func _on_timejob_Button_pressed():
	get_tree().change_scene("res://TimeJob.tscn")


func _ready():
	var l = logo.instance()
	add_child(l)


func _on_addEntry_Button_pressed():
	get_tree().change_scene("res://AddEntry.tscn")
