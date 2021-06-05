extends Node

export (PackedScene) var Bubble

var max_bubbles = 10
var bubble_min_mass = 10
var bubble_max_mass = 30

func _ready():
	randomize()
	
	$BubbleTimer.connect("timeout", self, "_on_BubbleTimer_timeout")
	
	$BubbleTimer.start()

func _on_BubbleTimer_timeout():
	var bubble = Bubble.instance()
	add_child(bubble)
	
	$BubblePath/BubbleSpawnLocation.offset = randi()
	var size = rand_range(bubble_min_mass, bubble_max_mass)
	var scale = sqrt(size/bubble_min_mass)
	print(scale)
	
	bubble.position = $BubblePath/BubbleSpawnLocation.position
	bubble.mass = size
	bubble.get_node("Sprite").scale *= scale
	bubble.get_node("CollisionShape2D").scale *= scale
	bubble.get_node("VisibilityNotifier2D").scale *= scale
	
	bubble.start()
