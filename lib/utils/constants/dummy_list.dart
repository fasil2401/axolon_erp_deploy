class TimeLineModel {
  String title;
  String time;
  TimeLineModel({required this.title, required this.time});
}

List<TimeLineModel> timeLineList = [
  TimeLineModel(title: 'Check In', time: '09:00 AM'),
  TimeLineModel(title: 'Tea Break', time: '10:00 AM'),
  TimeLineModel(title: 'Lunch', time: '12:00 PM'),
  TimeLineModel(title: 'Break', time: '02:00 PM'),
  TimeLineModel(title: 'Break', time: '04:00 PM'),
  TimeLineModel(title: 'Check Out', time: '05:00 PM'),
];
