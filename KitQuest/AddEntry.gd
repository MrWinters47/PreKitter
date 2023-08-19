extends Node2D

var inventroy_scene = preload("res://Inventory.tscn")


func load_data() -> void:
	var file = File.new()
	if file.file_exists("user://inventory.json"):
		file.open("user://inventory.json", File.READ)
		Database.inventory = parse_json(file.get_as_text())
		file.close()

func save_data() -> void:
	var file = File.new()
	file.open("user://inventory.json", File.WRITE)
	file.store_string(to_json(Database.inventory))
	file.close()

# Once the app is opened, this will load the dictionary inventroy dataw
func _ready():
	load_data()


# Checks if a string is a valid integer
func is_valid_integer(s: String) -> bool:
	return s.is_valid_integer()

# Validates input fields before adding to JSON dictionary.
func all_fields_filled() -> bool:
	# Checking that no fields are blank
	if $TimeJobTemp/Control/VBoxContainer/part_number.text == "" or $TimeJobTemp/Control/VBoxContainer/bin_location.text == "" or  $TimeJobTemp/Control/VBoxContainer/quantity.text == "" or  $TimeJobTemp/Control/VBoxContainer/description.text == "":
		return false
	
	# Checking that quantity is a valid integer
	if not $TimeJobTemp/Control/VBoxContainer/quantity.text.is_valid_integer():
		return false
	
	return true

# This function is called when the 'add' buttin is pressed
func _on_AddButton_pressed():
	# Before adding a new part, ensure all fields are filled out correctly
	if all_fields_filled():
		var part_number = $TimeJobTemp/Control/VBoxContainer/part_number.text
		var bin_location = $TimeJobTemp/Control/VBoxContainer/bin_location.text
		var quantity = int($TimeJobTemp/Control/VBoxContainer/quantity.text)
		var description = $TimeJobTemp/Control/VBoxContainer/description.text
		
		# Adding the new entry to the Database inventory
		Database.add_or_modify_part(part_number, bin_location, quantity, description)
		save_data()
		
		# Notify the user and reset the LineEdits
		$TimeJobTemp/Control/entry_info_label.text = "Entry added successfully!"
		reset_line_edits()
	else:
		# Notify the user about incorrect input
		$TimeJobTemp/Control/entry_info_label.text = "Please fill all fields with valid data!"

# After the user searches, this function will reset the lines so the user doesn't have to
func reset_line_edits():
	$TimeJobTemp/Control/VBoxContainer/part_number.clear()
	$TimeJobTemp/Control/VBoxContainer/bin_location.clear()
	$TimeJobTemp/Control/VBoxContainer/quantity.clear()
	$TimeJobTemp/Control/VBoxContainer/description.clear()

# This function will remove a part_number from the JSON dictionary Database.inventory
func _on_remove_entry_pressed():
	var part_number_to_remove = $TimeJobTemp/Control/VBoxContainer/part_number.text.strip_edges()
	
	# Check if the input is empty
	if part_number_to_remove == "":
		$TimeJobTemp/Control/entry_info_label.text = "Please enter a valid part number!"
		return

	# Convert the part number to lowercase (assuming your database stores keys in lowercase)
	part_number_to_remove = part_number_to_remove.to_lower()
	
	if Database.inventory.has(part_number_to_remove):
		Database.remove_part(part_number_to_remove)
		$TimeJobTemp/Control/VBoxContainer/part_number.clear()
		$TimeJobTemp/Control/entry_info_label.text = "Part removed successfully!"
		save_data()
		print("Entry removed; data saved!")
	else:
		$TimeJobTemp/Control/entry_info_label.text = "Part not found!"




# This function takes the button pressed and calls the "add" functionality
func _on_add_entry_pressed():
	_on_AddButton_pressed()  # Calling the same function when 'add_entry' is pressed.

# This function goes back when the user presses the 'back' button
func _on_back_button_pressed():
	get_tree().change_scene("res://Inventory.tscn")
