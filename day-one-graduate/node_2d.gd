extends Node2D

@export var a_plus_texture: Texture2D  # The texture for the A+ paper
@export var spawn_interval: float = 1.0  # Time interval for spawning A+ papers
@export var fall_speed: float = 200.0  # Falling speed of the A+ papers

@onready var player = $CharacterBody2D  # Correct reference to CharacterBody2D
@onready var score_label = $Label  # The score label
@onready var health_script = $Health  # Reference to the Health script

var score: int = 0
var spawn_timer: Timer
var f_paper_scene = preload("res://F_paper.tscn")  # Preload the F paper scene

func _ready() -> void:
	# Spawn the F paper scene and set the reference to the main Node2D
	var f_paper_instance = f_paper_scene.instantiate()
	f_paper_instance.set_player(player)  # Pass the reference of this Node2D script
	f_paper_instance.set_node_2d(self)
	add_child(f_paper_instance)
	
	# Set up the spawn timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
	spawn_timer.timeout.connect(_spawn_a_plus_paper)

	# Initialize score label
	score_label.text = "Score: 0"

func _process(_delta: float) -> void:
	if score < 0:
		get_tree().quit()

	# Process logic for falling A+ paper and detecting collisions
	for a_plus_paper in get_children():
		if a_plus_paper is Area2D:  # Now we check for Area2D (A+ paper container with collision)
			# Update the position to make the paper fall
			a_plus_paper.position.y += fall_speed * _delta

			# Remove the paper if it falls off the screen
			if a_plus_paper.position.y > get_viewport_rect().size.y:
				a_plus_paper.queue_free()

			# Check for collision with the player
			var bodies = a_plus_paper.get_overlapping_bodies()
			for body in bodies:
				if body == player:
					_on_a_plus_paper_collision(a_plus_paper)

func _spawn_a_plus_paper() -> void:
	# Ensure the texture is valid before proceeding
	if a_plus_texture == null:
		print("Error: A+ papers texture is not assigned!")
		return
	
	# Create a new Area2D for collision detection
	var a_plus_paper_area = Area2D.new()
	a_plus_paper_area.position = Vector2(randf() * get_viewport_rect().size.x, 0)  # Random position

	# Create a Sprite2D for the A+ paper
	var a_plus_paper_instance = Sprite2D.new()
	a_plus_paper_instance.texture = a_plus_texture

	# Add the Sprite2D as a child of the Area2D
	a_plus_paper_area.add_child(a_plus_paper_instance)

	# Create a CollisionShape2D for the Area2D
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	
	# Use the texture size for collision shape size
	if a_plus_texture:
		shape.extents = Vector2(float(a_plus_texture.get_width()) / 6, float(a_plus_texture.get_height()) / 6)
	collision_shape.shape = shape
	a_plus_paper_area.add_child(collision_shape)

	# Add the Area2D (with Sprite2D and CollisionShape2D) to the scene
	add_child(a_plus_paper_area)

func _on_a_plus_paper_collision(a_plus_paper_area: Area2D) -> void:
	# Debug log to check if the player collided with the a_plus_paper
	a_plus_paper_area.queue_free()  # Remove the a_plus_paper when it collides with the player
	score += 1        # Increment the score
	score_label.text = "Score: " + str(score)
