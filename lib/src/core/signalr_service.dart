import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  // 初始化 SignalR 连接
  static Future<HubConnection> initSignalR() async {
    var hubConnection = HubConnectionBuilder()
        .withUrl("http://localhost:5597/chatHub") // 替换为后端的 URL
        .build();

    // 监听来自 SignalR 的消息
    hubConnection.on("ReceiveMessage", (args) {
      print("Message received from ${args?[0]}: ${args?[1]}");
    });

    try {
      await hubConnection.start();
      print("SignalR connected!");
      return hubConnection;
    } catch (e) {
      print("Error connecting to SignalR: $e");
      throw e;
    }
  }

  // 发送消息
  Future<void> sendMessage(String userId, String message) async {
    //try {
    //await hubConnection.invoke("SendMessage", args: [userId, message]);
    // } catch (e) {
    //  print("Error sending message: $e");
    // }
  }
}
