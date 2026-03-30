import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServiceSpecificSalesmanTrack {
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

  void onReceiveSalesmanSpecificData(Function(Map<String, dynamic>) callback) {
    socket.on("salesmanTrackingData", (data) {
      print("got dataaaaaaaaaaaa");

      if (data is Map<String, dynamic>) {
        callback(data);
        print("📡 Received specific salesman data => $data");
      } else {
        print("⚠️ Unexpected data format: ${data.runtimeType} => $data");
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
