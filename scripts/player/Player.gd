extends KinematicBody2D

class_name Player

onready var sprite: Sprite = $textura

var velocity: Vector2 = Vector2.ZERO
var jumpCount: int = 0

var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false
var can_tracking_input: bool = true

export(int) var speed
export(int) var jumpPower
export(int) var gravity

func _physics_process(delta: float):
  horizontalMovimentEnvironment()
  verticalMovimentEnvironment()
  actionEnvironment()
  gravityPlayer(delta)

  velocity = move_and_slide(velocity, Vector2.UP)
  sprite.animated(velocity)

func horizontalMovimentEnvironment() -> void:
  var direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  if can_tracking_input == false or attacking:
    velocity.x = 0
    return
  
  velocity.x = direction * speed


func verticalMovimentEnvironment() -> void:
  if is_on_floor():
    jumpCount = 0

  var jump_condition: bool = can_tracking_input and  not attacking
  if Input.is_action_just_pressed("ui_select") and jumpCount < 2  and jump_condition:
    jumpCount += 1
    velocity.y = -jumpPower

func actionEnvironment() -> void:
  attack()
  defense()
  crouch()

func attack() -> void:
  var attack_condition: bool = not attacking and not defending and not crouching
  if Input.is_action_just_pressed("attack") and attack_condition and is_on_floor():
    attacking = true
    sprite.normal_attack = true
  

func defense() -> void:
  if Input.is_action_pressed("defense") and not crouching and is_on_floor():
    defending = true
    can_tracking_input = false
  elif not crouching:
    defending = false
    can_tracking_input = true
    sprite.shield_off = true

func crouch() -> void:
  if Input.is_action_pressed("crouch") and not defending and is_on_floor():
    crouching = true
    can_tracking_input = false
  elif not defending:
    crouching = false
    can_tracking_input = true
    sprite.crouch_off = true

func gravityPlayer(delta: float) -> void:
  velocity.y += gravity * delta
  if velocity.y >= gravity:
    velocity.y = gravity