extends Node


func _ready():
	load_main_menu()
	
func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	game_scene.connect("game_finished", self, 'unload_game')
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()


func unload_game(result):
	if result == "win" or result == "quit":
		get_node("GameScene").queue_free()
		var main_menu = load("res://UI/MainMenu.tscn").instance()
		add_child(main_menu)
		load_main_menu()
		Engine.set_time_scale(1.0)
	elif result == "lost":
		get_node("GameScene").queue_free()
		var game_over = load("res://UI/Game_over.tscn").instance()
		add_child(game_over)
		get_node("Game_over/M/VB/Back").connect("pressed", self, "on_back_pressed")
		Engine.set_time_scale(1.0)

func load_main_menu():
		get_node("MainMenu/M/VB/NewGame").connect("pressed", self, "on_new_game_pressed")
		get_node("MainMenu/M/VB/Quit").connect("pressed", self, "on_quit_pressed")


func on_back_pressed():
	get_node("Game_over").queue_free()
	var main_menu = load("res://UI/MainMenu.tscn").instance()
	add_child(main_menu)
	load_main_menu()
