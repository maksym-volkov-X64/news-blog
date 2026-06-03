import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'PAYLOAD_API_URL', obfuscate: true)
  static final String payloadApiUrl = _Env.payloadApiUrl;

  @EnviedField(varName: 'PAYLOAD_API_KEY', obfuscate: true)
  static final String payloadApiKey = _Env.payloadApiKey;
}
