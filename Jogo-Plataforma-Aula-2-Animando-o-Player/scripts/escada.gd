extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("entra_na_escada"):
		body.entra_na_escada()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("sai_da_escada"):
		body.sai_da_escada()
