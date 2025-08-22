# 📱 Magnum Posts

Aplicativo móvel desenvolvido em Flutter para o desafio técnico do Magnum Bank. Uma aplicação completa de posts com autenticação Firebase, consumo de API externa e gerenciamento de perfis de usuário.

## 🚀 Funcionalidades

### ✅ Autenticação
- Login com email e senha via Firebase Authentication
- Registro de novos usuários
- Gerenciamento automático de sessão
- Logout com confirmação

### ✅ Posts
- Listagem de posts da API JSONPlaceholder
- Paginação automática (10 posts por vez)
- Visualização de detalhes completos do post
- Carregamento progressivo com pull-to-refresh
- Exibição de autor com informações do usuário

### ✅ Perfis de Usuário
- Criação de perfil personalizado no Firestore
- Edição de informações pessoais (nome, idade, interesses)
- Visualização de estatísticas do perfil
- Avatar automático baseado no ID do usuário

### ✅ Interface
- Design moderno seguindo Material Design 3
- Skeleton loading para melhor UX
- Estados de loading, erro e vazio
- Animações suaves e responsivas

## 🏗️ Arquitetura

O projeto foi desenvolvido seguindo os princípios da **Clean Architecture** com separação clara de responsabilidades:

```
lib/
├── core/                     # Núcleo da aplicação
│   ├── constants/           # Constantes e configurações
│   ├── di/                  # Injeção de dependências
│   ├── errors/              # Tratamento de erros
│   ├── navigation/          # Navegação e rotas
│   ├── services/            # Serviços externos (Firebase, HTTP)
│   └── widgets/             # Widgets reutilizáveis
├── data/                    # Camada de dados
│   ├── authentication/      # Dados de autenticação
│   ├── posts/              # Dados de posts
│   └── profile/            # Dados de perfil
└── features/               # Funcionalidades da aplicação
    ├── authentication/     # Autenticação (BLoC + UI)
    ├── posts/             # Posts (BLoC + UI)
    └── profile/           # Perfil (BLoC + UI)
```

### Camadas da Arquitetura

1. **Presentation Layer** (features/*/ui/)
   - BLoC para gerenciamento de estado
   - Widgets e páginas da interface
   - Eventos e estados bem definidos

2. **Domain Layer** (features/*/usecase/)
   - Use Cases para regras de negócio
   - Interfaces de repositórios
   - Modelos de domínio

3. **Data Layer** (data/)
   - Implementação de repositórios
   - Data sources (local e remoto)
   - DTOs e mapeamentos

4. **Core Layer** (core/)
   - Serviços compartilhados
   - Utilitários e constantes
   - Configurações globais

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.29.0** - Framework mobile
- **Dart 3.9.0** - Linguagem de programação
- **Firebase Auth** - Autenticação de usuários
- **Cloud Firestore** - Banco de dados NoSQL
- **Dio** - Cliente HTTP para consumo de APIs
- **BLoC** - Gerenciamento de estado reativo
- **Provider** - Injeção de dependências
- **Cached Network Image** - Cache de imagens
- **Shared Preferences** - Armazenamento local

### Dependências de Desenvolvimento
- **Flutter Test** - Framework de testes
- **Mocktail** - Biblioteca de mocks
- **BLoC Test** - Testes específicos para BLoCs

## 📋 Pré-requisitos

- Flutter SDK >= 3.29.0
- Dart SDK >= 3.9.0
- Android Studio / VS Code
- Conta no Firebase (já configurada no projeto)

## 🚀 Como Executar

### 1. Clone o repositório
```bash
git clone [URL_DO_REPOSITORIO]
cd magnumposts
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Execute o projeto
```bash
flutter run
```

## 👥 Usuários e Senhas

**O aplicativo permite criar novos usuários diretamente pela interface!**

### Como criar uma conta:
1. Abra o aplicativo
2. Na tela de login, toque em **"Criar conta"**
3. Preencha os dados:
   - Email válido
   - Senha (mínimo 6 caracteres)
   - Confirmação de senha
   - Nome (opcional)
4. Toque em **"Criar Conta"**
5. Após o sucesso, faça login com as credenciais criadas

### Usuários de exemplo (se necessário):
```
Email: usuario@teste.com
Senha: 123456

Email: demo@magnumposts.com  
Senha: demo123
```

## 🧪 Executando os Testes

O projeto possui uma suíte completa de testes cobrindo:
- ✅ Serviços Firebase (Auth + Firestore)
- ✅ Repositórios e Use Cases
- ✅ BLoCs (Estados e Eventos)
- ✅ Testes de Integração

### Comandos para testes:

```bash
# Executar todos os testes
flutter test

# Executar com relatório de cobertura
flutter test --coverage

# Executar testes específicos
flutter test test/feature/authentication/
flutter test test/feature/posts/
flutter test test/feature/profile/

# Testes de integração
flutter test test/post_flow_integration_tests.dart
```
## 🎯 Justificativas de Escolhas Técnicas

### Gerenciamento de Estado - BLoC Pattern
**Por que BLoC?**
- **Recomendação do desafio**: Especificamente solicitado no documento
- **Reatividade**: Stream-based, ideal para UIs dinâmicas
- **Testabilidade**: Separação clara entre lógica e UI facilita unit tests
- **Escalabilidade**: Permite gerenciar estados complexos sem acoplamento
- **Padrão do Google**: Amplamente adotado pela comunidade Flutter

### Arquitetura - Clean Architecture
**Por que Clean Architecture?**
- **Separação de Responsabilidades**: Cada camada tem uma função específica
- **Testabilidade**: Permite mockar dependências facilmente
- **Manutenibilidade**: Código organizado e fácil de entender
- **Flexibilidade**: Fácil trocar implementações sem afetar outras camadas
- **Escalabilidade**: Suporta crescimento do projeto sem refatoração major

### HTTP Client - Dio
**Por que Dio ao invés de http nativo?**
- **Interceptors**: Logging automático e tratamento de erros centralizado
- **Configuração Avançada**: Timeouts, retry, base URLs
- **Debugging**: Melhor visibilidade das requisições
- **Extensibilidade**: Fácil adicionar funcionalidades como cache

### Banco de Dados - Firebase Firestore
**Por que Firestore?**
- **NoSQL Flexível**: Ideal para dados não-relacionais como perfis
- **Realtime**: Sincronização automática entre dispositivos
- **Escalabilidade**: Google Cloud infrastructure
- **Offline Support**: Cache local automático
- **Segurança**: Rules declarativas para controle de acesso

### Padrões de Projeto Implementados
- **Repository Pattern**: Abstração da fonte de dados
- **Dependency Injection**: Baixo acoplamento entre componentes
- **Result Pattern**: Tratamento consistente de erros e sucessos
- **Use Case Pattern**: Lógica de negócio isolada e reutilizável
