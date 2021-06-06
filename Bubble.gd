extends RigidBody2D
class_name Bubble, "res://art/bubble.png"

var force = 500
var torque = 0 #20000

export var pseudo_gravity_scale = 9800
export var pseudo_gravity_vec = Vector2(0, -1)

func _ready():
	disable()
	enable_if_main()

func enable_if_main():
	if get_tree().current_scene.name != name:
		return
	enable()

func set_scale(scale):
	$Sprite.scale *= scale
	$CollisionShape2D.scale *= scale
	$VisibilityNotifier2D.scale *= scale

func enable():
	print("Bubble(position=%s,mass=%d)" % [str(position), mass])

	show()
	$CollisionShape2D.disabled = false
	
	# apply gravity
	add_force(Vector2(), pseudo_gravity_scale * mass * pseudo_gravity_vec)

func disable():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bubble_body_entered(body):
	print("POP")
	disable()

# apply force
func _integrate_forces(state):

	applied_force = Vector2()
	if Input.is_action_pressed("ui_right"):
		applied_force.x += force
	if Input.is_action_pressed("ui_left"):
		applied_force.x -= force
	if Input.is_action_pressed("ui_down"):
		applied_force.y += force
	if Input.is_action_pressed("ui_up"):
		applied_force.y -= force
	
	applied_torque = torque
