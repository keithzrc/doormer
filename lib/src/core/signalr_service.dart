import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late final HubConnection hubConnection;

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
        .build();

    try {
      await hubConnection.start();
      print("SignalR connected!");
      return hubConnection;
    } catch (e) {
      AppLogger.error("Error connecting to SignalR:", e);
      throw e;
    }
  }

  // 发送消息
  Future<void> sendMessage(String userId, String message) async {
    try {
      await hubConnection.invoke("SendMessage", args: [userId, message]);
      AppLogger.debug('Message sent successfully');
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> login(String userId) async {
    try {
      await hubConnection.invoke("Login", args: [userId]);
    } catch (e) {
      AppLogger.error("Error to login: $e");
    }
  }
}
