import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class WebSocketService {
  /// WebSocket instance
  late WebSocket _webSocket;

  /// StreamController to handle incoming messages
  final StreamController<String> _messageController = StreamController<String>.broadcast();

  /// WebSocket and Authentication URL
  final String webSocketUrl;
  final String authUrl;

  /// Channel name
  final String channelName;

  /// Callback function for event handling
  Function(String)? onEventReceived;

  WebSocketService({
    required this.webSocketUrl,
    required this.authUrl,
    required this.channelName,
  }) {
    connect();
  }

  void setOnEventReceivedCallback(Function(String) callback) {
    onEventReceived = callback;
  }

  /// Connect to WebSocket server
  void connect() async {
    try {
      _webSocket = await WebSocket.connect(webSocketUrl);

      _webSocket.listen(
        (message) async {
          var event = jsonDecode(message);

          if (event['event'] == 'pusher:connection_established') {
            var data = jsonDecode(event['data']);
            String socketId = data['socket_id'];
            Response response = await _authenticateWebSocket(socketId, channelName);

            _webSocket.add(
              '{"event":"pusher:subscribe","data":{"auth":"${response.data['auth']}","channel":"$channelName"}}',
            );
          }

          Map<String, dynamic> outerMap = jsonDecode(message);
          if (outerMap['data'] != null) {
            Map<String, dynamic> innerMap = jsonDecode(outerMap['data']);

            if (innerMap['type'] != null) {
              onEventReceived?.call(jsonEncode(innerMap));
            }
          }

          _messageController.add(message);
        },
        onDone: () => reconnect(),
      );
    } catch (e) {
      print("ERROR: $e");
      reconnect();
    }
  }

  Future<Response> _authenticateWebSocket(String socketId, String channelName) async {
    Dio dio = Dio();
    return await dio.post(
      authUrl,
      data: {'socket_id': socketId, 'channel_name': channelName},
    );
  }

  /// Reconnect WebSocket on error
  void reconnect() async {
    await Future.delayed(const Duration(seconds: 2));
    connect();
  }

  /// Close WebSocket connection
  void close() {
    _webSocket.close();
  }

  /// Get message stream
  Stream<String> get messages => _messageController.stream;
}
