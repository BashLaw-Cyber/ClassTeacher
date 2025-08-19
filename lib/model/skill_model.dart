
const String tableSkill = "table_skill";
const String tblSkillId = "id";
const String tblSkillStudentId = "studentId";
const String tblSkillHandwriting = "handwriting";
const String tblSkillFluency = "fluency";
const String tblSkillGame = "game";
const String tblSkillSport = "sport";
const String tblSkillGymnastic = "gymnastic";
const String tblSkillHandlingOfTools = "handlingOfTools";
const String tblSkillDrawingAndPainting = "drawingAndPainting";
const String tblSkillCrafts = "crafts";
const String tblSkillMusicalSkill = "musicalSkill";

class SkillModel {
  final int? id;
  final int studentId;
  final int? handwriting;
  final int? fluency;
  final int? game;
  final int? sport;
  final int? gymnastic;
  final int? handlingOfTools;
  final int? drawingAndPainting;
  final int? crafts;
  final int? musicalSkill;

  SkillModel({
    this.id,
    required this.studentId,
    this.handwriting,
    this.fluency,
    this.game,
    this.sport,
    this.gymnastic,
    this.handlingOfTools,
    this.drawingAndPainting,
    this.crafts,
    this.musicalSkill,
  });

  Map<String, dynamic> toMap() {
    return {
      //tblSkillId: studentId,
      tblSkillStudentId: studentId,
      //tblSkillHandwriting: handwriting,
      // tblSkillFluency: fluency,
      // tblSkillGame: game,
      // tblSkillSport: sport,
      // tblSkillGymnastic: gymnastic,
      // tblSkillHandlingOfTools: handlingOfTools,
      // tblSkillDrawingAndPainting: drawingAndPainting,
      // tblSkillCrafts: crafts,
      // tblSkillMusicalSkill: musicalSkill
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map){
    return SkillModel(studentId: map[tblSkillStudentId],
        handwriting: map[tblSkillHandwriting],
        fluency: map[tblSkillFluency],
        game: map[tblSkillGame],
        sport: map[tblSkillSport],
        gymnastic: map[tblSkillGymnastic],
        handlingOfTools: map[tblSkillHandlingOfTools],
        drawingAndPainting: map[tblSkillDrawingAndPainting],
        crafts: map[tblSkillCrafts],
        musicalSkill: map[tblSkillMusicalSkill]);
  }
}
