extends Sprite

class_name PlayerTextura

export(NodePath) var animationPath;
export(NodePath) var playerPath;

onready var animation: AnimationPlayer = get_node(animationPath)
onready var player: Player = get_node(playerPath)

var suffix: String = "Right"
var normal_attack: bool = false
var shield_off: bool = false
var crouch_off: bool = false

func animated(direction: Vector2) -> void:
	flipTexture(direction)
	if player.attacking or player.defending or player.crouching:
		actionBihavior()
	elif direction.y != 0:
		verticalBehavior(direction)
	elif player.landing == true:
		animation.play("Landing")
		player.set_physics_process(false)
	else:
		horizontalBehavior(direction)

func flipTexture(direction: Vector2) -> void:
	if direction.x < 0:
		set_flip_h(true)
		suffix = "Left"
	elif direction.x > 0:
		set_flip_h(false)
		suffix = "Right"

func horizontalBehavior(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("Run")
	else:
		animation.play("Idle")

func actionBihavior() -> void:
	if player.attacking and normal_attack:
		animation.play("Attack" + suffix)
	elif player.defending and shield_off:
		animation.play("Shield")
		shield_off = false
	elif player.crouching and crouch_off:
		animation.play("Crouch")
		crouch_off = false

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

		"AttackLeft":
			player.attacking = false
			normal_attack = false

		"AttackRight":
			player.attacking = false
			normal_attack = false
