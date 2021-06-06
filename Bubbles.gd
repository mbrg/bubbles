extends Node
class_name Bubbles

export (PackedScene) var Bubble

export var bubbles_min_mass = 2
export var bubbles_max_mass = 6

var bubbles_group = "bubbles"

func _ready():
	randomize()
	
	$BubbleTimer.connect("timeout", self, "_on_BubbleTimer_timeout")
	
	enable_if_main()
	
func enable_if_main():
	if get_tree().current_scene.name != name:
		return
	enable()
	
func enable():
	$BubbleTimer.enable()

func add_force(offset: Vector2, force: Vector2):
	var bubbles = get_tree().get_nodes_in_group(bubbles_group)
	for bubble in bubbles:
		bubble.add_force(offset, force)

func apply_impulse(offset: Vector2, impulse: Vector2):
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
