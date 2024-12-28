extends KinematicBody2D

class_name Player

onready var sprite: Sprite = $textura

var velocity: Vector2 = Vector2.ZERO
var jump_count: int = 0

var landing: bool = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false
var can_tracking_input: bool = true

export(int) var speed
export(int) var jumpPower
export(int) var gravity

func _physics_process(delta: float):
    handle_horizontal_movement()
    handle_vertical_movement()
    handle_actions()
    apply_gravity(delta)

    velocity = move_and_slide(velocity, Vector2.UP)
    sprite.animated(velocity)

func handle_horizontal_movement() -> void:
    var direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    if not can_tracking_input or attacking:
        velocity.x = 0
        return

    velocity.x = direction * speed

func handle_vertical_movement() -> void:
    reset_jump_count_if_on_floor()
    handle_jump()

func reset_jump_count_if_on_floor() -> void:
    if is_on_floor():
        jump_count = 0

func handle_jump() -> void:
    var jump_condition: bool = can_tracking_input and not attacking
    if Input.is_action_just_pressed("ui_select") and jump_count < 2 and jump_condition:
        jump_count += 1
        velocity.y = -jumpPower

func handle_actions() -> void:
    handle_attack()
    handle_defense()
    handle_crouch()

func handle_attack() -> void:
    if can_attack() and Input.is_action_just_pressed("attack"):
        start_attack()

func can_attack() -> bool:
    return not attacking and not defending and not crouching and is_on_floor()

func start_attack() -> void:
    attacking = true
    sprite.normal_attack = true

func handle_defense() -> void:
    if Input.is_action_pressed("defense") and not crouching and is_on_floor():
        defending = true
        can_tracking_input = false
    elif not crouching:
        defending = false
        can_tracking_input = true
        sprite.shield_off = true

func handle_crouch() -> void:
    if Input.is_action_pressed("crouch") and not defending and is_on_floor():
        crouching = true
        can_tracking_input = false
    elif not defending:
        crouching = false
        can_tracking_input = true
        sprite.crouch_off = true

func apply_gravity(delta: float) -> void:
    velocity.y += gravity * delta
    if velocity.y >= gravity:
        velocity.y = gravity
