# Godot Space Adventure

Jogo desenvolvido na engine Godot 4.3 com comunicação back-end via Express.js para gerenciamento de dados de jogadores.

## Features

- [x] Autenticação de jogadores pelo nome.
- [x] Recuperação de dados do jogador (pontuação, inimigos destruídos, etc.).
- [x] Registro de pontuações com envio de dados ao servidor.
- [ ] Implementação de conquistas e patentes baseadas em experiência.
- [ ] Ranking global de jogadores.
- [ ] Personalização de avatar e cores.
- [ ] Integração com ranking semanal/mensal.

## Comunicação com o Servidor

A comunicação entre o jogo e o servidor é feita usando `HTTPRequest` da Godot 4.3. Para mais detalhes, veja a [documentação oficial do Godot sobre HTTPRequest](https://docs.godotengine.org/en/stable/classes/class_httprequest.html).

## Links Importantes

- [Repositório do Servidor Back-end](https://github.com/luisfpatrocinio/patroAsteroidsBackEnd)
- [Página Front-End](https://github.com/luisfpatrocinio/patroAsteroidsPage)
