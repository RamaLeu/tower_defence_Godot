extends PathFollow2D

signal base_damage(damage)
signal enemy_base_damage(damage)
signal tank_destroyed()


var speed = 150
var hp = 50
var base_damage = 21
var damage_taken = []
var deathSwitch = false
var enemy = false

onready var health_bar = $Health
onready var impact_area = get_node("Impact")
var projectile_impact = preload("res://Enemy/explosions/ProjectileImpact.tscn")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)

func _physics_process(delta):
	if unit_offset >= 0.99:
		emit_signal("base_damage", base_damage, enemy)
		queue_free()
		die_in_wave()
	move(delta)
	
func move(delta):
	set_offset(get_offset() + speed * delta)
	health_bar.set_position(position - Vector2(30, 30))


func die_in_wave():
	emit_signal("tank_destroyed")

func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if !deathSwitch:
		if hp <=0:
			deathSwitch = true
			print("I am destroyed")
			on_destroy()

func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instance()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)
	

func on_destroy():
	get_node("KinematicBody2D").queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	self.queue_free()
	die_in_wave()

