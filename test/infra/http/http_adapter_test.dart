import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart';

class HttpAdapter {
  Client client;
  HttpAdapter(this.client);

  Future<void>? request(
      {required String url, required String method, Map? body}) async {
    await client.post(Uri.parse(url));
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late String url;
  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('POST', () {
    test('Should call post with correct values', () async {
      final client = ClientSpy();
      final sut = HttpAdapter(client);
      when(() => client.post(any())).thenAnswer((_) async => Response('{}', 200));
      await sut.request(url: url, method: 'post');
      verify(() => client.post(Uri.parse(url)));
    });
  });
}
