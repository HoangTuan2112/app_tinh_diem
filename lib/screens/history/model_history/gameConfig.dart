
class GameConfig  {
   late bool _isLimitPoints;
  late int _limitPoints;
  late bool _isLimitRound;
  late int _limitRound;
  late bool _isAutoCalculate;
  late int _currentRound;
 
  GameConfig (bool isLimitPoints, int limitPoints, bool isLimitRound, int limitRound, bool isAutoCalculate, int currentRound){
    this._isLimitPoints = isLimitPoints;
    this._limitPoints = limitPoints;
    this._isLimitRound = isLimitRound;
    this._limitRound = limitRound;
    this._isAutoCalculate = isAutoCalculate;
    this._currentRound = currentRound;
   
  }
  bool get isLimitPoints => _isLimitPoints;
  int get limitPoints => _limitPoints;
  bool get isLimitRound => _isLimitRound;
  int get limitRound => _limitRound;
  bool get isAutoCalculate => _isAutoCalculate;
  int get currentRound => _currentRound;

  set isLimitPoints(bool isLimitPoints){
    this._isLimitPoints = isLimitPoints;
  }
  set limitPoints(int limitPoints){
    this._limitPoints = limitPoints;
  }
  set isLimitRound(bool isLimitRound){
    this._isLimitRound = isLimitRound;
  }
  set limitRound(int limitRound){
    this._limitRound = limitRound;
  }
  set isAutoCalculate(bool isAutoCalculate){
    this._isAutoCalculate = isAutoCalculate;
  }
  set currentRound(int currentRound){
    this._currentRound = currentRound;
  }

  
  
 


}