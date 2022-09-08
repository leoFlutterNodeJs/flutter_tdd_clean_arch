import '../../../domain/usecases/usecases.dart';

import '../../../data/usecases/usecases.dart';

import '../factories.dart';

Authentication makeRemoteAuthentication() => RemoteAuthentication(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('login'),
    );
