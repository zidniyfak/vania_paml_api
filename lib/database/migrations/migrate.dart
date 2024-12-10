import 'dart:io';
import 'package:vania/vania.dart';
import 'create_customers_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateCustomerTable().up();
  }

  dropTables() async {
    await CreateCustomerTable().down();
  }
}
