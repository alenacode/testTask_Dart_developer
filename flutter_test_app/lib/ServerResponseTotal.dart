import 'dart:convert';

ServerResponseTotal serverResponseTotalFromJson(String str) => ServerResponseTotal.fromJson(json.decode(str));
String serverResponseTotalToJson(ServerResponseTotal data) => json.encode(data.toJson());

class ServerResponseTotal {
    int code;
    String message;

    ServerResponseTotal({
        this.code,
        this.message,
    });

    factory ServerResponseTotal.fromJson(Map<String, dynamic> json) => ServerResponseTotal(
        code: json["code"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
    };
}
