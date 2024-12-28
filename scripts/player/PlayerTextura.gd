extends Sprite

class_name PlayerTextura

export(NodePath) var animationPath;
export(NodePath) var playerPath;

onready var animation: AnimationPlayer = get_node(animationPath)
onready var player: Player = get_node(playerPath)

func animated(direction: Vector2) -> void:
	flipTexture(direction)
	if direction.y != 0:
		verticalBehavior(direction)
	elif player.landing == true:
		animation.play("Landing")
		player.set_physics_process(false)
	else:
		horizontalBehavior(direction)

func flipTexture(direction: Vector2) -> void:
	if direction.x < 0:
		set_flip_h(true)
	elif direction.x > 0:
		set_flip_h(false)

func horizontalBehavior(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("Run")
	else:
		animation.play("Idle")

func verticalBehavior(direction: Vector2) -> void:
	if direction.y < 0:
		animation.play("Jump")
	elif direction.y > 0:
		player.landing = true
		animation.play("Fall")



func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"Landing":
			player.landing = false
			player.set_physics_process(true)
