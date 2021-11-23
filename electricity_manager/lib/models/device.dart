class Device {
  String? id;
  String? name;
  int? count = 0;
  int? action = 1; // action : thu hồi; 1: lắp mới
  String? state;

  String get actionString => action == 0 ? 'Thu hồi' : 'Lắp mới';

  Device({this.id, this.name});

  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
    action = json['action'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    data['state'] = this.state;
    data['action'] = this.action;
    return data;
  }

  @override
  String toString() {
    return this.name ?? '';
  }
}

class DeviceAction {
  int? id;
  String? label;

  DeviceAction.returnAction() {
    id = 0;
    label = 'Thu hồi';
  }

  DeviceAction.installAction() {
    id = 1;
    label = 'Lắp mới';
  }

  @override
  String toString() {
    return label!;
  }
}
