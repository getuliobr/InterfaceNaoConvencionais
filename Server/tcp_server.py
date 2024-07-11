import socket
import threading

# Servidor TCP para comunicação da Godot com o servidor HTTP
class TCPServer():
  CLIENTS = []

  def start(self):
    print("Starting TCP server")
    # Cria o servidor TCP na porta 1111
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('127.0.0.1',1111))
    s.listen(10)
    # Sempre aceitar um cliente e criar um thread novo para ele
    while 1:
      client_socket, addr = s.accept()
      print(f'{addr[0]}:{addr[1]} connected')
      self.CLIENTS.append(client_socket)
      threading.Thread(target=self.handler, args=(client_socket, addr)).start() 

  # Metódo que cuida dos clientes
  def handler(self, client, addr):
    while True:
      data = client.recv(1024)
      if not data:
        self.CLIENTS.remove(client)
        break
      
  # Broadcast das mensagens para todos os clientes conectados
  def broadcast(self, message):
    for c in self.CLIENTS:
      try:
        c.send(message)
      except:
        self.CLIENTS.remove(c)