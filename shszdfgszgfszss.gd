extends CharacterBody3D
var olhar = randi_range(1,10)
@onready var pivot: Node3D = $pivot
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var anima = false
const SPEED = 10.0
const JUMP_VELOCITY = 7.5
var pulo = 1
var fase = 20
var on = true
var rotato = 0
var velo_rotato = 6
@onready var path_follow_3d: PathFollow3D = $"../camera_trilha/Path3D/PathFollow3D"

func _physics_process(delta: float) -> void:
	animation(delta)
	if fase == 20:
		path_follow_3d.progress = -position.z
	if fase == 0:
		path_follow_3d.progress = -position.z
		animation_player.play("a")
	if fase == 1:
		path_follow_3d.progress = 151 + position.y
	if not is_on_floor():
		velocity += get_gravity() * delta


	if is_on_floor():
		anima = false
		
		pulo = 1

	#if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		#rotato = -45
	#if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		#rotato = -135
	#if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		#rotato = 45
	#if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		#rotato = 135
	if Input.is_action_just_pressed("pulo") and is_on_floor() and pulo == 1:
		$pivot/buddybuddy/AnimationPlayer.play("Jump")
		velocity.y = JUMP_VELOCITY
		pulo = 0
		anima = true
		
	if Input.is_action_just_pressed("pulo")and not is_on_floor() and pulo == 0:
		$pivot/buddybuddy/AnimationPlayer.play("Jump")
		velocity.y = JUMP_VELOCITY
		pulo = 1
	if olhar == 10 and on:
		on = false
		$pivot/buddybuddy/AnimationPlayer.play("IdleAnim2")
		await get_tree().create_timer($pivot/buddybuddy/AnimationPlayer.current_animation_length).timeout
		$pivot/buddybuddy/AnimationPlayer.play_backwards("IdleAnim2")
		await get_tree().create_timer($pivot/buddybuddy/AnimationPlayer.current_animation_length).timeout
		olhar = randi_range(1,10)
		print(olhar)
		on = true
	if olhar != 10 and on:
		on = false
		$pivot/buddybuddy/AnimationPlayer.play("Idle")
		await get_tree().create_timer($pivot/buddybuddy/AnimationPlayer.current_animation_length).timeout
		olhar = randi_range(1,10)
		print(olhar)
		on = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("direita", "esquerda", "baixo", "cima")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor() and anima == false:
				$pivot/buddybuddy/AnimationPlayer.play("Walk")
				
	#if Input == null:
		#var olhar_camera = randi_range(1,20)
		#await $buddybuddy/AnimationPlayer.animation_finished
		#if olhar_camera == 20:
			#$buddybuddy/AnimationPlayer.play("IdleAnim2")
			#await get_tree().create_timer(2).timeout
			#olhar_camera = randi_range(1,20)
		#if olhar_camera != 20:
			#$buddybuddy/AnimationPlayer.play("Idle")
			#print(olhar_camera)
			#await get_tree().create_timer(2).timeout
			#olhar_camera = randi_range(1,20)
	else:
	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
func virar(delta):
	pivot.rotation.y = lerp_angle(pivot.rotation.y,rotato,velo_rotato * delta)

func animation(delta):
	#if is_on_floor():
		if Input.is_action_pressed("cima"):
			rotato = deg_to_rad(0)
			virar(delta)
			if Input.is_action_pressed("esquerda"):
				rotato = deg_to_rad(45)
				virar(delta)
			if Input.is_action_pressed("direita"):
				rotato = deg_to_rad(-45)
				virar(delta)
		if Input.is_action_pressed("baixo"):
			rotato = deg_to_rad(180)
			virar(delta)
			if Input.is_action_pressed("esquerda"):
				rotato = deg_to_rad(135)
				virar(delta)
			if Input.is_action_pressed("direita"):
				rotato = deg_to_rad(-135)
				virar(delta)
		if Input.is_action_pressed("esquerda"):
			rotato = deg_to_rad(90)
			virar(delta)
		if Input.is_action_pressed("direita"):
			rotato = deg_to_rad(-90)
			virar(delta)
		else:
			virar(delta) 
			
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"pos_z" : position.z,
		"vida_atual" : GameDb.vida,
	}
	return save_dict


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		fase = 1
	pass # Replace with function body.


func _on_area_3d_2_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		fase = 0
