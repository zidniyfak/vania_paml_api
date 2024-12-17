import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/user.dart';

class AuthController extends Controller {
  Future<Response> register(Request request) async {
    try {
      var name = request.input('name');
      var email = request.input('email');
      var password = request.input('password');

      if (name == null || email == null || password == null) {
        return Response.json({
          'success': false,
          'message': 'Nama, email, dan password harus diisi',
        });
      }

      var isEmailExist =
          await User().query().where('email', '=', email).first();
      if (isEmailExist != null) {
        return Response.json({
          'success': false,
          'message': 'Email sudah terdaftar',
        });
      }

      final passwordHash = Hash().make(password);
      var user = await User().query().create({
        'name': name,
        'email': email,
        'password': passwordHash,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      });

      return Response.json({
        'success': true,
        'message': 'Registrasi berhasil',
        'data': user,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Terjadi kesalahan saat registrasi',
        'error': e.toString(),
      });
    }
  }

  Future<Response> login(Request request) async {
    try {
      final email = request.input('email');
      final password = request.input('password');

      if (email == null || password == null) {
        return Response.json({
          'success': false,
          'message': 'Email dan password harus diisi',
        });
      }

      final user = await User().query().where('email', '=', email).first();

      if (user == null) {
        return Response.json({
          'success': false,
          'message': 'Email dan password tidak cocok',
        });
      }

      final isPasswordValid = Hash().verify(password, user['password']);
      if (!isPasswordValid) {
        return Response.json({
          'success': false,
          'message': 'Email dan password tidak cocok',
        });
      }

      final token = await Auth()
          .login(user)
          .createToken(expiresIn: Duration(hours: 24), withRefreshToken: true);

      return Response.json({
        'success': true,
        'message': 'Login berhasil',
        'data': {
          'user': user,
          'token': token,
        }
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Terjadi kesalahan',
        'error': e.toString(),
      });
    }
  }

  Future<Response> logout(Request request) async {
    try {
      final token = request.header('Authorization');
      if (token == null) {
        return Response.json({
          'success': false,
          'message': 'Token tidak ditemukan',
        });
      }
      final isValidToken = await Auth().check(token);
      if (!isValidToken) {
        return Response.json({
          'success': false,
          'message': 'Token tidak valid',
        });
      }

      await Auth().deleteTokens();

      return Response.json({
        'success': true,
        'message': 'Logout berhasil',
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': 'Terjadi kesalahan',
        'error': e.toString(),
      });
    }
  }
}

final AuthController authController = AuthController();
