
class ResultData<F, S> {
  final F? failure;
  final S? success;
  final bool isSuccess;

  ResultData._({
    this.failure,
    this.success,
    required this.isSuccess,
  });

  factory ResultData.success(S data) {
    return ResultData._(
      success: data,
      isSuccess: true,
    );
  }

  factory ResultData.error(F error) {
    return ResultData._(
      failure: error,
      isSuccess: false,
    );
  }

  T fold<T>(
      T Function(F failure) onFailure,
      T Function(S success) onSuccess,
      ) {
    if (isSuccess && success != null) {
      return onSuccess(success as S);
    } else if (failure != null) {
      return onFailure(failure as F);
    } else {
      throw Exception('ResultData em estado inconsistente');
    }
  }

  bool get isError => !isSuccess;
  bool get hasData => success != null;
  bool get hasError => failure != null;
}