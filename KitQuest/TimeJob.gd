extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$BluePanel/Control/search_button.visible = false


func _on_minutes_text_entered(new_text):
	# Check if new_text is an integer
	if new_text.is_valid_integer():
		var total_minutes = int(new_text)
		
		var hours = total_minutes / 60
		var minutes = total_minutes % 60
		
		# Display the result
		$BluePanel/Control/results_label.text = "%d hours and %d minutes" % [hours, minutes]
		$BluePanel/Control/minutes.clear()
	else:
		$BluePanel/Control/results_label.text = "Please enter a valid number of minutes."



func _on_search_button_pressed():
	var entered_minutes = $BluePanel/Control/minutes.text
	_on_minutes_text_entered(entered_minutes)
	$BluePanel/Control/minutes.clear()


func _on_minutes_text_changed(new_text):
	if new_text.length() > 0:
		$BluePanel/Control/search_button.visible = true
	else:
		$BluePanel/Control/search_button.visible = false




func _on_back_button_pressed():
	get_tree().change_scene("res://MainScene.tscn")
