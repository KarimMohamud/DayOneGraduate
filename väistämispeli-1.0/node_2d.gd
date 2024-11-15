extends Node2D

@export var star_texture: Texture2D     # The texture for the stars
@export var spawn_interval: float = 1.0  # Time interval for spawning stars
@export var fall_speed: float = 200.0   # Falling speed of the stars (pixels per second)
@onready var player = $CharacterBody2D   # Correct reference to CharacterBody2D
@onready var score_label = $Label        # The score label

var score: int = 0
var spawn_timer: Timer

func _ready() -> void:
	# Ensure the texture is assigned
	if star_texture == null:
		print("Error: Star texture is not assigned!")
		return
	
	# Set up the spawn timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
	spawn_timer.timeout.connect(_spawn_star)

	# Initialize score label
	score_label.text = "Score: 0"

func _process(_delta: float) -> void:
	# Process logic for falling stars and detecting collisions
	for star in get_children():
		if star is Area2D:  # Now we check for Area2D (star container with collision)
			# Update the position to make the star fall
			star.position.y += fall_speed * _delta

			# Remove the star if it falls off the screen
			if star.position.y > get_viewport_rect().size.y:
				star.queue_free()

			# Check for collision with the player using get_overlapping_bodies()
			var bodies = star.get_overlapping_bodies()
			for body in bodies:
				if body == player:
					_on_star_collision(star)

func _spawn_star() -> void:
	# Ensure the texture is valid before proceeding
	if star_texture == null:
		print("Error: Star texture is not assigned!")
		return
	
	# Create a new Area2D for collision detection
	var star_area = Area2D.new()
	star_area.position = Vector2(randf() * get_viewport_rect().size.x, 0)  # Random position

	# Create a Sprite2D for the star
	var star_instance = Sprite2D.new()
	star_instance.texture = star_texture

	# Add the Sprite2D as a child of the Area2D
	star_area.add_child(star_instance)

	# Create a CollisionShape2D for the Area2D
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	
	# Use the texture size for collision shape size, ensure texture is valid
	if star_texture:
		shape.extents = Vector2(float(star_texture.get_width()) / 2, float(star_texture.get_height()) / 2)
	collision_shape.shape = shape
	star_area.add_child(collision_shape)

	# Add the Area2D (with Sprite2D and CollisionShape2D) to the scene
	add_child(star_area)

func _on_star_collision(star_area: Area2D) -> void:
	# Debug log to check if the player collided with the star
	print("Star collided with player!")  # This log will print when a collision happens
	star_area.queue_free()  # Remove the star when it collides with the player
	score += 1         # Increment the score
	score_label.text = "Score: " + str(score)
