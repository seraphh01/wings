enum ProgressionState {
  notAssessed,
  preparing,
  readyToAttempt,
  inProgress,
  achieved,
  consolidated,
  needsReassessment,
}

extension ProgressionStateLabel on ProgressionState {
  String get label => switch (this) {
    ProgressionState.notAssessed => 'Not assessed',
    ProgressionState.preparing => 'Preparing',
    ProgressionState.readyToAttempt => 'Ready to attempt',
    ProgressionState.inProgress => 'In progress',
    ProgressionState.achieved => 'Achieved',
    ProgressionState.consolidated => 'Consolidated',
    ProgressionState.needsReassessment => 'Needs reassessment',
  };
}

class AthleteProfileView {
  const AthleteProfileView({
    required this.displayName,
    required this.roleLabel,
    required this.motto,
    required this.reportedCapabilities,
  });

  final String displayName;
  final String roleLabel;
  final String motto;
  final List<ReportedCapability> reportedCapabilities;
}

class ReportedCapability {
  const ReportedCapability({required this.label, required this.value});

  final String label;
  final String value;
}

class GoalView {
  const GoalView({
    required this.id,
    required this.title,
    required this.standard,
    required this.isPrimary,
    required this.state,
    required this.nextCriterion,
    required this.pathId,
  });

  final String id;
  final String title;
  final String standard;
  final bool isPrimary;
  final ProgressionState state;
  final String nextCriterion;
  final String pathId;
}

class PathNodeView {
  const PathNodeView({
    required this.id,
    required this.name,
    required this.state,
    this.current = false,
  });

  final String id;
  final String name;
  final ProgressionState state;
  final bool current;
}

class ProgressionPathView {
  const ProgressionPathView({
    required this.id,
    required this.title,
    required this.why,
    required this.nodes,
    required this.prerequisites,
    required this.unlockCriteria,
  });

  final String id;
  final String title;
  final String why;
  final List<PathNodeView> nodes;
  final List<String> prerequisites;
  final String unlockCriteria;
}

class PlannedExerciseView {
  const PlannedExerciseView({
    required this.name,
    required this.prescription,
    this.isSkillWork = false,
  });

  final String name;
  final String prescription;
  final bool isSkillWork;
}

class PlannedSessionView {
  const PlannedSessionView({
    required this.id,
    required this.title,
    required this.focusLabel,
    required this.objective,
    required this.why,
    required this.exercises,
    required this.weekdayLabel,
    this.isToday = false,
  });

  final String id;
  final String title;
  final String focusLabel;
  final String objective;
  final String why;
  final List<PlannedExerciseView> exercises;
  final String weekdayLabel;
  final bool isToday;
}

class PersonalRecordView {
  const PersonalRecordView({
    required this.exercise,
    required this.value,
    required this.note,
  });

  final String exercise;
  final String value;
  final String note;
}

class SharedSessionView {
  const SharedSessionView({
    required this.id,
    required this.title,
    required this.whenLabel,
    required this.place,
    required this.compatibility,
    required this.invitees,
  });

  final String id;
  final String title;
  final String whenLabel;
  final String place;
  final String compatibility;
  final List<String> invitees;
}

class LearningResourceView {
  const LearningResourceView({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.claimKind,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final LearningClaimKind claimKind;
}

enum LearningClaimKind { fact, coaching, experience }

class ExperimentView {
  const ExperimentView({
    required this.name,
    required this.weekLabel,
    required this.objective,
  });

  final String name;
  final String weekLabel;
  final String objective;
}

class ReadinessView {
  const ReadinessView({
    required this.logged,
    this.sleepHours,
    this.energy,
    this.discomfort,
  });

  final bool logged;
  final double? sleepHours;
  final int? energy;
  final int? discomfort;
}

class TodaySnapshot {
  const TodaySnapshot({
    required this.athlete,
    required this.date,
    required this.experiment,
    required this.readiness,
    required this.session,
    required this.primaryGoal,
    required this.supportingGoal,
    required this.recommendation,
    required this.upcomingTogether,
    required this.learning,
    required this.assessmentComplete,
    required this.isRecoveryDay,
  });

  final AthleteProfileView athlete;
  final DateTime date;
  final ExperimentView experiment;
  final ReadinessView readiness;
  final PlannedSessionView session;
  final GoalView primaryGoal;
  final GoalView supportingGoal;
  final String recommendation;
  final SharedSessionView? upcomingTogether;
  final LearningResourceView learning;
  final bool assessmentComplete;
  final bool isRecoveryDay;
}

class AthleteCatalog {
  const AthleteCatalog({
    required this.athlete,
    required this.experiment,
    required this.primaryGoal,
    required this.supportingGoal,
    required this.paths,
    required this.weekSessions,
    required this.personalRecords,
    required this.upcomingTogether,
    required this.learning,
    required this.assessmentComplete,
    required this.partners,
  });

  final AthleteProfileView athlete;
  final ExperimentView experiment;
  final GoalView primaryGoal;
  final GoalView supportingGoal;
  final List<ProgressionPathView> paths;
  final List<PlannedSessionView> weekSessions;
  final List<PersonalRecordView> personalRecords;
  final SharedSessionView? upcomingTogether;
  final List<LearningResourceView> learning;
  final bool assessmentComplete;
  final List<String> partners;

  ProgressionPathView pathById(String id) {
    return paths.firstWhere((path) => path.id == id);
  }

  ProgressionPathView? maybePath(String id) {
    for (final path in paths) {
      if (path.id == id) return path;
    }
    return null;
  }

  LearningResourceView learningById(String id) {
    return learning.firstWhere((item) => item.id == id);
  }

  PlannedSessionView sessionById(String id) {
    return weekSessions.firstWhere((session) => session.id == id);
  }
}
