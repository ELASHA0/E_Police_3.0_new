import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServiceSalesmanTrack {
  late IO.Socket socket;

  void connect(String token) {
    socket = IO.io(
      "https://salestrack.rocketsalestracker.com",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()   // manual connect
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print("✅ Connected to socket server from salesman track");
      // authenticate(token);
    });

    socket.onDisconnect((_) {
      print("❌ Disconnected from socket server");
    });

    socket.onConnectError((err) {
      print("⚠️ Socket connect error: $err");
    });

    socket.onAny((event, data) {
      print("📡 Event: $event => $data");
    });
  }

  void onReceive(Function(List<dynamic>) callback) {
    socket.on("liveSalesmanData", (data) {
      if (data is List) {
        callback(data);
        // print("📡 Received salesman list => $data");
      } else {
        // print("⚠️ Unexpected data format: $data");
      }
    });
  }

  void authenticate(String token) {
    print("🔑 Sending authenticate event with token...");
    socket.emit('authenticate', token);
  }

  void requestSalesmanTracking(String salesmanId) {
    print("📡 Sending requestSalesmanTracking event...");
    socket.emit('requestSalesmanTracking', salesmanId);
  }

  void dispose() {
    socket.dispose();
    print("🔌 Socket disposed");
  }
}
