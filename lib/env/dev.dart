// import 'package:foriyana_app/env/env.dart';

// class DevEnv implements Env {
//   static const String appName = "MyApp (Dev)";
//   static const String baseUrl = "https://dev.api.example.com";
//   static const bool debug = true;
//   static const String publicAgentBaseUrl =
//       "https://agent-service.stg.friendsure.tech/v1";
//   static const String publicChannel = "9af5f0c6-6be3-4ef5-986d-21e4da84183e";

//   static final Env _instance = Env._internal();
//   factory Env() => _instance;

//   Env._internal();
// }
import 'env.dart';

class DevEnv implements Env {
  @override
  String get appName => "MyApp (Dev)";

  @override
  String get baseUrl => "https://dev.api.example.com";

  @override
  String get publicSsoBaseUrl =>
      "https://stg-sso-portal-3p59k.ondigitalocean.app";

  @override
  String get publicAgentBaseUrl =>
      "https://agent-service.stg.friendsure.tech/v1";

  @override
  String get publicAffiliateBaseUrl =>
      "https://stg-affiliate-service-nlkoa.ondigitalocean.app/v1";

  @override
  String get publicChannel => "9af5f0c6-6be3-4ef5-986d-21e4da84183e";

  @override
  String get mode => "gelm";

  @override
  bool get debug => true;
}
