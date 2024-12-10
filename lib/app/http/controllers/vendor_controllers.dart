import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/vendor.dart';

class VendorControllers extends Controller {
  Future<Response> index() async {
    try {
      var vendors = await Vendor().query().get();
      return Response.json(vendors);
    } catch (e) {
      return Response.json({'message': e.toString()});
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var vendorName = request.input('vendor_name');
      var vendorAddress = request.input('vendor_address');
      var vendorKota = request.input('vendor_kota');
      var vendorState = request.input('vendor_state');
      var vendorZip = request.input('vendor_zip');
      var vendorCountry = request.input('vendor_country');

      await Vendor().query().insert({
        'vendor_name': vendorName,
        'vendor_address': vendorAddress,
        'vendor_kota': vendorKota,
        'vendor_state': vendorState,
        'vendor_zip': vendorZip,
        'vendor_country': vendorCountry,
        'created_at': DateTime.now(),
        'updated_at': DateTime.now(),
      });
      return Response.json({
        'success': true,
        'message': 'Data berhasil disimpan',
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

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    try {
      var vendorName = request.input('vendor_name');
      var vendorAddress = request.input('vendor_address');
      var vendorKota = request.input('vendor_kota');
      var vendorState = request.input('vendor_state');
      var vendorZip = request.input('vendor_zip');
      var vendorCountry = request.input('vendor_country');

      await Vendor().query().where('id', '=', id).update({
        'vendor_name': vendorName,
        'vendor_address': vendorAddress,
        'vendor_kota': vendorKota,
        'vendor_state': vendorState,
        'vendor_zip': vendorZip,
        'vendor_country': vendorCountry,
        'updated_at': DateTime.now(),
      });

      return Response.json({
        'success': true,
        'message': 'Data berhasil diupdate',
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

  Future<Response> destroy(int id) async {
    try {
      await Vendor().query().where('id', '=', id).delete();
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

final VendorControllers vendorController = VendorControllers();
