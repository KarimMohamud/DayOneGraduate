extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -500.0



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

		
