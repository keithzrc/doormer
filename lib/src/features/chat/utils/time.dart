String formatTime(DateTime dateTime) {
  return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}
//TODO: local time