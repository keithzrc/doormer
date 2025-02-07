import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late final HubConnection hubConnection;
  String? _currentUserId;

  SignalRService._();

  static Future<SignalRService> create() async {
    final instance = SignalRService._();
    instance.hubConnection = await instance._initSignalR();
    return instance;
  }

  // 初始化 SignalR 连接
  Future<HubConnection> _initSignalR() async {
    var hubConnection = HubConnectionBuilder()
        .withUrl("http://localhost:5597/chatHub") // 替换为后端的 URL
        .withAutomaticReconnect() // 添加自动重连
        .build();

    try {
      await hubConnection.start();
      AppLogger.info("SignalR connected successfully");
      
      // 添加这些日志来追踪接收到的消息
      hubConnection.on("ReceiveMessage", (args) {
        AppLogger.info("SignalR raw message received: $args");
        if (args != null) {
          AppLogger.info("Message details - SenderId: ${args[0]}, Content: ${args[1]}");
        }
      });
      
      return hubConnection;
    } catch (e) {
      AppLogger.error("Error connecting to SignalR:", e);
      throw e;
    }
  }

  // 发送消息
  Future<void> sendMessage(String userId, String message) async {
    try {
      if (_currentUserId == null) {
        throw Exception('Not logged in');
      }
      
      if (hubConnection.state != HubConnectionState.Connected) {
        await hubConnection.start();
      }
      
      await hubConnection.invoke("SendMessage", args: [userId, message]);
      AppLogger.info("Message sent from $_currentUserId to $userId: $message");
    } catch (e) {
      AppLogger.error("Error sending message", e);
      throw e;
    }
  }

  Future<void> login(String userId) async {
    try {
      if (hubConnection.state != HubConnectionState.Connected) {
        AppLogger.info("Reconnecting SignalR...");
        await hubConnection.start();
      }
      
      _currentUserId = userId;
      await hubConnection.invoke("Login", args: [userId]);
      AppLogger.info("Successfully logged in as: $userId");
    } catch (e) {
      AppLogger.error("Error logging in to SignalR: $userId", e);
      _currentUserId = null;
      throw e;
    }
  }
}