#!/usr/bin/env python3

import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from cgi import parse_header
from urllib.parse import parse_qs

class Server(BaseHTTPRequestHandler):
    def do_GET(self):
        body = '<form action="" method="POST"><table><tr><th>Name</th><th>URL</th><th><th></tr>'
        body += '<tr><td><input type="text" name="name" placeholder="name"></td><td><input type="text" name="url" placeholder="url"></td><td><button type="submit" name="action" value="add">+</button></td></tr>'
        for name, url in subscriptions.items():
            body += '<tr><td>' + name + '</td><td>' + url + '</td><td><button type="submit" name="action" value="del_' + name + '">&times;</button><td></tr>'
        body += '</table></form>'
        self._sendResponse(200, bytes(body, 'utf-8'), contenttype='text/html')

    def do_POST(self):
        ctype, pdict = parse_header(self.headers['content-type'])
        if ctype != 'application/x-www-form-urlencoded':
            self._sendResponse(400, b'Bad Request')
            return

        length = int(self.headers['content-length'])
        qs = self.rfile.read(length).decode()
        postvars = parse_qs(qs, keep_blank_values=1)

        if not 'action' in postvars:
            self._sendResponse(400, b'Bad Request')
            return

        action = postvars['action'][0]
        print('action: %s' % (action))
        if action.startswith('del_'):
            name = action[4:]
            print('name: %s' % (name))
            del subscriptions[name]
        elif action == 'add':
            name = postvars['name'][0]
            url = postvars['url'][0]
            print('name: %s' % (name))
            print('url: %s' % (url))
            if len(name) == 0 or len(url) == 0:
                self._sendResponse(400, b'Bad Request')
                return
            subscriptions[name] = url
        else:
            self._sendResponse(400, b'Bad Request')
            return

        saveSubscriptions()
        self.send_response(302)
        self.send_header('Location', '.')
        self.end_headers()

    def _sendResponse(self, code, body, contenttype = 'text/plain'):
        self.send_response(code)
        self.send_header('Content-type', contenttype)
        self.end_headers()
        self.wfile.write(body)

def saveSubscriptions():
    global subscriptions
    print('saving subscriptions...')
    subscriptions = {k: subscriptions[k] for k in sorted(subscriptions)}
    with open('_subscriptions.txt', mode='w') as f:
        for name, url in subscriptions.items():
            f.write(name + ';' + url + '\n')

subscriptions = {}

def run(server_class=HTTPServer, handler_class=Server, port=80):
    print('loading subscriptions...');
    with open('_subscriptions.txt') as f:
        content = f.readlines()
        for line in content:
            name, url = line.strip().split(';')
            subscriptions[name] = url
    print('Starting httpd...')
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == "__main__":
    try:
        if len(sys.argv) == 2:
            run(port=int(sys.argv[1]))
        else:
            run()
    except KeyboardInterrupt as e:
        print(e)
