import 'package:dio/dio.dart';

class AuthService {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
      connectTimeout: const Duration(seconds: 5),
    ),
  );

  Future<void> fazerLogin(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];
        final userName = response.data['user']['name'];

        print('Login de sucesso! Bem-vindo(a), $userName');
        print('Token salvo: $accessToken');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          throw Exception('E-mail ou senha inválidos.');
        } else {
          throw Exception('Erro no servidor: ${e.response?.statusCode}');
        }
      } else {
        throw Exception('Erro de conexão: verifique se a API está rodando.');
      }
    }
  }
}
