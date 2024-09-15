import socket
import threading

class ProxyServer:
    def __init__(self, listen_host, listen_port, remote_host, remote_port):
        # Initialization of the proxy server with specified host and port settings
        self.listen_host = listen_host
        self.listen_port = listen_port
        self.remote_host = remote_host
        self.remote_port = remote_port
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.bind((self.listen_host, self.listen_port))
        self.server.listen(5)

    def handle_client(self, client_socket):
        # Create a connection to the remote server
        remote_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        remote_socket.connect((self.remote_host, self.remote_port))

        # Create two threads to forward data between client and remote server
        threading.Thread(target=self.forward_data, args=(client_socket, remote_socket)).start()
        threading.Thread(target=self.forward_data, args=(remote_socket, client_socket)).start()

    def forward_data(self, source, destination):
        # Forward data from source to destination
        while True:
            data = source.recv(4096)
            if not data:
                break
            destination.sendall(data)

    def start(self):
        # Start listening for incoming connections
        print(f"[*] Proxy server listening on {self.listen_host}:{self.listen_port}")
        while True:
            client_socket, addr = self.server.accept()
            print(f"[*] Accepted connection from {addr[0]}:{addr[1]}")

            # Handle the client in a separate thread
            threading.Thread(target=self.handle_client, args=(client_socket,)).start()

if __name__ == "__main__":
    # Create a ProxyServer instance and start listening for connections
    proxy_server = ProxyServer(listen_host="10.20.204.255", listen_port=8888, remote_host="www.gmail.com", remote_port=80)
    proxy_server.start()
