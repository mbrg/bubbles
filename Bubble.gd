extends RigidBody2D
class_name Bubble, "res://art/bubble.png"

export var pseudo_gravity_scale = 98
export var pseudo_gravity_vec = Vector2(0, -1)

export var enable_on_start = false

func _ready():
	hide()
	if enable_on_start or get_tree().current_scene.name == name:
		enable()

func set_scale(scale):
	$Sprite.scale *= scale
	$CollisionShape2D.scale *= scale
	$VisibilityNotifier2D.scale *= scale

func enable():
	utils_printf("position=%s, mass=%d", [str(position), mass])
	
	show()
	$CollisionShape2D.disabled = false
	
	# apply gravity
	add_force(Vector2(), pseudo_gravity_scale * mass * pseudo_gravity_vec)

func _on_VisibilityNotifier2D_screen_exited():
	utils_printf("Left screen")
	queue_free()

func _on_Bubble_body_entered(body):
	utils_printf("POP")
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func utils_printf(msg: String, vars: Array = []):
	var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
	var content = msg % vars
	print(prefix + content)
