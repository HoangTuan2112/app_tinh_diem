
class PlayerInfo {
  String? _name;
  double? _point;
  PlayerInfo({required String name, required double point}){
    this._name = name;
    this._point = point;
  }
  String? get name => _name;
  double? get point => _point;
  set name(String? name){
    this._name = name;
  }
  set point(double? point){
    this._point = point;
  }
}