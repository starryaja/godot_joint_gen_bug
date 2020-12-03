# Not relavent to bug, only used for seeing what's happening. Relevant code is
# in the dynamic_chain script.

extends KinematicBody

var view_sensitivity = 0.3
var yaw = 0
var pitch = 0
var velocity = Vector3()
var is_moving = false

const FLY_SPEED = 10000
const FLY_ACCEL = 4

func _input(ie):
	if ie is InputEventMouseMotion:
		yaw = fmod(yaw - ie.get_relative().x * view_sensitivity, 360)
		pitch = max(min(pitch - ie.get_relative().y * view_sensitivity, 90), -90)
		get_node("yaw").set_rotation(Vector3(0, deg2rad(yaw), 0))
		get_node("yaw/Camera").set_rotation(Vector3(deg2rad(pitch), 0, 0))

func _physics_process(delta):
	_fly(delta)
	
func _ready():
	set_physics_process(true)
	set_process_input(true)
	
func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _fly(delta):
	var aim = get_node("yaw/Camera").get_global_transform().basis
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= aim[2]
	if Input.is_action_pressed("move_backward"):
		direction += aim[2]
	if Input.is_action_pressed("move_left"):
		direction -= aim[0]
	if Input.is_action_pressed("move_right"):
		direction += aim[0]
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	direction = direction.normalized()
	var target = direction*FLY_SPEED
	velocity = Vector3().linear_interpolate(target, FLY_ACCEL*delta)
	
	var motion = velocity*delta
	motion = move_and_slide(motion)
