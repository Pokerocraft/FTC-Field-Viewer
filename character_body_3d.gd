extends CharacterBody3D
@export var mouse_sensitivity: float = 0.003
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var capturedMouse: bool

func _ready() -> void:
	capturedMouse = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("PauseCapture"):
		if capturedMouse:
			capturedMouse = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif !capturedMouse:
			capturedMouse = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventMouseMotion and capturedMouse:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

const SPEED = 2.5
const JUMP_VELOCITY = 4.5


##Basic Character Controller Stuff
func _physics_process(delta: float) -> void:
	if capturedMouse:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
