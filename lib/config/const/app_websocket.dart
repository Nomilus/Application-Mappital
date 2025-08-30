import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppWebsocket {
  final getIt = GetIt.instance;

  void get init {
    getIt.registerLazySingleton<WebSocketChannel>(
      () => WebSocketChannel.connect(Uri.parse(dotenv.env['API_URL'] ?? '')),
    );
  }
}
