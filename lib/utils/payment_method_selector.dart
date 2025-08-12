// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

enum PaymentMethod { creditCard, mobileMoney, cashOnDelivery }

class PaymentMethodSelector extends StatefulWidget {
  final PaymentMethod? initialMethod;
  final ValueChanged<PaymentMethod> onChanged;

  const PaymentMethodSelector({
    super.key,
    this.initialMethod,
    required this.onChanged,
  });

  @override
  _PaymentMethodSelectorState createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  PaymentMethod? _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialMethod;
  }

  void _onSelect(PaymentMethod method) {
    setState(() => _selectedMethod = method);
    widget.onChanged(method);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Payment Method",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _PaymentOptionTile(
            icon: Icons.credit_card,
            title: "Credit/Debit Card",
            subtitle: "Visa, MasterCard, etc.",
            isSelected: _selectedMethod == PaymentMethod.creditCard,
            onTap: () => _onSelect(PaymentMethod.creditCard),
          ),
          _PaymentOptionTile(
            icon: Icons.account_balance_wallet,
            title: "Mobile Money",
            subtitle: "MTN, Vodafone, AirtelTigo",
            isSelected: _selectedMethod == PaymentMethod.mobileMoney,
            onTap: () => _onSelect(PaymentMethod.mobileMoney),
          ),
          _PaymentOptionTile(
            icon: Icons.attach_money,
            title: "Cash on Delivery",
            subtitle: "Pay when item is delivered",
            isSelected: _selectedMethod == PaymentMethod.cashOnDelivery,
            onTap: () => _onSelect(PaymentMethod.cashOnDelivery),
          ),
        ],
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? Colors.green : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
