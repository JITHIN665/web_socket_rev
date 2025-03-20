// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:web_socket_rev/web_socket.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'WebSocket Example', home: WebSocketExampleScreen());
  }
}

class WebSocketExampleScreen extends StatefulWidget {
  const WebSocketExampleScreen({super.key});

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
      authUrl: 'https://your-authentication-api.com/auth',
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
      appBar: AppBar(title: Text('WebSocket Example')),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(messages[index]));
        },
      ),
    );
  }
}
