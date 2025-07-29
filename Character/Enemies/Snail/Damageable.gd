extends Node

class_name Damageable

signal on_hit(node : Node, damage_taken : int, knockback_direction : Vector2)

@export var health : float = 20 :
	get:
		return health
	set(value):
		# Call the global emit signal so responders dont need
		# to connect directly with this object to receive the signal data
		SignalBus.emit_signal("on_health_changed", get_parent(), value - health)
		health = value
		
@export var dead_animation_name : String = "dead"

func hit(damage : int, knockback_direction : Vector2):
	health -= damage
	
	# Local signal for subscribers that only care about this specific
	# damageable object
	emit_signal("on_hit", get_parent(), damage, knockback_direction)

# After the dead animation plays, remove the parent node from the scene
# This also removes children
func _on_animation_tree_animation_finished(anim_name):
	if(anim_name == dead_animation_name):
		# character is finished dying, remove from the game
		get_parent().queue_free()
