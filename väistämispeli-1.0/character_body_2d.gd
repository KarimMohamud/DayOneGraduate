extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



@onready var anim = get_node("AnimatedSprite2D")

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	print(direction)
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		anim.play("Run")
	else:
		anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	if velocity.y < 0:
			anim.play("Jump")
			


	move_and_slide()
