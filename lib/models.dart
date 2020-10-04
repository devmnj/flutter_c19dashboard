

class Status {
  final int active;
  final int confirmed;
  final int recovered;
  final int deceased;

  Status(this.active, this.confirmed, this.recovered, this.deceased);
}
class TestResult {
  final double positive;
  final double negaitive;
  final double unconfirmed;
  final double tests_per_positive_case;
  final double released_from_quarantine;
  final double currently_in_quarantine;
  final double totaltested;

  TestResult(this.positive, this.negaitive, this.unconfirmed, this.tests_per_positive_case, this.released_from_quarantine, this.currently_in_quarantine, this.totaltested);

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