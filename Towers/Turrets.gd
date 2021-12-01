extends Node2D

var type
var enemy_array = []
var built  = false
var enemy
var category
var ready = true
var detected_before = false

onready var turret = $Turret

func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]
		
func _physics_process(delta):
	if enemy_array.size() != 0 and built:
		detected_before = true
		select_enemy()
		if not get_node("AnimationPlayer").is_playing():
			turn()
		if ready:
			fire()
	else:
		enemy = null
	if enemy_array.size() == 0 and category == "Minigun" and detected_before:
		yield(get_tree().create_timer(1.0), "timeout")
		get_node("Turret").stop()
		detected_before = false
	
func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	


func fire():
	ready = false
	if category == "Projectile":
		fire_gun()
	elif category == "Missile":
		fire_missile()
	elif category == "Minigun":
		fire_minigun()
	enemy.on_hit(GameData.tower_data[type]['damage'])
	yield(get_tree().create_timer(GameData.tower_data[type]["rof"]), "timeout")
	ready = true

func fire_gun():
	get_node("AnimationPlayer").play("Fire")
	
func fire_missile():
	get_node("AnimationPlayer").play("Fire")

func fire_minigun():
	get_node("AnimationPlayer").play("Fire")
	get_node("Turret").play("default")

func turn():
	turret.look_at(enemy.position)


func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)


func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
