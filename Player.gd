extends Node
class_name Player

signal apply_uniform_impulse(impulse_vec)

export var force_scale = 500

func _physics_process(delta):
	var applied_impulse = Vector2()
	if Input.is_action_pressed("ui_right"):
		applied_impulse.x += 1
	if Input.is_action_pressed("ui_left"):
		applied_impulse.x -= 1
	if Input.is_action_pressed("ui_down"):
		applied_impulse.y += 1
	if Input.is_action_pressed("ui_up"):
		applied_impulse.y -= 1
	
	if applied_impulse.length() > 0:
		applied_impulse = applied_impulse.normalized()
		applied_impulse *= force_scale
		
		utils_printf("applying impulse: %s" % [str(applied_impulse)])
		emit_signal("apply_impulse", applied_impulse)
		# TODO handle delta

func utils_printf(msg: String, vars: Array = []):
	var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
	var content = msg % vars
	print(prefix + content)
