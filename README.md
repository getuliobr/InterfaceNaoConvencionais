# Agente virtual do Otto

Trabalho desenvolvido para disciplina PPGCC22 - Interfaces Não Convencionais.

Desenvolvido pelos alunos:
- Amanda Ferrari
- Emica O. Costa
- Getúlio C. Regis
- Victor Daniel M. Pires

# Como executar

É necessário criar um certificado para o SSL com os seguintes comandos:

```bash
cd Server
openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes
```

Com a chave criada podemos executar o servidor (é bem provavel precisar trocar o IP do servidor HTTP), se mantendo na pasta Server, com o seguinte comando:
```bash
python index.py
```

E em seguida é necessário abrir o servidor em um celular e importar e executar o projeto na Godot 4.2.2, já vai ser possível movimentar o agente com o movimento do telefone.