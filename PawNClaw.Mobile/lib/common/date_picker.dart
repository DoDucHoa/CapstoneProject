import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

Future<DateTime?> selectSingleDate(BuildContext context) async {
  return await showDatePicker(
    context: context,
    initialDatePickerMode: DatePickerMode.year,
    initialDate: DateTime.now(),
    firstDate: DateTime(1920),
    lastDate: DateTime.now(),
    locale: const Locale('vi', 'VI'),
  );
}

Future<DateTime?> selectSingleTime(
    BuildContext context, Function onConfirmed) async {
  var result;
  DatePicker.showDateTimePicker(
    context,
    showTitleActions: true,
    minTime: DateTime.now(),
    maxTime: DateTime.now().add(Duration(days: 60)),
    currentTime: DateTime.now(),
    locale: LocaleType.vi,
    onConfirm: (date) => onConfirmed(date),
    onCancel: () {},
  );
  return result;
}

Future<DateTime?> selectSingleDateFrom(
    BuildContext context, DateTime startDate) async {
  return await showDatePicker(
    context: context,
    initialDatePickerMode: DatePickerMode.day,
    initialDate: startDate,
    firstDate: startDate,
    lastDate: DateTime(2050), // halt: cần thêm ràng buộc
    locale: const Locale('vi', 'VI'),
  );
}

Future<DateTime?> selectSingleDateTo(
    BuildContext context, DateTime endDate) async {
  return await showDatePicker(
    context: context,
    initialDatePickerMode: DatePickerMode.year,
    initialDate: endDate,
    firstDate: DateTime(1990),
    lastDate: endDate, // halt: cần thêm ràng buộc
    locale: const Locale('vi', 'VI'),
  );
}

// DateTime RoundUp(DateTime dt, TimeSpan d)
// {
//     return new DateTime((dt.Ticks + d.Ticks - 1) / d.Ticks * d.Ticks, dt.Kind);
// }

extension DateTimeExt on DateTime {
  DateTime get roundMin =>
      DateTime(this.year, this.month, this.day, this.hour, () {
        if (this.minute > 0 && this.minute <= 30) {
          return 30;
        }
        ;
        if (this.minute == 0) {
          return 0;
        }
        return 60;
      }());
}

String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "năm" : "năm"} trước";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "tháng" : "tháng"} trước";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "tuần" : "tuần"} trước";
  if (diff.inDays > 0)
    return "${diff.inDays} ${diff.inDays == 1 ? "ngày" : "ngày"} trước";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "giờ" : "giờ"} trước";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "phút" : "phút"} trước";
  return "Vừa xong";
}
