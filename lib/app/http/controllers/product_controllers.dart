import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/product.dart';

class ProductControllers extends Controller {
  Future<Response> index() async {
    try {
      var products = await Product().query().get();
      return Response.json(products);
    } catch (e) {
      return Response.json({'message': e.toString()});
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var vendId = request.input('vend_id');
      var prodName = request.input('prod_name');
      var prodPrice = request.input('prod_price');
      var prodDesc = request.input('prod_desc');

      await Product().query().insert({
        'vend_id': vendId,
        'prod_name': prodName,
        'prod_price': prodPrice,
        'prod_desc': prodDesc,
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
      var vendId = request.input('vend_id');
      var prodName = request.input('prod_name');
      var prodPrice = request.input('prod_price');
      var prodDesc = request.input('prod_desc');

      await Product().query().where('id', '=', id).update({
        'vend_id': vendId,
        'prod_name': prodName,
        'prod_price': prodPrice,
        'prod_desc': prodDesc,
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
      await Product().query().where('id', '=', id).delete();
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

final ProductControllers productController = ProductControllers();
