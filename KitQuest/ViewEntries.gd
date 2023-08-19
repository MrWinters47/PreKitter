extends Node2D

# Assuming you've set up your scene with a ScrollContainer -> VBoxContainer hierarchy.
onready var entry_container = $"Bg-temp/Control/ScrollContainer/VBoxContainer"
var entry_template = preload("EntryLabel.tscn")

func _ready():
	pass

func display_entries():
	# Clear existing entries first
	for child in entry_container.get_children():
		child.queue_free()

	for part_number in Database.inventory.keys():
		var part_details = Database.inventory[part_number]

		var description = part_details["description"]
		var bin_location = part_details["bin-location"]
		var quantity = part_details["quantity"]
		var entry_date = "N/A"  # Default value
		if part_details.has("entry_date"):
			entry_date = part_details["entry_date"]

		
		# Formatting the entry string
		var entry_string = "Part Number: %s\nDescription: %s\nBin Location: %s\nQuantity: %d\nEntry Date: %s" % [part_number, description, bin_location, quantity, entry_date]

		# Create an instance of the entry label and set its text
		var entry_label = entry_template.instance()
		entry_label.text = entry_string
		entry_container.add_child(entry_label)

		# Optional: Adjust properties for better appearance
		entry_label.rect_min_size = Vector2(500, 0)  # Set a minimum width for consistency


func _on_ViewEntries_Button_pressed():
	display_entries()
