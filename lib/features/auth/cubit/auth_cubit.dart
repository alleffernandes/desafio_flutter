import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/secure_storage_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SecureStorageService _secureStorageService;

  AuthCubit({required SecureStorageService secureStorageService})
    : _secureStorageService = secureStorageService,
      super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    try {
      final token = await _secureStorageService.readToken();
      if (token != null && token.isNotEmpty) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> setAuthenticated(String token) async {
    emit(AuthLoading());
    await _secureStorageService.saveToken(token);
    emit(Authenticated());
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _secureStorageService.deleteToken();
    emit(Unauthenticated());
  }
}
