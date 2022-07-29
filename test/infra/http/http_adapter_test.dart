import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart';

import 'package:tdd_clean_arch/data/http/http.dart';

class HttpAdapter implements HttpClient {
  Client client;
  HttpAdapter(this.client);

  @override
  Future<dynamic> request(
      {required String url, required String method, Map? body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);
    return response.body.isEmpty ? null : jsonDecode(response.body);
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

    test('Should return data if post returns 200', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));
      final response = await sut.request(url: url, method: 'post');
      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response('', 200));
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });
  });
}
