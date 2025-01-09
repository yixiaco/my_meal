import 'package:my_meal/database/db.dart';

class Global {
  Global._();

  static void init() async {
    await Db.init();
  }
}
