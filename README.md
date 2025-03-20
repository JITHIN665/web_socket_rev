# web_socket_rev

Any easy-to-use library for communicating with WebSockets
  that has multiple channels.

### Deployment targets

- iOS 13.0 and above
- Android 6.0 and above
- Web Chrome/Edge/Firefox/Safari.

## 🚀 Features

✅ Connects to a WebSocket server  

✅ Supports authentication  

✅ Listens to messages and **notifies listeners**  

✅ **Automatically reconnects** on failure  

✅ Provides **a message stream** for UI updates  

## Installation

To integrate the plugin in your Flutter App, you need
to add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
    web_socket_rev: ^1.0.0
```


## Initialization

Create an instance of WebSocketService by passing:

- webSocketUrl → The WebSocket server URL
- authUrl → API endpoint for authentication
- channelName → The channel you want to subscribe to

```dart
final webSocketService = WebSocketService(
  webSocketUrl: 'wss://your-websocket-server.com', 
  authUrl: 'https://your-auth-api.com/authenticate',
  channelName: 'inbox.user123',
);

```

## Listen to WebSocket Events

You can listen for incoming messages by setting a callback function:


```dart
webSocketService.setOnEventReceivedCallback((message) {
  print("Received Message: $message");
});

```

## Handling Reconnects

If the connection is lost, the package will automatically try to reconnect every 2 seconds.

If you want to manually reconnect, call:


```dart
webSocketService.reconnect();

```

## Closing the Connection

When you're done, always close the WebSocket connection:


```dart
webSocketService.close();

```
## Full Example (Flutter UI)

This example shows a Flutter screen that:

✅ Connects to the WebSocket server

✅ Displays incoming messages in a ListView

✅ Automatically updates when new messages arrive

```dart
import 'package:flutter/material.dart';
import 'package:web_socket/web_socket.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WebSocket Example',
      home: WebSocketExampleScreen(),
    );
  }
}

class WebSocketExampleScreen extends StatefulWidget {
  @override
  _WebSocketExampleScreenState createState() => _WebSocketExampleScreenState();
}

class _WebSocketExampleScreenState extends State<WebSocketExampleScreen> {
  late WebSocketService _webSocketService;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    
    _webSocketService = WebSocketService(
      webSocketUrl: 'wss://your-websocket-server.com',
      authUrl: 'https://your-auth-api.com/authenticate',
      channelName: 'inbox.user123',
    );

    _webSocketService.setOnEventReceivedCallback((message) {
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  void dispose() {
    _webSocketService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Messages')),
      body: messages.isEmpty
          ? Center(child: Text("No messages yet..."))
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
    );
  }
}

);

```

## Debugging & Logs

To debug connection errors, wrap WebSocket calls in a try-catch block:


```dart
try {
  _webSocketService.connect();
} catch (e) {
  print("WebSocket Error: $e");
}


```


## **🤝 Contributing**

If you encounter any bugs or have feature requests, feel free to open an issue on the [GitHub repository](https://github.com/JITHIN665/web_socket_rev).

---



## License

web_socket_rev is released under the MIT license. See [LICENSE](https://github.com/JITHIN665/web_socket_rev/blob/main/LICENSE) for details.
