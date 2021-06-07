extends Node
class_name Bubbles

signal spawned_new_bubble(new_bubble)

export (PackedScene) var Bubble

export var enable_on_start = false

export var gravity_scale: float
export var linear_damp: float
export var min_mass: float
export var max_mass: float

export var max_bubble_scale = sqrt(3) - 1

export var min_bubbles_spawned = 4
export var max_bubbles_spawned = 10

var bubbles_free_threshold = - 96

var group = "bubbles"

func _ready():
	randomize()
	if enable_on_start or get_tree().current_scene.name == name:
		enable()
	
func enable():
	$BubbleTimer.wait_time = 1.8  # avoid pops as spawn time
	$BubbleTimer.start()
	$CleanupTimer.start()

func add_force(offset: Vector2, force: Vector2):
	utils_printf("add_force(%s,%s)", [offset, force], 10)
	var bubbles = get_tree().get_nodes_in_group(group)
	for bubble in bubbles:
		bubble.add_force(offset, force)

func apply_impulse(offset: Vector2, impulse: Vector2):
	utils_printf("apply_impulse(%s,%s)", [offset, impulse], 10)
	var bubbles = get_tree().get_nodes_in_group(group)
	for bubble in bubbles:
		bubble.apply_impulse(offset, impulse)

func _on_BubbleTimer_timeout():
	var n = rand_range(min_bubbles_spawned, max_bubbles_spawned)
	for i in range(n):
		spawn_bubble()

func _on_CleanupTimer_timeout():
	var bubbles = get_tree().get_nodes_in_group(group)
	for bubble in bubbles:
		if bubble.position.y < bubbles_free_threshold:
			bubble.free_bubble()

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
	var scale = 1.0 + max_bubble_scale * (size - min_mass) / (max_mass - min_mass)
	
	# set bubble properties
	bubble.position = $BubblePath/BubbleSpawnLocation.position
	bubble.mass = size
	bubble.set_scale(scale)
	
	bubble.pseudo_gravity_scale = gravity_scale
	bubble.linear_damp = linear_damp
	
	bubble.enable()
	emit_signal("spawned_new_bubble", bubble)

export var utils_log_level = 20  # info

func utils_printf(msg: String, vars: Array = [], level: int = 0):
	if level >= utils_log_level:
		var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
		var content = msg % vars
		print(prefix + content)
