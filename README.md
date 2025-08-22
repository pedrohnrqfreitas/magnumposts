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

# Executar testes de integração
flutter test test/post_flow_integration_tests.dart

# Gerar relatório de coverage
genhtml coverage/lcov.info -o coverage/html

🏛️ Arquitetura
O projeto utiliza Clean Architecture com BLoC Pattern para gerenciamento de estado.
Estrutura de Pastas
lib/
├── core/                    # Serviços e utilitários
│   ├── constants/          # Constantes da aplicação
│   ├── di/                # Injeção de dependências
│   ├── errors/            # Tratamento de erros
│   ├── services/          # Firebase, HTTP, Firestore
│   └── widgets/           # Widgets reutilizáveis
├── data/                   # Camada de dados
│   ├── authentication/    # Modelos e repositórios de auth
│   ├── posts/            # Modelos e repositórios de posts
│   └── profile/          # Modelos e repositórios de perfil
├── features/              # Funcionalidades
│   ├── authentication/   # Login e registro
│   ├── posts/           # Listagem e detalhes
│   └── profile/         # Perfil do usuário
└── main.dart             # Ponto de entrada

Padrões Utilizados

BLoC Pattern: Gerenciamento de estado recomendado
Repository Pattern: Abstração de fontes de dados
Clean Architecture: Separação de responsabilidades
Dependency Injection: Inversão de dependências

👥 Usuários para Teste
Contas Disponíveis
Email: admin@magnumbank.com
Senha: admin123

Email: teste@magnumbank.com
Senha: teste123

Email: user@magnumbank.com
Senha: user123
Criar Nova Conta

Na tela de login, toque em "Criar conta"
Preencha email, senha e confirmação
Opcionalmente adicione seu nome
Toque em "Criar Conta"

📱 Como Usar o App
Login/Registro

Abra o app e faça login com uma das contas de teste
Ou crie uma nova conta preenchendo os dados solicitados

Navegação nos Posts

Role para baixo para carregar mais posts (paginação automática)
Toque em um post para ver detalhes completos
Toque no avatar do autor para ver perfil

Gerenciamento de Perfil

Crie ou edite seu perfil através do avatar
Preencha informações como nome, idade e interesses
As informações são salvas no Firestore

Logout

Use o botão de logout no canto superior direito
Confirme a ação no modal de confirmação

📊 Critérios de Avaliação
Organização e Estrutura do Código

Uso de boas práticas de organização de pastas e arquivos
Nomeação clara e consistente de classes, métodos e variáveis
Separação adequada entre camadas (UI, Business Logic, Data Layer)

Qualidade do Código

Leitura e clareza do código
Uso de conceitos como SOLID, Clean Architecture
Redução de código desnecessário ou duplicado

Implementação de Funcionalidades

Funcionalidades entregues conforme requisitos definidos
Correção e completude na implementação das features
Uso de widgets Flutter para criar layouts e interações de forma eficiente

UX/UI

Experiência do usuário fluída e responsiva
Uso adequado de widgets

Gerenciamento de Estado

Escolha do gerenciamento de estado (recomendado BLoC)
Implementação eficiente e escalável do gerenciamento de estado
Atualização de UI sincronizada com as mudanças no estado

Conexão com APIs ou Banco de Dados

Configuração e consumo eficiente de APIs
Uso do Dio para chamadas HTTP
Implementação de Firestore para banco de dados

Tratamento de Erros

Implementação de mensagens de erro claras para o usuário
Tratamento de exceções e falhas de rede de forma robusta
Logs e debug claros no código

Testes

Cobertura de testes unitários e/ou de integração
Uso adequado de ferramentas como flutter_test
Implementação de testes automatizados para validar a lógica principal

Documentação

README claro, com instruções de execução e justificativas de escolhas técnicas
Comentários no código, explicando trechos complexos
Descrição de como expandir ou escalar a solução no futuro