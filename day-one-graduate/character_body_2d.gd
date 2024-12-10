extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -500.0

@onready var health_script = $"../Health"  # Reference to the Health script
@onready var anim = get_node("AnimatedSprite2D")  # Reference to the AnimatedSprite2D node

func _on_f_paper_collision() -> void:
	print("Player collided with F paper!")
	health_script._subtract_health(1)  # Call the health script to decrease health

func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	
	if health_script == null:
		print("Error: Health script not assigned!")
	else:
		print("Health script successfully assigned!")

func _physics_process(delta: float) -> void:
	# Add gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get input for movement
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# Flip the sprite based on movement direction
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false

	# Update velocity based on input
	if direction:
		velocity.x = direction * SPEED
		anim.play("Run")
	else:
		anim.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Keep playing "Jump" animation if player is moving upwards
	if velocity.y < 0:
		anim.play("Jump")

	move_and_slide()
