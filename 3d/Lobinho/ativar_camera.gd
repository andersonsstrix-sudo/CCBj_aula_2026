extends Area3D
@export var camera_caminho : NodePath
var camera
var alvo
@export var segue = false
# Called hen the node enters the scene tree for the first time.
func _ready() -> void:
	if camera_caminho != null:
		camera = get_node(camera_caminho)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if segue and alvo != null:
		camera.look_at(alvo.global_transform.origin,Vector3.UP)
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		alvo = body
		camera.current = true
