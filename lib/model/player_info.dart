class PlayerInfo {
  String? _name;
  int? _point;

  PlayerInfo({required String name, required int point}) {
    this._name = name;
    this._point = point;
  }

  PlayerInfo.empty() {
    this._name = '';
    this._point = 0;
  }

  String? get name => _name;

  int? get point => _point;

  set name(String? name) {
    this._name = name;
  }

  set point(int? point) {
    this._point = point;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'point': point,
    };
  }

  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    return PlayerInfo(
      name: json['name'],
      point: (json['point'] as num).toInt(),
    );
  }
}
