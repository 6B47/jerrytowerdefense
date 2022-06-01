extends "res://entities/enemies/states/move.gd"


func update(delta: float) -> void:
	super.update(delta)
	(owner as Tank).shooter.gun.rotation = lerp_angle(
			(owner as Tank).shooter.gun.rotation, 
			(owner as Tank).velocity.angle(),
			(owner as Tank).shooter.rot_speed * delta)
	if (owner as Tank).is_raycast_colliding():
		emit_signal("finished", "idle")


func _on_detector_body_entered(body: Node2D) -> void:
	if not body in (owner as Tank).shooter.targets:
		(owner as Tank).shooter.targets.append(body)
		emit_signal("finished", "shoot")
