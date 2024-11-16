
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static initEnviroment() async {
    const env = String.fromEnvironment('FLUTTER_ENV', defaultValue: '.env.local');
    print('Loading environment file: $env');
    await dotenv.load(fileName: env);
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'No esta configurado el API_URL';

}