import 'package:vania/vania.dart';

class CreateProductnotesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('productnotes', () {
      char('note_id', length: 5);
      string('prod_id', length: 10);
      date('note_date');
      text('note_text');
      timeStamps();

      primary('note_id');
      foreign('prod_id', 'products', 'prod_id',
          constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('productnotes');
  }
}
