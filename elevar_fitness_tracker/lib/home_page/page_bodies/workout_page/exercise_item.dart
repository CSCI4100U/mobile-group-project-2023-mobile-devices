class ExerciseItem {
  ExerciseItem(this.name, this.muscle, this.isSelected);
  final String name;
  final String muscle;
  bool isSelected;

}

ExerciseItem fromMap(Map<String,dynamic> data) {
  return ExerciseItem(data['name']!, data['muscle']!, false);
}