extends Spatial

export(PackedScene) var projectile : PackedScene
export var rotate_spd := -360.0
onready var mesh_instance: MeshInstance = $MeshInstance


func _ready() -> void:
	mesh_instance.scale = Vector3.ZERO
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(mesh_instance, "scale", Vector3.ONE * 1.5, 0.5)


func _process(delta: float) -> void:
	mesh_instance.rotation_degrees.y += rotate_spd * delta


func shoot_at(target_pos: Vector3, amount: int = 3, speed: float = 30.0, spread_angle: float = deg2rad(30.0), inverse_angle: bool = false, accel: float = 0.0) -> void:
	var lerp_offset := 1.0/(float(amount)+1.0)
	var dir := global_translation.direction_to(target_pos)
	for i in range(amount):
		var proj_inst : Node = projectile.instance()
		var proj_angle : float = lerp(-spread_angle/2, spread_angle/2, (i+1)*lerp_offset)
		var rotated_vector := dir.rotated(Vector3.UP, proj_angle)
		if inverse_angle:
			rotated_vector = rotated_vector.rotated(Vector3.UP, PI)
		proj_inst.life_time = 1.5 if accel == 0.0 else 0.5
		get_tree().current_scene.add_child(proj_inst)
		proj_inst.global_translation = global_translation
		proj_inst.velocity = rotated_vector * speed if accel == 0.0 else rotated_vector
		proj_inst.accel = accel
