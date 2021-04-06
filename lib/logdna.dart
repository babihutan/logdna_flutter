import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:logdna/models/dna_line.dart';
import 'package:http/http.dart' as http;
import 'models/response.dart';

class LogDNA {
  /// logdna ingestion key
  final String apiKey;

  /// logdna app name
  final String appName;

  /// logdna hostname
  final String hostName;
  LogDNA({@required this.apiKey, this.appName, @required this.hostName});

  //// Sends the log via the logdna ingest API
  Future<DnaResponse> log(DnaLine line) async {
    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
    //orig: 'https://logs.logdna.com/logs/ingest?hostname=${this.hostName}&now=$now&apikey=${this.apiKey}&appName=${this.appName}',
    final Map<String, Object> queryParameters = {
      "hostname": "$hostName",
      "now": now,
      "apikey": "$apiKey",
      "appName": "$appName",
    };
    Uri uri = Uri.https('logs.logdna.com', '/logs/injest', queryParameters);
    try {
      http.Response response = await http.post(uri, body: {
        "lines": jsonEncode([line])
      });
      if (response.statusCode == 200) {
        print(true);
        return DnaResponse(true, response.body);
      } else {
        print(true);
        return DnaResponse(false, response.body);
      }
    } catch (e) {
      debugPrint("DNALogs Error: ${e.toString()}");
      return DnaResponse(false, e.toString());
    }
  }
}
