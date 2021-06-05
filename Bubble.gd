extends RigidBody2D

var force = 500
var torque = 0 #20000

func _ready():
	hide()
	
	# free on screen_exited
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	self.connect("body_entered", self, "_on_Bubble_body_entered")
	
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

func start():
	print("Bubble(position=%s,mass=%d)" % [str(position), mass])

	show()
	$CollisionShape2D.disabled = false

func set_scale(scale):
	$Sprite.scale *= scale
	$CollisionShape2D.scale *= scale
	$VisibilityNotifier2D.scale *= scale

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bubble_body_entered(body):
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
