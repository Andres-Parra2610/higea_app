
class Response {

  Response({required this.ok, required this.msg, this.result});

  final bool ok;
  final String msg;
  final dynamic result;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    ok:  json["ok"],
    msg: json["msg"],
    result: json["result"]
  );
}