extends CharacterBody2D

class_name Player

@export var speed : float = 200.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var fade_overlay : ColorRect = get_tree().root.get_node("Level1/FadeOverlay") # Update path if needed

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO

signal facing_direction_changed(facing_right : bool)

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	direction = Input.get_vector("left", "right", "up", "down")

	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation_parameters()
	update_facing_direction()
	coin_check()

func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true

	emit_signal("facing_direction_changed", !sprite.flip_h)

var previous_tile = Vector2i(-999, -999)

func coin_check():
	var tilemap = get_parent().get_node("TileMap")
	var tile_pos = tilemap.local_to_map(global_position)

	if tile_pos == previous_tile:
		return
	previous_tile = tile_pos

	var source_id = tilemap.get_cell_source_id(0, tile_pos)
	var atlas_coords = tilemap.get_cell_atlas_coords(0, tile_pos)
	var alternative = tilemap.get_cell_alternative_tile(0, tile_pos)

	if source_id == 0 and atlas_coords == Vector2i(15, 21) and alternative == 0:
		print("Coin collected at:", tile_pos)
		tilemap.erase_cell(0, tile_pos)
		add_coin()

func add_coin():
	print("Coin collected!")

# When entering GameEndZone, fade and quit
func _on_game_end_zone_body_entered(body: Node2D) -> void:
	if body != self:
		return

	print("Player entered end zone. Fading out...")
	if fade_overlay:
		fade_overlay.visible = true
		var tween := create_tween()
		tween.tween_property(fade_overlay, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
