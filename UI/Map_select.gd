extends Control


signal pick_map(map)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Map1_pressed():
	emit_signal("pick_map", "Map1")


func _on_Map2_pressed():
	emit_signal("pick_map", "Map2")


func _on_Map3_pressed():
	emit_signal("pick_map", "Map3")
