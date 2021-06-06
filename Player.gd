extends Node
class_name Player

signal apply_uniform_force(force_vec)

export var force_scale = 500

var applied_force = Vector2()

func _physics_process(delta):
	# TODO handle delta
	
	var new_applied_force = Vector2()
	if Input.is_action_pressed("ui_right"):
		new_applied_force.x += 1
	if Input.is_action_pressed("ui_left"):
		new_applied_force.x -= 1
	if Input.is_action_pressed("ui_down"):
		new_applied_force.y += 1
	if Input.is_action_pressed("ui_up"):
		new_applied_force.y -= 1
	
	if new_applied_force.length() > 0:
		new_applied_force = new_applied_force.normalized()
		new_applied_force *= force_scale
	
	if new_applied_force.distance_to(applied_force) > 0:
		utils_printf("applying new force: %s" % [str(new_applied_force - applied_force)])
		emit_signal("apply_force", new_applied_force)
		applied_force = new_applied_force

func utils_printf(msg: String, vars: Array = []):
	var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
	var content = msg % vars
	print(prefix + content)
