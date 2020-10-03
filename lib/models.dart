

class Status {
  final int active;
  final int confirmed;
  final int recovered;
  final int deceased;

  Status(this.active, this.confirmed, this.recovered, this.deceased);
}
class TestResult {
  final int positive;
  final int negaitive;
  final int unconfirmed;
  final int tests_per_positive_case;
  final int released_from_quarantine;
  final int currently_in_quarantine;

  TestResult(this.positive, this.negaitive, this.unconfirmed, this.tests_per_positive_case, this.released_from_quarantine, this.currently_in_quarantine);

}

class StateInfo {
  final String sname;
  final String abr;
  final Status status;
  final TestResult tests;
  final List<DistInfo> distInfo;
  StateInfo(this.sname, this.abr, this.status, this.distInfo, this.tests);

}

class DistInfo {
  // final TestResult tests;
  final String dname;
  final Status status;

  DistInfo(this.dname, this.status );
}