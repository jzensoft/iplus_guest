import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/user.dart';

class Item extends StatelessWidget {
  final dynamic onConfirm;
  final User user;
  final bool isIn;

  const Item({
    Key? key,
    required this.onConfirm,
    required this.user,
    this.isIn = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!user.isOut) {
          onConfirm(user);
        }
      },
      child: Card(
        color: user.isOut ? Colors.white60 : Theme.of(context).colorScheme.onSecondary,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "ทะเบียน ${user.vehicleRegistration}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "เวลาเข้า ${DateFormat.Hms().format(user.inTime!)}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      isIn
                          ? "บ้านเลขที่ ${user.houseNumber}"
                          : "เวลาออก ${DateFormat.Hms().format(user.outTime ?? user.inTime!)}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              !isIn
                  ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            "บ้านเลขที่ ${user.houseNumber}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
