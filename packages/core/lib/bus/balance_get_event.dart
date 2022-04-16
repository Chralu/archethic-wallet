/// SPDX-License-Identifier: AGPL-3.0-or-later

// Package imports:
import 'package:archethic_lib_dart/archethic_lib_dart.dart' show Balance;
import 'package:core/model/data/hive_db.dart';
import 'package:event_taxi/event_taxi.dart';

class BalanceGetEvent implements Event {
  BalanceGetEvent({this.response, this.account});

  final Account? account;
  final Balance? response;
}
