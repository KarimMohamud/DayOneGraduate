extends Node

@onready var player = $"../CharacterBody2D"  # Correct reference to CharacterBody2D
@export var health_bar: ProgressBar  # Health bar to update
var hp = 3  # Initial health value

# Define a signal for health change
signal health_changed(new_health)


# This function subtracts health and updates the health bar
func _subtract_health(amount: int) -> void:
	hp -= amount
	health_bar.value = hp  # Update the health bar value

	# Emit the signal to notify listeners of health change
	emit_signal("health_changed", hp)

	if hp <= 0:
		_on_player_dead()
		self.queue_free()
		get_node("../../GameOver")._on_game_over()
		
# Function to handle what happens when the player dies
func _on_player_dead() -> void:
	print("Player is dead!")
	# Here, you could trigger a game over screen, respawn, etc.

func _ready() -> void:
	var health_script = get_parent().get_node("Health")
	if health_script == null:
		health_script.connect("health_changed", Callable(self, "_on_health_changed"))
		print("Error: Health node not found in parent!")
	else:
		print("Health script dynamically assigned: ", health_script)

# This function will be called whenever the health changes
func _on_health_changed(new_health: int) -> void:
	# Update the health bar UI (you can also add any other UI update logic here)
	health_bar.value = new_health
	print("Health updated to: " + str(new_health))
