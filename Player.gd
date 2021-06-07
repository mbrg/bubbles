extends Node
class_name Player

signal apply_uniform_force(force_vec)

export var force_scale = 500
export var hide = false

# TODO dont call this from Main, its not easily understandable
var applied_force = Vector2()
var applied_direction = Vector2()

func _ready():
	$LeftRightGradient.hide()
	$TopBottomGradient.hide()

func _physics_process(delta):
	# TODO handle delta
	
	var direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	if direction.distance_to(applied_direction) > 0:
		change_gradient(direction)
		change_force(direction)

func change_gradient(direction):
	if not hide:
		$LeftRightGradient.show()
	if direction.x == 0:
		$LeftRightGradient.hide()
	elif direction.x > 0:
		$LeftRightGradient.flip_h = false
	else:
		$LeftRightGradient.flip_h = true
	
	if not hide:
		$TopBottomGradient.show()
	if direction.y == 0:
		$TopBottomGradient.hide()
	elif direction.y > 0:
		$TopBottomGradient.flip_h = false
	else:
		$TopBottomGradient.flip_h = true

	applied_direction = direction

func change_force(direction):
	var new_applied_force = direction * force_scale

	utils_printf("applying new force: %s" % [str(new_applied_force)])
	emit_signal("apply_uniform_force", new_applied_force - applied_force)
	applied_force = new_applied_force

func utils_printf(msg: String, vars: Array = []):
	var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
	var content = msg % vars
	print(prefix + content)
