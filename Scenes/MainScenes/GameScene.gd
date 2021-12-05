extends Node2D

signal game_finished(result)

var map_node
onready var PauseScreen = $UI/PauseScreen
onready var spawn_timer = $Timer
onready var UI = $UI
onready var money_node = $UI/HUD/InfoBar/H/Money

var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type
var map
var current_wave = 0
var enemies_in_wave = 0

var base_health = 100
var enemy_health = 100
var money_count = 152

func _ready():
	money_node.text = str(money_count)
	map_node = load("res://Maps/"+map+".tscn").instance()
	add_child(map_node)
	PauseScreen.connect("pause_button", self, 'on_pause_button_pressed')
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
		
	
func _process(delta):
	if build_mode:
		update_tower_preview()
	
func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()
		
		
		
		
		
		

func on_pause_button_pressed(action):
	if action == "quit":
		get_tree().paused = false
		emit_signal("game_finished", "quit")
	elif action == "settings":
		pass
	else:
		get_tree().paused = false	
		UI.pause_screened = false
		PauseScreen.visible = false
		

func start_next_wave():
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2), "timeout")
	if wave_data:
		spawn_enemies(wave_data)


func retrieve_wave_data():
	var wave_data = []
	if current_wave in GameData.wave_data:
		for i in GameData.wave_data[current_wave]["blue"]:
			wave_data.append(["BlueTank", 0.7, GameData.wave_data[current_wave]["path"], GameData.wave_data[current_wave]["enemy"]])
		enemies_in_wave = wave_data.size()
		return wave_data
	else:
		emit_signal("game_finished", "win")
	
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Enemy/" + i[0] + '.tscn').instance()
		new_enemy.enemy = i[3]
		new_enemy.connect("base_damage", self, 'on_base_damage')
		new_enemy.connect("enemy_base_damage", self, 'on_base_damage')
		new_enemy.connect("tank_destroyed", self, "tank_destroyed")
		randomize()
		if (i[2] == 1):
			map_node.get_node("Path").add_child(new_enemy, true)
		elif (i[2] == 2):
			map_node.get_node("Path2").add_child(new_enemy, true)
		elif (i[2] == 0):
			if(rand_range(1, 2) >= 1.5):
				map_node.get_node("Path").add_child(new_enemy, true)
			else:
				map_node.get_node("Path2").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1], false), "timeout")


func tank_destroyed():
	enemies_in_wave -= 1
	money_update(+1)
	print(enemies_in_wave)
	if enemies_in_wave == 0:
		wave_end()

func wave_end():
	get_node("UI").on_wave_end()
	print("Wave end " , current_wave)
	if !(current_wave+1 in GameData.wave_data):
		emit_signal("game_finished", "win")

	
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	if GameData.tower_data[tower_type + "T1"]["price"] <= money_count:
		build_type = tower_type + "T1"
		build_mode = true
		get_node("UI").set_tower_preview(build_type, get_global_mouse_position())
	
func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").world_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_world(current_tile)
	
	if map_node.get_node("TowerExclusion").get_cellv(current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position, "adff4545")
		build_valid = false
		
	
func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()
	
func verify_and_build():
	if build_valid:
		money_update(-(GameData.tower_data[build_type]["price"]))
		var new_tower = load("res://Towers/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]["category"]
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cellv(build_tile, 5)

func on_base_damage(damage, enemy_status):
	print("ENEMY STATUS ", enemy_status)
	if enemy_status:
		base_health -= damage
		if base_health <= 0:
			emit_signal("game_finished", "lost")
		else:
			get_node("UI").update_health_bar(base_health, true)
	else:
		enemy_health -= damage
		if enemy_health <= 0:
			emit_signal("game_finished", "win")
		else:
			get_node("UI").update_health_bar(enemy_health, false)



func money_update(value):
	money_count += value
	money_node.text = str(money_count)
