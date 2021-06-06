extends Node
class_name Bubbles

export (PackedScene) var Bubble

export var bubbles_min_mass = 2
export var bubbles_max_mass = 6

var bubbles_group = "bubbles"

func _ready():
	randomize()
	
	$BubbleTimer.connect("timeout", self, "_on_BubbleTimer_timeout")
	
	start_if_main()
	
func start_if_main():
	if get_tree().current_scene.name != name:
		return
	start()
	
func start():
	$BubbleTimer.start()

func add_force(force: Vector2, position: Vector2):
	var bubbles = get_tree().get_nodes_in_group(bubbles_group)
	for bubble in bubbles:
		bubble.add_force(force, position)

func apply_impulse(impulse: Vector2, position: Vector2):
	var bubbles = get_tree().get_nodes_in_group(bubbles_group)
	for bubble in bubbles:
		bubble.apply_impulse(position, impulse)

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
	
	bubble.start()
