#!/bin/bash

declare -a sites
for key in $(compgen -e); do
  if [[ $key = SITES* ]] ; then
    sites=( ${sites[@]} ${!key} )
  fi
done

for site in ${sites[@]}; do 
  echo "${site[0]}"
done

if [ ${#sites} -eq 0 ]; then
  echo "No SITE variable(s)"
  exit 1
fi

echo "URL: $URL"

cat > /usr/share/nginx/html/index.html <<EOF
<html>
  <head>
    <style>
      .flex img {
        width: 256px;
        height: 256px;
      }
      .flex {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
      }
    </style>
  </head>
  <body>
    <div class='flex'>
EOF

for site in "${sites[@]}"
do
  IFS='|' read -r -a parts <<< "$site"
  printf "%s - %s\n" "${parts[0]}" "${parts[1]}"
  echo "      <div title='${parts[0]}'><a href='$URL:${parts[2]}'><img src='${parts[1]}'></a></div>" >> /usr/share/nginx/html/index.html
  cat > "/etc/nginx/conf.d/${parts[0]}.conf" <<EOF
upstream ${parts[0]} {
  server ${parts[3]};
}

server {
  listen ${parts[2]} ssl;

  ssl_certificate certs/cert.pem;
  ssl_certificate_key certs/key.pem;
  ssl_client_certificate clients/opsca-cert.pem;
  ssl_crl clients/opsca.crl;
  ssl_verify_client on;

  location / {
    proxy_pass http://${parts[0]};
  }
}
EOF
done

cat >> /usr/share/nginx/html/index.html <<EOF
    </div>
  </body>
</html>
EOF

cat > /etc/nginx/conf.d/default.conf <<EOF
server {
  listen 80;
  root /usr/share/nginx/html;

  location / {
    return 301 $URL\$request_uri;
  }
  location /elb {
    root /usr/share/nginx/html;
  }
}

server {
  listen 443 ssl;
  root /usr/share/nginx/html;

  ssl_certificate certs/cert.pem;
  ssl_certificate_key certs/key.pem;
  ssl_client_certificate clients/opsca-cert.pem;
  ssl_crl clients/opsca.crl;
  ssl_verify_client on;

  location / {
    try_files \$uri /index.html;
  }
}
EOF