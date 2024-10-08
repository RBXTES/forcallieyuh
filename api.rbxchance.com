server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name api.rbxchance.com;
        #root /usr/share/nginx/html;

        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        location /socket.io/ {
                proxy_http_version 1.1;

                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";

                proxy_pass "http://localhost:5000/socket.io/";
        }

        location / {
                proxy_pass "http://localhost:5000/";
        }

        error_page 404 /404.html;
                location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
                location = /50x.html {
        }
}
