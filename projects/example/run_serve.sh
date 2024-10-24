#!/bin/bash

# Check if index.html exists
if [[ ! -f "index.html" ]]; then
  echo "Error: index.html not found."
  echo "Please run './run_generate.sh' to create index.html first."
  exit 1
fi

echo "Server is running. Visit http://localhost:8000"
echo "Press CTRL+C to stop the server."

# Start the server
while true; do
  {
    echo -e 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n'; cat index.html;
  } | nc -l -p 8000 -q 1;
done
