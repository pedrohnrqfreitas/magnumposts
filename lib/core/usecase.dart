import 'package:equatable/equatable.dart';
import 'package:magnumposts/core/result_data.dart';

import 'errors/failure.dart';

abstract class Usecase<Output, Input> {
  Future<ResultData<Failure, Output>> call(Input params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
