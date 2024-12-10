extends Node2D

@export var f_paper_texture: Texture2D  # The texture for the F paper
@export var spawn_interval: float = 0.5  # Time interval for spawning F papers
@export var fall_speed: float = 400.0  # Falling speed of the F papers (pixels per second)

var player: Node   # Player reference
var node_2d_script: Node2D  # Reference to the main Node2D script

var spawn_timer: Timer

# Set player reference passed from node_2d.gd
func set_player(player_ref: Node) -> void:
	player = player_ref
	if player == null:
		print("Error: Player reference not set properly!")
	else:
		print("Player reference successfully set!")

	if player and player.has_node("Health"):
		print("Health script is available")
	else:
		print("Error: Health script is not found!")

# Set the reference to the main node2d script to access decrement_score
func set_node_2d(node_2d_ref: Node2D) -> void:
	node_2d_script = node_2d_ref

func _ready() -> void:
	# Set up the spawn timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
	spawn_timer.timeout.connect(_spawn_f_paper)

func _process(_delta: float) -> void:
	# Process logic for falling F paper and detecting collisions
	for f_paper in get_children():
		if f_paper is Area2D:  # Check for Area2D (F paper container with collision)
			# Update the position to make the paper fall
			f_paper.position.y += fall_speed * _delta

			# Remove the paper if it falls off the screen
			if f_paper.position.y > get_viewport_rect().size.y:
				f_paper.queue_free()

			# Check for collision with the player
			var bodies = f_paper.get_overlapping_bodies()
			for body in bodies:
				if body == player:
					_on_f_paper_collision(f_paper)

func _spawn_f_paper() -> void:
	# Ensure the texture is valid before proceeding
	if f_paper_texture == null:
		print("Error: F paper texture is not assigned!")
		return
	
	# Create a new Area2D for collision detection
	var f_paper_area = Area2D.new()
	f_paper_area.position = Vector2(randf() * get_viewport_rect().size.x, 0)  # Random position

	# Create a Sprite2D for the F paper
	var f_paper_instance = Sprite2D.new()
	f_paper_instance.texture = f_paper_texture

	# Add the Sprite2D as a child of the Area2D
	f_paper_area.add_child(f_paper_instance)

	# Create a CollisionShape2D for the Area2D
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()

	# Use the texture size for collision shape size
	if f_paper_texture:
		shape.extents = Vector2(float(f_paper_texture.get_width()) / 6, float(f_paper_texture.get_height()) / 6)
	collision_shape.shape = shape
	f_paper_area.add_child(collision_shape)

	# Add the Area2D (with Sprite2D and CollisionShape2D) to the scene
	add_child(f_paper_area)

func _on_f_paper_collision(f_paper_area: Area2D) -> void:
	if player and player.has_node("Health"):
		var health_script = player.get_node("Health")  # Get the health script
		health_script._subtract_health(1)  # Decrease health
		print("Player collided with F paper! Health reduced.")
	else:
		print("Error: Health script not found on Player")

	f_paper_area.queue_free()  # Remove the F paper after collision
