const String tableBehaviour = "table_behaviour";
const String tblBehaviourId = "id";
const String tblBehaviourStudentId = "studentId";
const String tblBehaviourPunctuality = "punctuality";
const String tblBehaviourAttendance = "attendance";
const String tblBehaviourReliability = "reliability";
const String tblBehaviourNeatness = "neatness";
const String tblBehaviourPoliteness = "politeness";
const String tblBehaviourHonesty = "honesty";
const String tblBehaviourRelationshipWithStaff = "relationshipWithStaff";
const String tblBehaviourRelationshipWithStudents = "relationshipWithStudents";
const String tblBehaviourSelfControl = "selfControl";
const String tblBehaviourSpiritOfCooperation = "spiritOfCooperation";
const String tblBehaviourSenseOfResponsibility = "senseOfResponsibility";
const String tblBehaviourAttentiveness = "attentiveness";
const String tblBehaviourInitiative = "initiative";
const String tblBehaviourOrganisationAbility = "organisationAbility";
const String tblBehaviourPerserverance = "perserverance";
const String tblBehaviourPhysicalDev = "physicalDev";

class BehaviorModel {
  final int? id;
  final int studentId;
  final int? punctuality;
  final int? attendance;
  final int? reliability;
  final int? neatness;
  final int? politeness;
  final int? honesty;
  final int? relationshipWithStaff;
  final int? relationshipWithStudents;
  final int? selfControl;
  final int? spiritOfCooperation;
  final int? senseOfResponsibility;
  final int? attentiveness;
  final int? initiative;
  final int? organizationAbility;
  final int? perseverance;
  final int? physicalDev;

  BehaviorModel({
    this.id,
    required this.studentId,
    this.punctuality,
    this.attendance,
    this.reliability,
    this.neatness,
    this.politeness,
    this.honesty,
    this.relationshipWithStaff,
    this.relationshipWithStudents,
    this.selfControl,
    this.spiritOfCooperation,
    this.senseOfResponsibility,
    this.attentiveness,
    this.initiative,
    this.organizationAbility,
    this.perseverance,
    this.physicalDev,
  });

  Map<String, dynamic> toMap() {
    return {
      //tblBehaviourId: id,
      tblBehaviourStudentId: studentId,
      // tblBehaviourPunctuality: punctuality,
      // tblBehaviourAttendance: attendance,
      // tblBehaviourReliability: reliability,
      // tblBehaviourNeatness: neatness,
      // tblBehaviourPoliteness: politeness,
      // tblBehaviourHonesty: honesty,
      // tblBehaviourRelationshipWithStaff: relationshipWithStaff,
      // tblBehaviourRelationshipWithStudents: relationshipWithStudents,
      // tblBehaviourSelfControl: selfControl,
      // tblBehaviourSpiritOfCooperation: spiritOfCooperation,
      // tblBehaviourSenseOfResponsibility: senseOfResponsibility,
      // tblBehaviourAttentiveness: attentiveness,
      // tblBehaviourInitiative: initiative,
      // tblBehaviourOrganisationAbility: organisationAbility,
      // tblBehaviourPerserverance: perserverance,
      // tblBehaviourPhysicalDev: physicalDev
    };
  }

  factory BehaviorModel.fromMap(Map<String, dynamic>map){
    return BehaviorModel(id: map[tblBehaviourId],
        studentId: map[tblBehaviourStudentId],
        punctuality: map[tblBehaviourPunctuality],
        attendance: map[tblBehaviourAttendance],
        reliability: map[tblBehaviourReliability],
        neatness: map[tblBehaviourNeatness],
        politeness: map[tblBehaviourPoliteness],
        honesty: map[tblBehaviourHonesty],
        relationshipWithStaff: map[tblBehaviourRelationshipWithStaff],
        relationshipWithStudents: map[tblBehaviourRelationshipWithStudents],
        selfControl: map[tblBehaviourSelfControl],
        spiritOfCooperation: map[tblBehaviourSpiritOfCooperation],
        senseOfResponsibility: map[tblBehaviourSenseOfResponsibility],
        attentiveness: map[tblBehaviourAttentiveness],
        initiative: map[tblBehaviourInitiative],
        organizationAbility: map[tblBehaviourOrganisationAbility],
        perseverance: map[tblBehaviourPerserverance],
        physicalDev: map[tblBehaviourPhysicalDev]);
  }
}
