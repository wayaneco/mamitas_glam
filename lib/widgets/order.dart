import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final int index;
  final DateTime date;
  final List<dynamic> children;
  final double totalPrice;
  final String status;

  const OrderItem({
    Key? key,
    required this.index,
    required this.date,
    required this.children,
    required this.totalPrice,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        child: FittedBox(
          child: Text((index + 1).toString()),
        ),
      ),
      title: Text(DateFormat('MMMM d, y').format(date)),
      subtitle: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            const Text(
              'Total: ',
            ),
            Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
      trailing: SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Chip(
              label: Text(status, style: const TextStyle(color: Colors.white)),
              backgroundColor: status == 'PENDING' ? Colors.blue : Colors.green,
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      children: [
        const Divider(),
        ...children.map(
          (item) {
            return Flex(
              direction: Axis.vertical,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Text(
                        item['title'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child: Text(
                        '\$${item['price']} x ${item['quantity']} = ',
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Text(
                        '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    )
                  ],
                ),
                const Divider(),
              ],
            );
          },
        ).toList(),
        Row(
          children: [
            Flexible(flex: 3, fit: FlexFit.tight, child: Container()),
            Flexible(flex: 3, fit: FlexFit.tight, child: Container()),
            Flexible(
              flex: 2,
              child: Chip(
                backgroundColor: Colors.blue,
                label: Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
