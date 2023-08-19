extends Node2D




var job_orders: Dictionary = {
	"173-2648": {
		"description": "SPINE CONNECTION PLATE S2",
		"quantity": 4,
		"part_numbers": {
			"173-1123": 1,  # The required quantity of this part for one unit of the job order
			"173-2106": 2   # Let's say you need 2 of this part for one unit of the job order
		}
	}
	# ... Add other job orders as needed
}

# Inventory database for parts (provided for the sake of completeness)
var parts_inventory: Dictionary = {
	"173-1123": {
		"description": "Some Part A",
		"quantity": 50,
		"bin-location": "MSR01B02"
	},
	"173-2106": {
		"description": "Some Part B",
		"quantity": 100,
		"bin-location": "MSR01B03"
	}
	# ... Add other parts as needed
}

func is_job_order_completable(job_order_code: String) -> bool:
	var job = job_orders[job_order_code]
	if job == null:
		return false  # Job order code not found

	for part_code in job["part_numbers"].keys():
		if !parts_inventory.has(part_code) or parts_inventory[part_code]["quantity"] < job["quantity"] * job["part_numbers"][part_code]:
			return false  # Not enough quantity in inventory

	return true  # All parts are available in required quantities

# Example of how to use:
# print(is_job_order_completable("173-2648"))  # This will print 'true' if the job order can be completed with the current parts inventory.

