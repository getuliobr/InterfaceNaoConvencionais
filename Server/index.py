import logging, ssl, threading
from http.server import SimpleHTTPRequestHandler, HTTPServer
from tcp_server import TCPServer


logging.basicConfig()

# Inicia o servidor TCP
tcp = TCPServer()
threading.Thread(target=tcp.start, args=()).start()

# Configura o SSL
ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ssl_context.load_cert_chain(certfile='./server.pem')

# Criando um servidor HTTP basico em python
class Server(SimpleHTTPRequestHandler):
  # Tratamento da requisição POST
  def do_POST(self):
    content_length = int(self.headers['Content-Length'])
    post_data = self.rfile.read(content_length)
    # Faz o broadcast dos dados recebidos no POST
    tcp.broadcast(len(post_data).to_bytes(1, 'big') + post_data)

# Trocar para o IP da máquina
httpd = HTTPServer(("192.168.0.11", 5000), Server)
# Ativa o SSL para poder criar uma página HTTPS
httpd.socket = ssl_context.wrap_socket(httpd.socket, server_side=True)
# Iniciar o servidor HTTP
httpd.serve_forever()