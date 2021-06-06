extends Node
class_name Main
	
func _on_Player_apply_uniform_force(force_vec):
	utils_printf("player applied force: %s", [str(force_vec)])
	$Bubbles.add_force(Vector2(), force_vec)

func _on_Bubbles_spawned_new_bubble(new_bubble: Bubble):
	new_bubble.add_force(Vector2(), $Player.applied_force)

func utils_printf(msg: String, vars: Array = []):
	var prefix = "[%d] [%s %d] " % [OS.get_unix_time(), name, get_instance_id()]
	var content = msg % vars
	print(prefix + content)
