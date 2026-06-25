# Arquivo menu_inicial.gd
extends Control

# função que executa ao receber o sinal de botão clicado,
# enviando para a cena do jogo
func _on_jogar_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
