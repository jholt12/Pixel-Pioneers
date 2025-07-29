extends State

class_name AirState

@export var landing_state : State
@export var double_jump_velocity : float = -100
@export var double_jump_animation : String = "double_jump"
@export var landing_animation : String = "landing"

var has_double_jumped = false

func state_process(delta):
	# Switch to the landing if the character reaches the ground
	if(character.is_on_floor()):
		next_state = landing_state
		
func state_input(event : InputEvent):
	# Jump a second time while in the air
	if(event.is_action_pressed("jump") && !has_double_jumped):
		double_jump()

func on_exit():
	# Play landing animation and reset double jump if exiting to landing state
	if(next_state == landing_state):
		playback.travel(landing_animation)
		has_double_jumped = false

# Set character's velocity while in the air and play the double jump animation
# Can double jump once per time in the air
func double_jump():

	character.velocity.y = double_jump_velocity
	playback.travel(double_jump_animation)
	has_double_jumped = true
