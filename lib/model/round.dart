class Round {
 final int roundNumber;
 final List<int> scores;
 final String? notes;

 Round({
  required this.roundNumber,
  required this.scores,
  this.notes,
 });


 factory Round.fromJson(Map<String, dynamic> json) {
  return Round(
   roundNumber: json['roundNumber'] as int,
   scores: (json['scores'] as List<dynamic>).cast<int>(),
   notes: json['notes'] as String?,
  );
 }


 Map<String, dynamic> toJson() {
  return {
   'roundNumber': roundNumber,
   'scores': scores,
   'notes': notes,
  };
 }


 Round copyWith({
  int? roundNumber,
  List<int>? scores,
  String? notes,
 }) {
  return Round(
   roundNumber: roundNumber ?? this.roundNumber,
   scores: scores ?? this.scores,
   notes: notes ?? this.notes,
  );
 }


 @override
 String toString() {
  return 'Round{roundNumber: $roundNumber, scores: $scores, notes: $notes}';
 }
}