// ignore_for_file: file_names, use_build_context_synchronously



import 'PaymentRemoteDataSource.dart';

class PaymentRepository {
  static final PaymentRepository _paymentRepository = PaymentRepository._internal();
  late PaymentRemoteDataSource _paymentRemoteDataSource;

  factory PaymentRepository() {
    _paymentRepository._paymentRemoteDataSource = PaymentRemoteDataSource();
    return _paymentRepository;
  }

  PaymentRepository._internal();

  Future<dynamic> command({ required Map<String, dynamic> body}) async {
    final result = await _paymentRemoteDataSource.command(body: body);
    return result;
  }


}
