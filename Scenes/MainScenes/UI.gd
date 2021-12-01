extends CanvasLayer

var start_wave_pressed = false
onready var hp_bar = get_node("HUD/InfoBar/H/Hp")
onready var hp_bar_tween = get_node("HUD/InfoBar/H/Hp/Tween")
onready var play = $HUD/GameControls/PausePlay
onready var pause_screen = $PauseScreen
var pause_screened = false
var game_paused_pressed = false



func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Towers/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	
	var range_texture = Sprite.new()
	range_texture.position = Vector2(32, 32)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Towers/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)
	
func update_tower_preview(new_position, color):
	get_node("TowerPreview").rect_position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate  = Color(color)
		get_node("TowerPreview/Sprite").modulate = Color(color)


func _unhandled_input(event):
		if event.is_action_released("pause"):
			if get_parent().build_mode:
				get_parent().cancel_build_mode()
			pause()


func _on_PausePlay_pressed():
	print("PRESSED ", start_wave_pressed)
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
		game_paused_pressed = false
		print("game is now paused?: ", game_paused_pressed)
	elif get_parent().current_wave == 0:
		start_wave_pressed = true
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	elif get_parent().current_wave >= 0 and start_wave_pressed == false:
		start_wave_pressed = true
		get_parent().current_wave += 1
		get_parent().start_next_wave()
	else:
		get_tree().paused = true
		game_paused_pressed = true
		print("game is now paused?: ", game_paused_pressed)
		


func _on_SpeedUp_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(2.0)


func update_health_bar(base_health):
	print("oof")
	hp_bar_tween.interpolate_property(hp_bar, 'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	if base_health >=60:
		hp_bar.set_tint_progress('3cc510')
	elif base_health <= 60 and base_health >= 25:
		hp_bar.set_tint_progress('e1be32')
	else:
		hp_bar.set_tint_progress('e11e1e')


func on_wave_end():
	play.set_pressed(false)
	start_wave_pressed = false


func pause():
	if !pause_screened:
		pause_screened = true
		pause_screen.visible = true
		if !game_paused_pressed:
			get_tree().paused = true
	else:
		pause_screened = false
		pause_screen.visible = false
		if !game_paused_pressed:
			get_tree().paused = false