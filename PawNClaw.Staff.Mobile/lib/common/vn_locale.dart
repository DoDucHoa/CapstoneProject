class Localization {
  String convertWeekDay(String us) {
    switch (us) {
      case "Monday":
        return "Thứ hai";
      case "Tueday":
        return "Thứ ba";
      case "Wednesday":
        return "Thứ tư";
      case "Thursday":
        return "Thứ năm";
      case "Friday":
        return "Thứ sáu";
      case "Saturday":
        return "Thứ bảy";
      default:
        return "Chủ nhật";
    }
  }
}
