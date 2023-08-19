extends Node2D


onready var edit_var = $Control/part_number_edit
onready var des_edit = $Control/des_edit

# Called when the node enters the scene tree for the first time.
func _ready():
	edit_var.text = str(Inventory.edit_des_var)
	des_edit.text = str(Inventory.edit_part_var)
