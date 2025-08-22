# Magnum Posts

## 📱 Teste: Desenvolvedor Mobile Flutter (com Firebase)

Aplicativo móvel desenvolvido em Flutter para autenticação via OAuth, consumindo API pública do JSONPlaceholder.

## Sumário

- [🎯 Objetivo](#-objetivo)
- [📝 Especificações Técnicas](#-especificações-técnicas)
- [🏗️ Como Rodar o Projeto](#️-como-rodar-o-projeto)
- [🧪 Como Executar os Testes](#-como-executar-os-testes)
- [🏛️ Arquitetura](#️-arquitetura)
- [👥 Usuários para Teste](#-usuários-para-teste)
- [📱 Como Usar o App](#-como-usar-o-app)
- [📊 Critérios de Avaliação](#-critérios-de-avaliação)

## 🎯 Objetivo

Desenvolver um aplicativo móvel utilizando Flutter para autenticação via OAuth, consumindo de uma API pública.

## 📝 Especificações Técnicas

### 🔐 Autenticação OAuth (E-mail e Senha)

**Tecnologia:** Firebase Authentication com email e senha

**Funcionalidades:**
- Usuário apresentado a tela de login ao abrir o app
- Implementar autenticação via Firebase, retornando perfil do usuário (nome, e-mail e foto)
- Após login, app armazena sessão e redireciona para tela de listagem de posts
- Implementar logout, removendo sessão do Firebase e redirecionando para tela de login

### 📋 Tela de Listagem de Posts

**API:** JSONPlaceholder Posts API  
**Tecnologia:** Dio para requisições HTTP

**Funcionalidades:**
- Exibir lista dos posts retornados pela API, mostrando: Título (completo); Corpo (limitado a 100 caracteres com opção "Ver mais" se truncado)
- Carregar 10 posts por vez, utilizando widget para indicar carregamento

### 📄 Tela de Detalhes do Post

**Funcionalidades:**
- Ao clicar num post, app redireciona para página de detalhes do post
- Exibir: Título completo; Corpo completo; Autor do post
- Botão "Voltar" para retornar à listagem

### 👤 Tela de Detalhes do Perfil

**Funcionalidades:**
- Na tela de listagem de post, ao clicar no avatar do usuário, abrir detalhes do perfil
- Exibir informações que podem ser salvas manualmente no Firestore: Imagem (mock); Nome; Quantidade de posts; Idade; Gostos

### 🧪 Testes Automatizados

**Tecnologia:** Flutter Test, Mocktail

**Escopo de testes:**
- Testar serviço de interação com Firebase Authentication e Firestore
- Testar componentes de listagem e detalhes dos posts para garantir carregamento correto dos dados
- Mockar Firebase e API externa para testes unitários

## 🏗️ Como Rodar o Projeto

### 📱 Flutter

⚠️ Para rodar o projeto é necessário ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) e [Android Studio](https://developer.android.com/studio) ou [Xcode](https://developer.apple.com/xcode/) instalados.

1. Clone o projeto em uma pasta de sua preferência: `git clone <repository-url>`
2. Entre na pasta do repositório que acabou de clonar: `cd magnumposts`
3. Instale as dependências: `flutter pub get`
4. Configure o Firebase:
    - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
    - Habilite Authentication (Email/Password)
    - Configure Firestore Database
    - Baixe `google-services.json` (Android) e `GoogleService-Info.plist` (iOS)
5. Execute o comando: `flutter run`

### 🔥 Configuração do Firebase

Para configurar o Firebase no projeto:

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Crie um novo projeto com nome "magnum-posts-app"
3. Adicione um app Android com package `com.example.magnumposts`
4. Adicione um app iOS com bundle ID `com.example.magnumposts`
5. Baixe os arquivos de configuração e coloque nas pastas corretas:
    - `google-services.json` em `android/app/`
    - `GoogleService-Info.plist` em `ios/Runner/`
6. No Authentication, habilite "Email/Password"
7. No Firestore, crie database em modo de teste

## 🧪 Como Executar os Testes

### Testes Unitários

```bash
# Executar todos os testes
flutter test

# Executar testes com coverage
flutter test --coverage

# Executar testes específicos
flutter test test/features/authentication/ui/bloc/auth_bloc_test.dart
flutter test test/features/posts/ui/bloc/posts_bloc_test.dart
flutter test test/data/posts/repository/posts_repository_test.dart