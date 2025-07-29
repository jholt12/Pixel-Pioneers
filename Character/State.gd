extends Node

class_name State

@export var can_move : bool = true

var character : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State

signal interrupt_state(new_state : State)

# State machine will pass the delta time into this state
# on each process cycle so the state can update
# each frame while the state is set to the current state
func state_process(delta):
	pass

# State machine will pass the user input into the current state
# so it can be responded to when this state is the active statee
func state_input(event : InputEvent):
	pass

# Called when state machine enters this state
func on_enter():
	pass

# Called before state machine changes out of this state
func on_exit():
	pass
	
