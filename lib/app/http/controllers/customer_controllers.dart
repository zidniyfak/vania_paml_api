import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/customer.dart';

class CustomerControllers extends Controller {
  Future<String> _generateCustomerId() async {
    var lastCust = await Customer().query().orderBy('cust_id', 'desc').first();

    int lastId = 0;
    if (lastCust != null) {
      String lastIdStr = lastCust['cust_id'].toString().substring(1);
      lastId = int.parse(lastIdStr);
    }

    int newId = lastId + 1;

    String newIdStr = 'C${newId.toString().padLeft(4, '0')}';

    return newIdStr;
  }

  Future<Response> index() async {
    try {
      var customers = await Customer().query().get();
      return Response.json(customers);
    } catch (e) {
      return Response.json({'message': e.toString()});
    }
  }

  Future<Response> store(Request request) async {
    try {
      var custId = await _generateCustomerId();
      var custName = request.input('cust_name');
      var custAddress = request.input('cust_address');
      var custCity = request.input('cust_city');
      var custState = request.input('cust_state');
      var custZip = request.input('cust_zip');
      var custCountry = request.input('cust_country');
      var custTelp = request.input('cust_telp');

      await Customer().query().insert({
        'cust_id': custId,
        'cust_name': custName,
        'cust_address': custAddress,
        'cust_city': custCity,
        'cust_state': custState,
        'cust_zip': custZip,
        'cust_country': custCountry,
        'cust_telp': custTelp,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      });

      return Response.json({
        'success': true,
        'message': 'Data customer berhasil disimpan',
        'code': 200,
        'data': {
          'cust_id': custId,
          'cust_name': custName,
          'cust_address': custAddress,
          'cust_city': custCity,
          'cust_state': custState,
          'cust_zip': custZip,
          'cust_country': custCountry,
          'cust_telp': custTelp,
        }
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': e.toString(),
        'code': 500,
      });
    }
  }

  Future<Response> update(Request request, String custId) async {
    try {
      var custName = request.input('cust_name');
      var custAddress = request.input('cust_address');
      var custCity = request.input('cust_city');
      var custState = request.input('cust_state');
      var custZip = request.input('cust_zip');
      var custCountry = request.input('cust_country');
      var custTelp = request.input('cust_telp');

      await Customer().query().where('cust_id', '=', custId).update({
        'cust_name': custName,
        'cust_address': custAddress,
        'cust_city': custCity,
        'cust_state': custState,
        'cust_zip': custZip,
        'cust_country': custCountry,
        'cust_telp': custTelp,
        'updated_at': DateTime.now(),
      });
      return Response.json({
        'success': true,
        'message': 'Data customer berhasil diupdate',
        'code': 200,
        'data': {
          'cust_id': custId,
          'cust_name': custName,
          'cust_address': custAddress,
          'cust_city': custCity,
          'cust_state': custState,
          'cust_zip': custZip,
          'cust_country': custCountry,
          'cust_telp': custTelp,
        }
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': e.toString(),
        'code': 500,
      });
    }
  }

  Future<Response> destroy(String custId) async {
    try {
      await Customer().query().where('cust_id', '=', custId).delete();
      return Response.json({
        'success': true,
        'message': 'Data berhasil dihapus',
        'code': 200,
      });
    } catch (e) {
      return Response.json({
        'success': false,
        'message': e.toString(),
        'code': 500,
      });
    }
  }
}

final CustomerControllers customerController = CustomerControllers();
