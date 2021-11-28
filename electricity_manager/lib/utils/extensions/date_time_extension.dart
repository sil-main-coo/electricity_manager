extension DateTimeExtensions on DateTime {
  DateTime addMonth(int value) {
    var newDate = DateTime(this.year, this.month + value, this.day);
    return newDate;
  }

  DateTime subMonth(int value) {
    var newDate = DateTime(this.year, this.month - value, this.day);
    return newDate;
  }

}