extends Node
class_name Bubbles

signal spawned_new_bubble(new_bubble)

export (PackedScene) var Bubble

export var enable_on_start = false

export var bubbles_min_mass = 2
export var bubbles_max_mass = 6

var bubbles_group = "bubbles"

func _ready():
	randomize()
	if enable_on_start or get_tree().current_scene.name == name:
		enable()
	
func enable():
	$BubbleTimer.start()

func add_force(offset: Vector2, force: Vector2):
	utils_printf("add_force(%s,%s)", [offset, force])
	var bubbles = get_tree().get_nodes_in_group(bubbles_group)
	for bubble in bubbles:
		bubble.add_force(offset, force)

func apply_impulse(offset: Vector2, impulse: Vector2):
	utils_printf("apply_impulse(%s,%s)", [offset, impulse])
	var bubbles = get_tree().get_nodes_in_group(bubbles_group)
	for bubble in bubbles:
		bubble.apply_impulse(offset, impulse)

func _on_BubbleTimer_timeout():
	# new bubble
	var bubble = Bubble.instance()
	bubble.add_to_group(bubbles_group)
	add_child(bubble)
	
	# choose random spawn location
	$BubblePath/BubbleSpawnLocation.offset = randi()
	# choose random mass
	var size = rand_range(bubbles_min_mass, bubbles_max_mass)
	# scale bubble size according to mass
	var scale = sqrt(size/bubbles_min_mass)
	
	# set bubble properties
	bubble.position = $BubblePath/BubbleSpawnLocation.position
	bubble.mass = size
	bubble.set_scale(scale)
	
	bubble.enable()
	emit_signal("spawned_new_bubble", bubble)

func utils_printf(msg: String, vars: Array = []):
	var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
	var content = msg % vars
	print(prefix + content)
