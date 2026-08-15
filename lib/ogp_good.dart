import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:ogp_good/og.dart';

class OgpGood {
  static Future<Og> get(Uri url, {http.Client? client}) async {
    final httpClient = client ?? http.Client();

    try {
      final response = await httpClient.get(url);
      final body = response.body;

      return _parse(body);
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }

  static Og _parse(String body) {
    final document = parse(body);

    String? contentOf(String property) {
      return document
          .querySelector('meta[property="$property"]')
          ?.attributes['content'];
    }

    return Og(
      title: contentOf('og:title'),
      type: contentOf('og:type'),
      url: contentOf('og:url'),
      image: contentOf('og:image'),
    );
  }
}
