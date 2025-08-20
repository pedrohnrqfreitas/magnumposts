import 'package:firebase_auth/firebase_auth.dart';
import 'failure.dart';

class FirebaseErrorHandler {
  /// Converte erros do Firebase Auth em Failures
  static Failure handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      return _handleFirebaseAuthException(error);
    } else if (error is FirebaseException) {
      return _handleFirebaseException(error);
    } else {
      return Failure(
        message: 'Erro inesperado: ${error.toString()}',
        code: 'unknown_error',
      );
    }
  }

  /// Converte erros do Firestore em Failures
  static Failure handleFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      return _handleFirebaseException(error);
    } else {
      return Failure(
        message: 'Erro no banco de dados: ${error.toString()}',
        code: 'firestore_error',
      );
    }
  }

  static Failure _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return  Failure(
          message: 'Usuário não encontrado. Verifique seu email.',
          code: 'user-not-found',
        );

      case 'wrong-password':
        return  Failure(
          message: 'Senha incorreta. Tente novamente.',
          code: 'wrong-password',
        );

      case 'email-already-in-use':
        return  Failure(
          message: 'Este email já está em uso. Tente fazer login.',
          code: 'email-already-in-use',
        );

      case 'weak-password':
        return  Failure(
          message: 'A senha é muito fraca. Use pelo menos 6 caracteres.',
          code: 'weak-password',
        );

      case 'invalid-email':
        return  Failure(
          message: 'Email inválido. Verifique o formato.',
          code: 'invalid-email',
        );

      case 'user-disabled':
        return  Failure(
          message: 'Esta conta foi desabilitada.',
          code: 'user-disabled',
        );

      case 'too-many-requests':
        return  Failure(
          message: 'Muitas tentativas. Tente novamente em alguns minutos.',
          code: 'too-many-requests',
        );

      case 'network-request-failed':
        return  Failure(
          message: 'Erro de conexão. Verifique sua internet.',
          code: 'network-request-failed',
        );

      case 'operation-not-allowed':
        return  Failure(
          message: 'Operação não permitida.',
          code: 'operation-not-allowed',
        );

      case 'invalid-credential':
        return  Failure(
          message: 'Credenciais inválidas. Verifique email e senha.',
          code: 'invalid-credential',
        );

      default:
        return Failure(
          message: e.message ?? 'Erro de autenticação',
          code: e.code,
        );
    }
  }

  static Failure _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return  Failure(
          message: 'Acesso negado. Você não tem permissão para esta operação.',
          code: 'permission-denied',
        );

      case 'not-found':
        return  Failure(
          message: 'Documento não encontrado.',
          code: 'not-found',
        );

      case 'already-exists':
        return  Failure(
          message: 'Documento já existe.',
          code: 'already-exists',
        );

      case 'cancelled':
        return  Failure(
          message: 'Operação cancelada.',
          code: 'cancelled',
        );

      case 'data-loss':
        return  Failure(
          message: 'Perda de dados irrecuperável.',
          code: 'data-loss',
        );

      case 'deadline-exceeded':
        return Failure(
          message: 'Tempo limite excedido.',
          code: 'deadline-exceeded',
        );

      case 'failed-precondition':
        return Failure(
          message: 'Condição prévia falhou.',
          code: 'failed-precondition',
        );

      case 'internal':
        return Failure(
          message: 'Erro interno do servidor.',
          code: 'internal',
        );

      case 'invalid-argument':
        return Failure(
          message: 'Argumentos inválidos.',
          code: 'invalid-argument',
        );

      case 'out-of-range':
        return Failure(
          message: 'Valor fora do intervalo válido.',
          code: 'out-of-range',
        );

      case 'resource-exhausted':
        return Failure(
          message: 'Recurso esgotado.',
          code: 'resource-exhausted',
        );

      case 'unauthenticated':
        return Failure(
          message: 'Usuário não autenticado.',
          code: 'unauthenticated',
        );

      case 'unavailable':
        return Failure(
          message: 'Serviço temporariamente indisponível.',
          code: 'unavailable',
        );

      case 'unimplemented':
        return Failure(
          message: 'Operação não implementada.',
          code: 'unimplemented',
        );

      default:
        return Failure(
          message: e.message ?? 'Erro do Firebase',
          code: e.code,
        );
    }
  }
}