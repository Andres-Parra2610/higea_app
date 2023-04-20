
class Response {

  Response({required this.ok, required this.msg});

  final bool ok;
  final String msg;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    ok:  json["ok"],
    msg: json["msg"]
  );
}