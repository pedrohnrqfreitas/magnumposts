Magnum Posts
📱 Aplicativo Flutter para Posts com Firebase
Aplicativo móvel desenvolvido em Flutter para visualização de posts com autenticação via Firebase e perfis de usuário personalizáveis.
Sumário

🎯 Objetivo
🛠️ Tecnologias Utilizadas
📋 Funcionalidades
🔧 Configuração do Projeto

🔥 Configuração do Firebase
📦 Instalação das Dependências


🚀 Como Executar o Projeto
🧪 Como Executar os Testes
🏗️ Arquitetura
👤 Usuários para Teste
📱 Como Usar o App
📄 Estrutura do Projeto

🎯 Objetivo
Desenvolver um aplicativo móvel em Flutter que demonstre conhecimentos em:

Autenticação Firebase (Email/Senha)
Consumo de APIs REST (JSONPlaceholder)
Gerenciamento de estado com BLoC
Armazenamento de dados no Firestore
Clean Architecture
Testes automatizados

🛠️ Tecnologias Utilizadas

Flutter 3.29.0+
Dart 3.9.0+
Firebase Authentication - Autenticação de usuários
Cloud Firestore - Banco de dados NoSQL
Dio - Cliente HTTP para consumo de APIs
BLoC - Gerenciamento de estado
Provider - Injeção de dependências
Shared Preferences - Armazenamento local
Cached Network Image - Cache de imagens
Mocktail - Mocks para testes
JSONPlaceholder API - API pública de posts

📋 Funcionalidades
✅ Autenticação

Login com email e senha
Registro de novos usuários
Logout com confirmação
Persistência de sessão

✅ Posts

Listagem de posts com paginação (10 por vez)
Visualização de detalhes do post
Carregamento automático ao fazer scroll
Pull-to-refresh
Indicadores de loading

✅ Perfis de Usuário

Criação de perfil personalizado
Edição de informações (nome, idade, interesses)
Visualização de estatísticas
Avatar gerado automaticamente
Armazenamento no Firestore

✅ Interface

Design responsivo e moderno
Animações de loading (skeleton)
Estados de erro com retry
Navegação intuitiva

🔧 Configuração do Projeto
🔥 Configuração do Firebase

Criar projeto no Firebase Console:

Acesse Firebase Console
Clique em "Adicionar projeto"
Nomeie o projeto como "magnum-posts-app"


Configurar Authentication:

Vá em Authentication > Sign-in method
Habilite "Email/Password"


Configurar Firestore:

Vá em Firestore Database > Criar banco de dados
Escolha "Iniciar no modo de teste"
Selecione uma localização


Configurar aplicativos:

Adicione um app Android com package com.example.magnumposts
Baixe o google-services.json e coloque em android/app/
Adicione um app iOS com bundle ID com.example.magnumposts
Baixe o GoogleService-Info.plist e coloque em ios/Runner/



📦 Instalação das Dependências
bash# Clone o repositório
git clone <repository-url>
cd magnumposts

# Instale as dependências
flutter pub get

# Configure o Firebase CLI (se necessário)
flutter pub global activate flutterfire_cli
flutterfire configure
🚀 Como Executar o Projeto
Android
bash# Conecte um dispositivo Android ou inicie um emulador
flutter devices

# Execute o app
flutter run
iOS
bash# Navegue até a pasta iOS e instale pods
cd ios
pod install
cd ..

# Execute o app
flutter run
Desenvolvimento
bash# Executar em modo debug com hot reload
flutter run --debug

# Executar em modo release
flutter run --release

# Limpar cache e rebuild
flutter clean
flutter pub get
flutter run
🧪 Como Executar os Testes
Testes Unitários
bash# Executar todos os testes
flutter test

# Executar testes com coverage
flutter test --coverage

# Executar testes específicos
flutter test test/features/authentication/
flutter test test/features/posts/
flutter test test/features/profile/

# Executar teste específico
flutter test test/features/authentication/ui/bloc/auth_bloc_test.dart
Testes de Integração
bash# Executar testes de integração do fluxo de posts
flutter test test/post_flow_integration_tests.dart
Verificar Coverage
bash# Gerar relatório de coverage (requer lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
🏗️ Arquitetura
O projeto segue Clean Architecture com separação clara de responsabilidades:
📁 Estrutura de Camadas
lib/
├── core/                   # Núcleo da aplicação
│   ├── constants/         # Constantes da app
│   ├── di/               # Injeção de dependências
│   ├── errors/           # Tratamento de erros
│   ├── navigation/       # Navegação
│   ├── services/         # Serviços (Firebase, HTTP)
│   └── widgets/          # Widgets reutilizáveis
├── data/                  # Camada de dados
│   ├── authentication/   # Dados de autenticação
│   ├── posts/           # Dados de posts
│   └── profile/         # Dados de perfil
├── features/             # Funcionalidades
│   ├── authentication/  # Login/Registro
│   ├── home/           # Tela inicial
│   ├── posts/          # Listagem de posts
│   └── profile/        # Perfis de usuário
└── main.dart            # Ponto de entrada
🏛️ Padrões Utilizados

Repository Pattern - Abstração de fontes de dados
UseCase Pattern - Lógica de negócio isolada
BLoC Pattern - Gerenciamento de estado reativo
Dependency Injection - Inversão de dependências
Error Handling - Tratamento consistente de erros

🔄 Fluxo de Dados
UI → BLoC → UseCase → Repository → DataSource → API/Firebase
👤 Usuários para Teste
Contas Pré-configuradas
Para facilitar os testes, você pode criar as seguintes contas:
Email: teste@magnumbank.com
Senha: 123456

Email: admin@magnumbank.com  
Senha: admin123

Email: user@magnumbank.com
Senha: user123
Criação de Nova Conta

Na tela de login, toque em "Criar conta"
Preencha email, senha e confirmação
Opcionalmente adicione seu nome
Toque em "Criar Conta"
Após criação, será redirecionado para login

📱 Como Usar o App
1️⃣ Login/Registro

Abra o app e será apresentada a tela de login
Digite email e senha ou crie uma nova conta
Após autenticação, será redirecionado para a lista de posts

2️⃣ Navegação nos Posts

Scroll infinito: Role para baixo para carregar mais posts
Pull to refresh: Puxe para baixo para atualizar
Tap no post: Abre detalhes completos
Tap no avatar: Abre perfil do autor

3️⃣ Gerenciamento de Perfil

Criar perfil: Ao acessar um perfil inexistente, será oferecida a opção de criar
Editar perfil: Use o ícone de edição no perfil
Campos disponíveis: Nome, idade, interesses

4️⃣ Logout

Use o ícone de logout no canto superior direito
Confirme a ação no modal que aparece

📄 Estrutura do Projeto
Core (Núcleo)

Constants: Todas as constantes da aplicação (textos, dimensões, cores)
Services: Abstrações para Firebase, HTTP e Firestore
Error Handling: Sistema unificado de tratamento de erros
Navigation: Gerenciamento de rotas
DI: Configuração de injeção de dependências

Features (Funcionalidades)
Cada feature segue a estrutura:
feature/
├── ui/
│   ├── bloc/          # Estado da feature
│   ├── pages/         # Telas
│   └── widgets/       # Componentes específicos
├── usecases/          # Casos de uso
└── models/           # Modelos de domínio
Data (Dados)
Cada módulo de dados contém:
data_module/
├── datasource/        # Fontes de dados (API, local)
├── dto/              # Objetos de transferência
├── models/           # Modelos de dados
└── repository/       # Implementação dos repositórios
Testes
test/
├── core/             # Testes dos serviços core
├── features/         # Testes por feature
├── helper/           # Utilitários de teste
└── integration/      # Testes de integração

📝 Observações de Desenvolvimento

O projeto usa Material Design 3 com esquema de cores personalizado
Implementa responsividade para diferentes tamanhos de tela
Possui tratamento robusto de erros com fallbacks
Cache local para melhor performance
Skeleton loading para melhor UX
Testes abrangentes com alta cobertura

Para dúvidas ou sugestões, entre em contato através do repositório.