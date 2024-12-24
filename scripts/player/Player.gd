extends KinematicBody2D

class_name Player

onready var sprite: Sprite = $textura

var velocity: Vector2 = Vector2.ZERO
var jumpCount: int = 0
var landing: bool = false

export(int) var speed
export(int) var jumpPower
export(int) var gravity

func _physics_process(delta: float):
  horizontalMovimentEnvironment()
  verticalMovimentEnvironment()
  gravityPlayer(delta)

  velocity = move_and_slide(velocity, Vector2.UP)
  sprite.animated(velocity)

func horizontalMovimentEnvironment() -> void:
  var direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  velocity.x = direction * speed

func verticalMovimentEnvironment() -> void:
  if is_on_floor():
    jumpCount = 0

  if Input.is_action_just_pressed("ui_select") and jumpCount < 2:
    jumpCount += 1
    velocity.y = -jumpPower

func gravityPlayer(delta: float) -> void:
  velocity.y += gravity * delta
  if velocity.y >= gravity:
    velocity.y = gravity