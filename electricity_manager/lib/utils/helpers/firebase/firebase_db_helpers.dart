import 'package:electricity_manager/models/report_model.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDBHelpers {
  final refReportsDB = FirebaseDatabase.instance.reference().child('reports');

  Stream<Event> streamData() {
    return refReportsDB.onValue;
  }

  Future<List<ReportModel>> fetchReports() async {
    List<ReportModel> result = [];
    try {
      final snapshot = await refReportsDB.once();
      print(snapshot.value);
      final Map reportData = snapshot.value;

      reportData.forEach((key, value) {
        result.add(ReportModel.fromJson(key.toString(), Map.from(value)));
      });
    } catch (e) {
      throw Exception();
    }
    return result;
  }

  Future<ReportModel?> addNewReportToDB(ReportModel model) async {
    try {
      final reportID = refReportsDB.push();
      model.id = reportID.key;
      await reportID.set(model.toJson());
      return model;
    } catch (e) {}
    return null;
  }

  Future<void> updateReportOnDB(String id, Map<String, dynamic> data) async {
    try {
      await refReportsDB.child(id).update(data);
      throw Exception('report id is null');
    } catch (e) {}
  }

  Future<void> removeReport(String id)async{
    try {
      await refReportsDB.child(id).remove();
      throw Exception('report id is null');
    } catch (e) {}
  }
}
