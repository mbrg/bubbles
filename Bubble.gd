extends RigidBody2D
class_name Bubble, "res://art/bubble.png"

export var pseudo_gravity_scale = 98
export var pseudo_gravity_vec = Vector2(0, -1)

export var enable_on_start = false

export var wind_interval = 3.5
export var wind_interval_var = 1.0
export var wind_slow_speed = 8
export var wind_slow_strength_scale = 100
export var wind_fast_speed = 12
export var wind_fast_strength_scale = 200

var was_in_screen = false

func _ready():
	randomize()
	$Sprite.material = $Sprite.get_material().duplicate()
	var cur_wind_interval = wind_interval + randf() * wind_interval_var - wind_interval_var / 2
	$Sprite.get_material().set_shader_param("interval", cur_wind_interval)
	
	slow_wind()

	hide()
	if enable_on_start or get_tree().current_scene.name == name:
		enable()

func fast_wind():
	$Sprite.get_material().set_shader_param("speed", wind_fast_speed)
	$Sprite.get_material().set_shader_param("strengthScale", wind_fast_strength_scale)

func slow_wind():
	$Sprite.get_material().set_shader_param("speed", wind_slow_speed)
	$Sprite.get_material().set_shader_param("strengthScale", wind_slow_strength_scale)

func set_scale(scale):
	$Sprite.scale *= scale
	$CollisionShape2D.scale *= scale
	$VisibilityNotifier2D.scale *= scale

func enable():
	utils_printf("position=%s, mass=%f, gravity_scale=%f", 
		[str(position), mass, pseudo_gravity_scale])

	show()
	$CollisionShape2D.disabled = false
	
	# apply gravity
	add_force(Vector2(), pseudo_gravity_scale * mass * pseudo_gravity_vec)

func _on_VisibilityNotifier2D_screen_exited():
	if was_in_screen:
		utils_printf("Left screen")
		queue_free()
	
func _on_VisibilityNotifier2D_screen_entered():
	was_in_screen = true

func _on_Bubble_body_entered(body):
	utils_printf("POP")
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func utils_printf(msg: String, vars: Array = []):
	var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
	var content = msg % vars
	print(prefix + content)


