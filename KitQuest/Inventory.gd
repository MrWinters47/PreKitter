extends Node2D


var auto_hypen = false
var edit_button_showing = false


var edit_part_var
var edit_des_var

var e = preload("res://EditPartNumber.tscn")


func _ready():
	var job = "209-1696"
	var r = calculate_job_time(12.0, 60)
	print(r)
	# Load data when the node starts
	load_data()
	#$search_part.connect("text_changed", self, "_on_text_changed")
	#print(Database.inventory)


# Add or modify a part in the inventory
func add_or_modify_part(part_number: String, bin_location: String, quantity: int, description: String) -> void:
	Database.inventory[part_number] = {
		"bin-location": bin_location,
		"quantity": quantity,
		"description": description
	}
	save_data()


# Fetch details of a part
func get_part(part_number: String) -> Dictionary:
	return Database.inventory.get(part_number, {"error": "Part not found!"})

# Adjust the quantity of a part
func adjust_quantity(part_number: String, adjustment: int) -> void:
	if Database.inventory.has(part_number):
		Database.inventory[part_number]["quantity"] += adjustment
		save_data()

# Save the inventory data to a file
func save_data() -> void:
	var file = File.new()
	file.open("user://inventory.json", File.WRITE)
	file.store_string(to_json(Database.inventory))
	file.close()

# Load the inventory data from a file
func load_data() -> void:
	var file = File.new()
	if file.file_exists("user://inventory.json"):
		file.open("user://inventory.json", File.READ)
		Database.inventory = parse_json(file.get_as_text())
		file.close()


func _on_search_part_text_entered(new_text):
	var part_info = Database.inventory.get(new_text)
	var inv_quan = get_quantity(new_text)
	$search_part.clear()
	edit_des_var = Database.inventory[new_text]["description"]
	if part_info:
		$SubPanel/Control/edit_button.visible = true
		quantity_check(Database.inventory[new_text]["quantity"])
		if inv_quan >= 1:
			print("IN STOCK")
			#$GreyPanelMain/Control/GreenTick.visible = true  # Show green tick
			#$GreyPanelMain/Control/RedTick.visible = false   # Hide red tick
		else:
			print("OUT OF STOCK")
			#$GreyPanelMain/Control/GreenTick.visible = false # Hide green tick
			#$GreyPanelMain/Control/RedTick.visible = true    # Show red tick
		print(part_info["description"])
		update_part_info(new_text, part_info)
	else:
		$SubPanel/Control/edit_button.visible = false
		print("PART NOT FOUND")
		#$GreyPanelMain/Control/GreenTick.visible = false # Hide green tick
		#$GreyPanelMain/Control/RedTick.visible = false    # Hide red tick
		$SubPanel/Control/show_part_label_new.text = str(new_text, " is not found!")



func update_part_info(part_number: String, part_info: Dictionary):
	$SubPanel/Control/VBoxContainer/pn_label.text = "Part Number: " + part_number
	$SubPanel/Control/VBoxContainer/des_label.text = "Description: " + part_info["description"]
	$SubPanel/Control/VBoxContainer/quan_label.text = "Bin Location: " + part_info["bin-location"]
	#$SubPanel/Control/VBoxContainer/quan_label2.text = "Steel-Type: " + part_info["steel-type"]

	var quantity_text = "Quantity: " + str(part_info["quantity"])
	if part_info["quantity"] < 10:
		quantity_text = "[color=red]" + quantity_text + "[/color]"  # BBCode to color the text red
	$SubPanel/Control/show_part_label_new.bbcode_text = quantity_text


var prev_text_length = 0
func _on_text_changed(new_text):
	if auto_hypen == true:
		if new_text.length() == 3 and new_text[-1] != "-" and prev_text_length < new_text.length():
			$search_part.text = new_text + "-"
			$search_part.caret_position = $search_part.text.length()
		prev_text_length = new_text.length()


var prev_text_length_3 = 0
func _on_text_changed_3(new_text):
	if auto_hypen == true:
		if new_text.length() == 3 and new_text[-1] != "-" and prev_text_length_3 < new_text.length():
			$search_part.text = new_text + "-"
			$search_part.caret_position = $search_part.text.length()
		prev_text_length_3 = new_text.length()



func get_quantity(part_number: String) -> int:
	if Database.inventory.has(part_number):
		return Database.inventory[part_number]["quantity"]
	return -1  # Return -1 (or another sentinel value) if part_number doesn't exist



func _on_back_button_pressed():
	get_tree().change_scene("res://MainScene.tscn")


func _on_auto_hypen_toggled(button_pressed):
	if button_pressed == true:
		$AutoHypenIconOn.visible = true
		$AutoHypenIconOff.visible = false
		auto_hypen = true
	elif button_pressed == false:
		$AutoHypenIconOn.visible = false
		$AutoHypenIconOff.visible = true
		auto_hypen = false


# This function checks the quantity
func quantity_check(part_quantity: int) -> void:
	if part_quantity >= 85:
		print("Fully in stock")
	elif part_quantity >= 50:
		print("In stock")
	elif part_quantity >= 25:
		print("Quantity low")
	elif part_quantity >= 10:
		print("Quantity very low")
	else:
		print("Out of stock")

# This code is used to calculate a job time
func calculate_job_time(job_time: float, job_quantity: int) -> String:
	var total_minutes = job_time * job_quantity
	var hours = int(total_minutes) / 60  # Integer division to get whole hours
	var minutes = int(total_minutes) % 60  # Modulus to get remaining minutes

	return "%d hour(s) %d min(s)" % [hours, minutes]



func _on_edit_button_pressed():
	get_tree().change_scene("res://EditPartNumber.tscn")
