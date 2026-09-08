import 'package:desafio_orbytis/app/app.dart';
import 'package:desafio_orbytis/core/storage/secure_storage_service.dart';
import 'package:desafio_orbytis/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(secureStorageService: SecureStorageService())
                ..checkAuth(),
        ),
      ],
      child: MainApp(),
    ),
  );
}
