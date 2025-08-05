import 'package:moh_eam/features/auth/data/models/auth_model.dart';

abstract interface class AuthRepo {
  Future<AuthModel> signin({required String username, required String password, required String locale});
  Future<void> signout();
  Future<AuthModel> token({required String refToken});
}
