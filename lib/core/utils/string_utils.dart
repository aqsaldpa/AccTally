import 'package:get/get.dart';

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'morning'.tr;
  }
  if (hour < 17) {
    return 'afternoon'.tr;
  }
  return 'evening'.tr;
}
