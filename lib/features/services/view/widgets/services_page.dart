import 'package:flutter/material.dart';
import 'package:salonika/features/services/view/service.dart';

class Servicespage extends StatefulWidget {
  const Servicespage({super.key});

  @override
  State<Servicespage> createState() => _ServicespageState();
}

class _ServicespageState extends State<Servicespage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ServiceRequestPage());
  }
}
