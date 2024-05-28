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

  Future<dynamic> commandDetails({required Map<String, dynamic> body}) async {
    final result = await _paymentRemoteDataSource.commandDetails(body: body);
    return result;
  }

  Future<dynamic> payCommand({ required String commandId, required Map<String, dynamic> body}) async {
    final result = await _paymentRemoteDataSource.payCommand(commandId: commandId, body: body);
    return result;
  }

  Future<dynamic> getAvailablePayments() async {
    final result = await _paymentRemoteDataSource.getAvailablePayments();
    return result;
  }

  Future<dynamic> sentOtp({ required String commandId, required Map<String, dynamic> body}) async {
    final result = await _paymentRemoteDataSource.sendOtp(commandId: commandId, body: body);
    return result;
  }
}
