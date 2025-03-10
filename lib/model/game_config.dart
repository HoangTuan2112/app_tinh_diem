class GameConfig {
  late bool _isLimitPoints;
  late int _limitPoints;
  late bool _isLimitRound;
  late int _limitRound;
  late bool _isAutoCalculate;
  late int _currentRound;

  GameConfig(
      {required bool isLimitPoints,
      required int limitPoints,
      required bool isLimitRound,
      required int limitRound,
      required bool isAutoCalculate,
      required int currentRound}) {
    this._isLimitPoints = isLimitPoints;
    this._limitPoints = limitPoints;
    this._isLimitRound = isLimitRound;
    this._limitRound = limitRound;
    this._isAutoCalculate = isAutoCalculate;
    this._currentRound = currentRound;
  }

  GameConfig.empty() {
    this._isLimitPoints = false;
    this._limitPoints = 0;
    this._isLimitRound = false;
    this._limitRound = 0;
    this._isAutoCalculate = false;
    this._currentRound = 0;
  }

  bool get isLimitPoints => _isLimitPoints;

  int get limitPoints => _limitPoints;

  bool get isLimitRound => _isLimitRound;

  int get limitRound => _limitRound;

  bool get isAutoCalculate => _isAutoCalculate;

  int get currentRound => _currentRound;

  set isLimitPoints(bool isLimitPoints) {
    this._isLimitPoints = isLimitPoints;
  }

  set limitPoints(int limitPoints) {
    this._limitPoints = limitPoints;
  }

  set isLimitRound(bool isLimitRound) {
    this._isLimitRound = isLimitRound;
  }

  set limitRound(int limitRound) {
    this._limitRound = limitRound;
  }

  set isAutoCalculate(bool isAutoCalculate) {
    this._isAutoCalculate = isAutoCalculate;
  }

  set currentRound(int currentRound) {
    this._currentRound = currentRound;
  }

  Map<String, dynamic> toJson() {
    return {
      'isLimitPoints': _isLimitPoints,
      'limitPoints': _limitPoints,
      'isLimitRound': _isLimitRound,
      'limitRound': _limitRound,
      'isAutoCalculate': _isAutoCalculate,
      'currentRound': _currentRound,
    };
  }

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      isLimitPoints: json['isLimitPoints'],
      limitPoints: json['limitPoints'],
      isLimitRound: json['isLimitRound'],
      limitRound: json['limitRound'],
      isAutoCalculate: json['isAutoCalculate'],
      currentRound: json['currentRound'],
    );
  }
}
