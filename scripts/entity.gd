extends CharacterBody2D
class_name Entity

## Função para fazer o wrap-around quando o asteróide sai da tela
func handle_screen_wrap():
	var screen_size = get_viewport_rect().size
	var margin = 64  # Define uma margem para o wrap-around

	if position.x > screen_size.x + margin:
		position.x = -margin  # Move o asteroide para fora do lado oposto
	elif position.x < -margin:
		position.x = screen_size.x + margin  # Move o asteroide para fora do lado oposto

	if position.y > screen_size.y + margin:
		position.y = -margin
	elif position.y < -margin:
		position.y = screen_size.y + margin
