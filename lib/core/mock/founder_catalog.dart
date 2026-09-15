import 'catalog_models.dart';

/// Local founder-athlete fixture for the first UI draft.
///
/// Sourced from the Product Foundation and the Ten and Ten experiment.
/// Not persisted; replace with repositories once auth and schema exist.
abstract final class FounderCatalog {
  static const athlete = AthleteProfileView(
    displayName: 'Serafim',
    roleLabel: 'Founder athlete',
    motto: 'Calisthenics fuels your life.',
    reportedCapabilities: [
      ReportedCapability(label: 'Push-ups', value: '50'),
      ReportedCapability(label: 'Pull-ups', value: '15'),
      ReportedCapability(label: 'Muscle-ups', value: '~5'),
      ReportedCapability(label: 'Handstand', value: '~40s'),
      ReportedCapability(label: 'Adv. tuck planche', value: '~30s'),
      ReportedCapability(label: 'Adv. tuck front lever', value: '~30s'),
    ],
  );

  static const experiment = ExperimentView(
    name: 'Ten and Ten',
    weekLabel: 'Week 1 · Baseline and calibration',
    objective:
        'Establish valid HSPU and muscle-up baselines before accumulating volume.',
  );

  static const primaryGoal = GoalView(
    id: 'hspu-10',
    title: '10 freestanding HSPU',
    standard:
        'Ten consecutive head-to-floor freestanding handstand push-ups, unassisted, filmed in one unedited set.',
    isPrimary: true,
    state: ProgressionState.notAssessed,
    nextCriterion: 'Complete H0 — the official quality baseline.',
    pathId: 'hspu',
  );

  static const supportingGoal = GoalView(
    id: 'mu-10',
    title: '10 clean bar muscle-ups',
    standard:
        'Ten consecutive bar muscle-ups to locked-out support, no chicken-wing transition.',
    isPrimary: false,
    state: ProgressionState.notAssessed,
    nextCriterion: 'Complete M0 — the official muscle-up baseline.',
    pathId: 'muscle-up',
  );

  static const hspuPath = ProgressionPathView(
    id: 'hspu',
    title: 'Freestanding handstand push-up',
    why:
        'Vertical pushing strength and balance are the limiting factors for the primary Ten and Ten goal.',
    nodes: [
      PathNodeView(
        id: 'pike-pu',
        name: 'Pike push-up',
        state: ProgressionState.consolidated,
      ),
      PathNodeView(
        id: 'wall-hspu',
        name: 'Wall-facing HSPU',
        state: ProgressionState.inProgress,
        current: true,
      ),
      PathNodeView(
        id: 'fs-hspu-single',
        name: 'Freestanding HSPU singles',
        state: ProgressionState.notAssessed,
      ),
      PathNodeView(
        id: 'fs-hspu-10',
        name: '10 consecutive HSPU',
        state: ProgressionState.notAssessed,
      ),
    ],
    prerequisites: [
      'Stable freestanding handstand (~30s) with calm shoulders',
      'Wall-facing HSPU to the same head-to-floor depth',
      'Controlled eccentric without collapsing the ribcage',
    ],
    unlockCriteria:
        'A valid consecutive set of 10, filmed, matching the experiment standard.',
  );

  static const muscleUpPath = ProgressionPathView(
    id: 'muscle-up',
    title: 'Bar muscle-up',
    why:
        'The supporting goal needs pulling power and a clean sit-up transition, not extra kipping volume.',
    nodes: [
      PathNodeView(
        id: 'pull-up',
        name: 'Pull-up',
        state: ProgressionState.achieved,
      ),
      PathNodeView(
        id: 'chest-to-bar',
        name: 'Chest-to-bar pull-up',
        state: ProgressionState.inProgress,
        current: true,
      ),
      PathNodeView(
        id: 'mu-singles',
        name: 'Muscle-up singles',
        state: ProgressionState.notAssessed,
      ),
      PathNodeView(
        id: 'mu-10',
        name: '10 consecutive muscle-ups',
        state: ProgressionState.notAssessed,
      ),
    ],
    prerequisites: [
      'High pull that can reach the bar at chest height',
      'Straight-bar dip with 2 repetitions in reserve',
      'Transition without a one-arm chicken wing',
    ],
    unlockCriteria:
        'Ten consecutive clean repetitions to visible elbow extension in support.',
  );

  static const learning = [
    LearningResourceView(
      id: 'hspu-standard',
      title: 'What counts as a valid HSPU',
      summary:
          'Elbows open at the top, crown to a consistent marker, no wall, feet stay off the floor.',
      body:
          'A repetition begins in a freestanding handstand with elbows extended and both feet clear of support. Descend under control until the crown of the head lightly contacts a consistent padded marker. Press back to a stable handstand with elbows visibly extended. Walking out of the area or placing a foot down ends the set. Impacting or bouncing the head invalidates the repetition.\n\nThis is the experiment form standard, not a competition rulebook. Use it so H0, checkpoints, and the final test mean the same thing.',
      claimKind: LearningClaimKind.fact,
    ),
    LearningResourceView(
      id: 'mu-standard',
      title: 'What counts as a clean muscle-up',
      summary:
          'Dead-hang start, locked-out support, kip allowed, chicken-wing not considered clean.',
      body:
          'Start below the bar with both elbows extended. Move to a clear support position above the bar with both elbows visibly extended. No person, platform, or ground contact may assist. Kip, swing, and grip adjustment are permitted. A pronounced one-arm chicken-wing transition is not a clean repetition. Stay on the bar for the entire set.',
      claimKind: LearningClaimKind.fact,
    ),
    LearningResourceView(
      id: 'week1-why',
      title: 'Why Week 1 is calibration, not grinding',
      summary:
          'Working-set size is derived from H0 and M0. Testing tired invents a false baseline.',
      body:
          'Until the official baselines exist, volume prescriptions are guesses. Week 1 spends two sessions on quality tests and two on practicing the standard with conservative accessories. Failure is reserved for scheduled tests, not daily training. That is coaching interpretation for this block, not a universal law.',
      claimKind: LearningClaimKind.coaching,
    ),
  ];

  static const personalRecords = [
    PersonalRecordView(
      exercise: 'Bar muscle-up',
      value: '~5 consecutive',
      note: 'Prior self-report. Not the official M0 baseline.',
    ),
    PersonalRecordView(
      exercise: 'Freestanding handstand',
      value: '~40 seconds',
      note: 'Prior self-report. Reassess during Day 1 capacity work.',
    ),
    PersonalRecordView(
      exercise: 'Freestanding HSPU',
      value: 'Not established',
      note: 'H0 is the first official evidence Wings will store.',
    ),
  ];

  static const upcomingTogether = SharedSessionView(
    id: 'saturday-bars',
    title: 'Saturday bars — muscle-up volume',
    whenLabel: 'Saturday · morning',
    place: 'Neighbourhood bars (approximate area only)',
    compatibility: 'Same block, pulling bias, open to one partner',
    invitees: [],
  );

  static AthleteCatalog build() {
    return const AthleteCatalog(
      athlete: athlete,
      experiment: experiment,
      primaryGoal: primaryGoal,
      supportingGoal: supportingGoal,
      paths: [hspuPath, muscleUpPath],
      weekSessions: [
        PlannedSessionView(
          id: 'day-1',
          title: 'Day 1 — HSPU quality',
          focusLabel: 'Vertical push · baseline',
          weekdayLabel: 'Monday',
          objective:
              'Establish H0 and a calm handstand before any volume talk.',
          why:
              'The primary goal has no official baseline yet. A tired test would invent a number Wings cannot trust.',
          exercises: [
            PlannedExerciseView(
              name: 'Freestanding handstand entries',
              prescription: '8–12 min, low fatigue',
              isSkillWork: true,
            ),
            PlannedExerciseView(
              name: 'Freestanding HSPU test',
              prescription: 'Up to 3 quality max-effort sets · 5–7 min rest',
              isSkillWork: true,
            ),
            PlannedExerciseView(
              name: 'Wall-facing HSPU',
              prescription: 'To 1 rep in reserve, same depth',
            ),
            PlannedExerciseView(
              name: 'Controlled HSPU eccentric',
              prescription: '1 slow descent',
            ),
            PlannedExerciseView(
              name: 'Easy muscle-up singles',
              prescription: '3–5, only if shoulders feel fresh',
            ),
          ],
        ),
        PlannedSessionView(
          id: 'day-2',
          title: 'Day 2 — Muscle-up power',
          focusLabel: 'Pulling power · baseline',
          weekdayLabel: 'Tuesday',
          objective: 'Establish M0 without grinding the transition.',
          why:
              'The supporting goal still sits on memory. M0 must be filmed under the same standard as the final test.',
          exercises: [
            PlannedExerciseView(
              name: 'Easy handstand balance',
              prescription: '5–8 min',
            ),
            PlannedExerciseView(
              name: 'Bar muscle-up test',
              prescription: 'Up to 2 quality max-effort sets · 7–10 min rest',
              isSkillWork: true,
            ),
            PlannedExerciseView(
              name: 'Chest-to-bar pull-up',
              prescription: 'To 1 rep in reserve',
            ),
            PlannedExerciseView(
              name: 'Straight-bar dips',
              prescription: 'To 2 reps in reserve',
            ),
          ],
        ),
        PlannedSessionView(
          id: 'day-3',
          title: 'Day 3 — HSPU volume',
          focusLabel: 'Repeatability',
          weekdayLabel: 'Thursday',
          objective: 'Practice the standard in small, valid sets.',
          why:
              'After H0 exists, volume is a fraction of that maximum — never a second test.',
          exercises: [
            PlannedExerciseView(
              name: 'Handstand balance',
              prescription: '8–10 min',
              isSkillWork: true,
            ),
            PlannedExerciseView(
              name: 'Freestanding HSPU clusters',
              prescription: 'Small repeatable sets from H0',
              isSkillWork: true,
            ),
            PlannedExerciseView(
              name: 'Wall-facing HSPU',
              prescription: '3–4 sets, 2 RIR',
            ),
          ],
        ),
        PlannedSessionView(
          id: 'day-4',
          title: 'Day 4 — Muscle-up volume',
          focusLabel: 'Repeatability',
          weekdayLabel: 'Saturday',
          objective: 'Accumulate valid muscle-ups without grinding.',
          why:
              'Shared Saturday session if a partner joins; the work stays the same if you train alone.',
          exercises: [
            PlannedExerciseView(
              name: 'Bar muscle-up clusters',
              prescription: 'Prescribed volume, no grind',
              isSkillWork: true,
            ),
            PlannedExerciseView(
              name: 'Explosive pull-up',
              prescription: '3 × 3–5',
            ),
            PlannedExerciseView(
              name: 'Easy HSPU singles',
              prescription: '5–8 min, only while crisp',
            ),
          ],
        ),
      ],
      personalRecords: personalRecords,
      upcomingTogether: upcomingTogether,
      learning: learning,
      assessmentComplete: false,
      partners: [],
    );
  }
}
