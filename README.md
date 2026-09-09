# Desafio Orbytis

Este é um projeto Flutter desenvolvido para do desafio da Orbytis.

## 🚀 Como Rodar o App

1. Certifique-se de ter o Flutter SDK e o Android Studio configurados corretamente.
2. Clone o repositório e acesse a pasta do projeto.
3. Obtenha as dependências executando:
   ```bash
   flutter pub get
   ```
4. Conecte um dispositivo Android ou inicie um emulador.
5. Execute o aplicativo:
   ```bash
   flutter run
   ```

**Aviso:** O aplicativo foi desenvolvido e configurado exclusivamente para a plataforma Android

## Principais Configurações e Alterações

- **Android Apenas:** O app foi focado para rodar no Android.
- **API 37:** O projeto foi configurado com `compileSdk = 37` no `build.gradle.kts` para suportar adequadamente as dependências, como o `flutter_secure_storage`.
- **Tráfego HTTP:** Foi configurado o arquivo `network_security_config.xml` e referenciado no `AndroidManifest.xml` (`android:networkSecurityConfig`) para permitir requisições HTTP (tráfego em texto limpo), que não é suportado por padrão no Android 9 ou superior.
- **Permissões:** O `AndroidManifest.xml` inclui permissões para Internet, Câmera e Localização.

## Resumo dos Pacotes Utilizados

Os principais pacotes configurados no `pubspec.yaml` são:

- **flutter_bloc:** Gerenciamento de estado previsível.
- **dio:** Cliente HTTP poderoso para requisições de API.
- **go_router:** Roteamento declarativo e navegação.
- **get_it:** Service locator para injeção de dependências.
- **flutter_secure_storage:** Armazenamento seguro de dados locais (key-value).
- **sqflite:** Banco de dados SQLite para armazenamento estruturado.
- **geolocator:** Obtenção e manipulação da localização do dispositivo.
- **image_picker:** Seleção de imagens da galeria ou captura via câmera.
- **path_provider:** Acesso aos diretórios do sistema de arquivos.
