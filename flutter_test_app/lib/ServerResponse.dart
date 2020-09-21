import 'dart:convert';

ServerResponse serverResponseFromJson(String str) => ServerResponse.fromJson(json.decode(str));
String serverResponseToJson(ServerResponse data) => json.encode(data.toJson());

class ServerResponse {
    int code;
    String message;
    String data;

    ServerResponse({
        this.code,
        this.message,
        this.data,
    });

    factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
    };
}
