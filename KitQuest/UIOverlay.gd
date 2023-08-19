extends CanvasLayer



func _ready():
	yield(get_tree().create_timer(1.5), "timeout")
	$logo_enter_anim.play("SHOW")
