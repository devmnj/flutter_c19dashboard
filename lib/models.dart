
class Status {
  final int active;
  final int confirmed;
  final int recovered;
  final int deceased;

  Status(this.active, this.confirmed, this.recovered, this.deceased);
}

class StateInfo {
  final String sname;
  final String abr;
  final Status status;
  final List<DistInfo> distInfo;
  StateInfo(this.sname, this.abr, this.status, this.distInfo);
}

class DistInfo {
  final String dname;
  final Status status;
  DistInfo(this.dname, this.status);
}