# web_socket_rev

🔥 Usage
Initialize WebSocket
dart
Copy
Edit
final webSocketService = WebSocketService(
  webSocketUrl: 'wss://your-websocket-server.com',
  authUrl: 'https://your-authentication-api.com/auth',
  channelName: 'inbox.user123',
);
Listen to Events
dart
Copy
Edit
webSocketService.setOnEventReceivedCallback((message) {
  print("Received: $message");
});
Close Connection
dart
Copy
Edit
webSocketService.close();
