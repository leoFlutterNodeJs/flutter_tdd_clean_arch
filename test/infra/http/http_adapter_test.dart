import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart';

class HttpAdapter {
  Client client;
  HttpAdapter(this.client);

  Future<void>? request(
      {required String url, required String method, Map? body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    await client.post(Uri.parse(url), headers: headers, body: jsonBody);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late String url;
  late ClientSpy client;
  late HttpAdapter sut;
  late Map<String, String> headers;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    headers = {'content-type': 'application/json', 'accept': 'application/json'};
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('POST', () {
    test('Should call post with correct values', () async {
      when(() => client.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => Response('{}', 200));
      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});
      verify(() => client.post(Uri.parse(url), headers: headers, body: '{"any_key":"any_value"}'));
    });

    test('Should call post without body', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response('{}', 200));
      await sut.request(url: url, method: 'post');
      verify(() => client.post(any(), headers: any(named: 'headers')));
    });
  });
}
