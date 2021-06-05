extends Node

class_name Bubbles

export (PackedScene) var Bubble

export var bubbles_max_simultaneous = 10
export var bubbles_min_mass = 10
export var bubbles_max_mass = 30

func _ready():
	randomize()
	
	$BubbleTimer.connect("timeout", self, "_on_BubbleTimer_timeout")
	
	_if_main()
	
func _if_main():
	if get_tree().current_scene.name != name:
		return
	start()
	
func start():
	$BubbleTimer.start()

func _on_BubbleTimer_timeout():
	# new bubble
	var bubble = Bubble.instance()
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
