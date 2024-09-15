import socket

class ProxyClient:
    def __init__(self, proxy_host, proxy_port):
        self.proxy_host = proxy_host
        self.proxy_port = proxy_port
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def connect_to_proxy(self):
        self.client.connect((self.proxy_host, self.proxy_port))

    def send_request(self, data):
        self.client.sendall(data.encode('utf-8'))

    def receive_response(self):
        response = self.client.recv(4096).decode('utf-8')
        print(f"[*] Received response from proxy: {response}")

    def close(self):
        self.client.close()

if __name__ == "__main__":
    proxy_client = ProxyClient(proxy_host="10.20.204.255", proxy_port=8888)
    proxy_client.connect_to_proxy()

    # Example HTTP GET request
    request = "GET / HTTP/1.1\r\nHost: www.gmail.com\r\n\r\n"
    proxy_client.send_request(request)
    proxy_client.receive_response()

    proxy_client.close()


