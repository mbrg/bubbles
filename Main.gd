extends Node
class_name Main

export var bubbles_gravity_scale = 5 * 9.8
export var bubbles_linear_damp = 5 * 0.1
export var bubbles_min_mass = 2
export var bubbles_max_mass = 6
export var player_force_scale = 500

func _ready():
	$Player.force_scale = player_force_scale
	
	$Bubbles.gravity_scale = bubbles_gravity_scale
	$Bubbles.linear_damp = bubbles_linear_damp
	$Bubbles.min_mass = bubbles_min_mass
	$Bubbles.max_mass = bubbles_max_mass
	$Bubbles.enable_on_start = true
	
func _on_Player_apply_uniform_force(force_vec):
	utils_printf("player applied force: %s", [str(force_vec)])
	$Bubbles.add_force(Vector2(), force_vec)

func _on_Bubbles_spawned_new_bubble(new_bubble: Bubble):
	new_bubble.add_force(Vector2(), $Player.applied_force)

export var utils_log_level = 20  # info

func utils_printf(msg: String, vars: Array = [], level: int = 0):
	if level >= utils_log_level:
		var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
		var content = msg % vars
		print(prefix + content)
