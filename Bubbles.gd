extends Node
class_name Bubbles

signal spawned_new_bubble(new_bubble)

export (PackedScene) var Bubble

export var enable_on_start = false

export var gravity_scale = 9.8
export var linear_damp = -1
export var min_mass = 0
export var max_mass = 3

export var min_bubbles_spawned = 1
export var max_bubbles_spawned = 5

var group = "bubbles"

func _ready():
	randomize()
	if enable_on_start or get_tree().current_scene.name == name:
		enable()
	
func enable():
	$BubbleTimer.start()

func add_force(offset: Vector2, force: Vector2):
	utils_printf("add_force(%s,%s)", [offset, force])
	var bubbles = get_tree().get_nodes_in_group(group)
	for bubble in bubbles:
		bubble.add_force(offset, force)

func apply_impulse(offset: Vector2, impulse: Vector2):
	utils_printf("apply_impulse(%s,%s)", [offset, impulse])
	var bubbles = get_tree().get_nodes_in_group(group)
	for bubble in bubbles:
		bubble.apply_impulse(offset, impulse)

func _on_BubbleTimer_timeout():
	var n = rand_range(min_bubbles_spawned, max_bubbles_spawned)
	for i in range(n):
		spawn_bubble()

func spawn_bubble():
	# new bubble
	var bubble = Bubble.instance()
	bubble.add_to_group(group)
	add_child(bubble)
	
	# choose random spawn location
	$BubblePath/BubbleSpawnLocation.offset = randi()
	# choose random mass
	var size = rand_range(min_mass, max_mass)
	# scale bubble size according to mass
	var scale = sqrt(size/min_mass)
	
	# set bubble properties
	bubble.position = $BubblePath/BubbleSpawnLocation.position
	bubble.mass = size
	bubble.set_scale(scale)
	
	bubble.pseudo_gravity_scale = gravity_scale
	bubble.linear_damp = linear_damp
	
	bubble.enable()
	emit_signal("spawned_new_bubble", bubble)

func utils_printf(msg: String, vars: Array = []):
	var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
	var content = msg % vars
	print(prefix + content)
