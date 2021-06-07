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
	var cur_wind_interval = wind_interval + randf() * wind_interval_var - wind_interval_var / 2
	$Sprite.material = $Sprite.get_material().duplicate()
	$Sprite.get_material().set_shader_param("interval", cur_wind_interval)
	$AnimatedSprite.material = $AnimatedSprite.get_material().duplicate()
	$AnimatedSprite.get_material().set_shader_param("interval", cur_wind_interval)
	if $AnimatedSprite.visible:
		# default animation is only one image - avoid triggering _on_AnimatedSprite_animation_finished
		$AnimatedSprite.stop()
	
	slow_wind()

	hide()
	if enable_on_start or get_tree().current_scene.name == name:
		enable()

func fast_wind():
	$Sprite.get_material().set_shader_param("speed", wind_fast_speed)
	$Sprite.get_material().set_shader_param("strengthScale", wind_fast_strength_scale)
	$AnimatedSprite.get_material().set_shader_param("speed", wind_fast_speed)
	$AnimatedSprite.get_material().set_shader_param("strengthScale", wind_fast_strength_scale)

func slow_wind():
	$Sprite.get_material().set_shader_param("speed", wind_slow_speed)
	$Sprite.get_material().set_shader_param("strengthScale", wind_slow_strength_scale)
	$AnimatedSprite.get_material().set_shader_param("speed", wind_slow_speed)
	$AnimatedSprite.get_material().set_shader_param("strengthScale", wind_slow_strength_scale)

func set_scale(scale):
	utils_printf("Setting scale to: %f", [scale], 10)
	$Sprite.scale *= scale
	$AnimatedSprite.scale *= scale
	$CollisionShape2D.scale *= scale
	$VisibilityNotifier2D.scale *= scale

func enable():
	utils_printf("position=%s, mass=%f, gravity_scale=%f", 
		[str(position), mass, pseudo_gravity_scale],
		10)

	show()
	$CollisionShape2D.disabled = false
	
	# apply gravity
	add_force(Vector2(), pseudo_gravity_scale * mass * pseudo_gravity_vec)

func free_bubble():
	utils_printf("Left screen", Array(), 10)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	if was_in_screen:
		free_bubble()
	
func _on_VisibilityNotifier2D_screen_entered():
	was_in_screen = true

func _on_Bubble_body_entered(body):
	utils_printf("POP", Array(), 10)
	$AnimatedSprite.play("pop_two")
	
	# hide in case we are using sprite, not anomated sprite
	if $Sprite.visible:
		$CollisionShape2D.set_deferred("disabled", true)
		hide()
	if $AnimatedSprite.visible and $VisibilityNotifier2D.is_on_screen():
		# scale collision shape to pop animation
		$CollisionShape2D.scale = Vector2(1.4, 1.4)
	
func _on_AnimatedSprite_animation_finished():
	# TODO this is very ineeficient
	if $AnimatedSprite.animation == "pop_two":
		$CollisionShape2D.set_deferred("disabled", true)
		hide()

export var utils_log_level = 20  # info

func utils_printf(msg: String, vars: Array = [], level: int = 0):
	if level >= utils_log_level:
		var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
		var content = msg % vars
		print(prefix + content)
