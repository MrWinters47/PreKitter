extends Node

# Save Function
func save_data() -> void:
	var file = File.new()
	file.open("user://inventory.json", File.WRITE)
	file.store_string(to_json(Database.inventory))
	file.close()
	
	
# Dictionary containing parts and other details associated with each job
var job_data: Dictionary = {
	"209_1696": {
		"description": "LHZ Chassis",
		"quantity": 10,  # The quantity required for the job
		"parts": ["102-3847", "105-2678"],  # The part numbers required for the job
		"job_time": 1.9
	},
	"210_1700": {
		"description": "Another Product",
		"quantity": 15,  
		"parts": ["101-2047"],
		"job_time": 2.5
	},
}

# Main inventory database for parts
var inventory: Dictionary = {
	"102-3847": {
		"description": "Centre Plate",
		"quantity": 5,  # The quantity of the part available in inventory
		"bin-location": "MSR01B02",
		"steel-type": "Mild-Steel",
		"store-bought": false
	},
	"105-2678": {
		"description": "Lock Assy",
		"quantity": 20,
		"bin-location": "MSR02B03",
		"steel-type": "Mild-Steel",  # Assuming this as an example, you can change it
		"store-bought": true  # Assuming this as an example, you can change it
	},
	"101-2047": {
		"description": "Main Asssy!!",
		"quantity": 2,
		"bin-location": "MSRO1A01",
		"steel-type": "Aluminium",  # Assuming this as an example, you can change it
		"store-bought": false  # Assuming this as an example, you can change it
	}
}



var job_codes: Dictionary = {
	"101-1023": {
		"job_time": 1.9
	}
}

func remove_part(part_number: String) -> void:
	if inventory.has(part_number):
		inventory.erase(part_number)
		save_data()  # Assuming you have a save_data function.



func add_or_modify_part(part_number: String, bin_location: String, quantity: int, description: String) -> void:
	var current_datetime = OS.get_datetime()
	var formatted_datetime = "%s-%s-%s %s:%s:%s" % [current_datetime["year"], current_datetime["month"], current_datetime["day"], current_datetime["hour"], current_datetime["minute"], current_datetime["second"]]
	
	Database.inventory[part_number] = {
		"bin-location": bin_location,
		"quantity": quantity,
		"description": description,
		"entry_date": formatted_datetime
	}
	save_data()


func get_all_entries() -> Array:
	return Database.inventory.values()


func get_part_details(part_number: String) -> Dictionary:
	return Database.inventory.get(part_number, {"error": "Part not found!"})


