/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/model/data/recent_transaction.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/ui/util/contact_formatters.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionOutputInformation extends ConsumerWidget {
  const TransactionOutputInformation({super.key, required this.transaction});

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return TransactionInformation(
      isEmpty: transaction.recipient == null,
      message: '${localizations.txListTo} ${AddressFormatters(
        transaction.contactInformations == null
            ? transaction.recipient!
            : transaction.contactInformations!.format,
      ).getShortString4()}',
    );
  }
}
