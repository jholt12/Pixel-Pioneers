extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Walks left by default
@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var movement_speed : float = 30.0
@export var hit_state : State

# Gravity from Project Settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2

func _ready():
	animation_tree.active = true
	direction = starting_move_direction
	update_facing()  # Flip sprite at start to match direction

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement logic
	if direction and state_machine.check_if_can_move():
		velocity.x = direction.x * movement_speed
	elif state_machine.current_state != hit_state:
		velocity.x = move_toward(velocity.x, 0, movement_speed)

	move_and_slide()

	# If snail hits a wall, reverse direction and update facing
	if is_on_wall():
		direction *= -1
		update_facing()

func update_facing():
	# Invert logic: flip_h should be TRUE when facing RIGHT
	sprite.flip_h = direction.x > 0
