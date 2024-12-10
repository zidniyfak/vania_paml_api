import 'package:vania/vania.dart';
import 'package:vania_paml_api/app/models/productnote.dart';

class ProductNoteControllers extends Controller {
  Future<Response> index() async {
    try {
      var productNotes = await Productnote().query().get();
      return Response.json(productNotes);
    } catch (e) {
      return Response.json({'message': e.toString()});
    }
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      var prodId = request.input('prod_id');
      var noteDate = request.input('note_date');
      var noteText = request.input('note_text');
      await Productnote().query().insert({
        'prod_id': prodId,
        'note_date': noteDate,
        'note_text': noteText,
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
      var prodId = request.input('prod_id');
      var noteDate = request.input('note_date');
      var noteText = request.input('note_text');
      await Productnote().query().where('id', '=', id).update({
        'prod_id': prodId,
        'note_date': noteDate,
        'note_text': noteText,
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
      await Productnote().query().where('id', '=', id).delete();
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

final ProductNoteControllers productNoteController = ProductNoteControllers();
