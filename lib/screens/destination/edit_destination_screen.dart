import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/destination.dart';
import '../../providers/destination_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/destination_form.dart';

class EditDestinationScreen extends StatelessWidget {
  const EditDestinationScreen({super.key, required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DestinationProvider>();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Edit Data Destinasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: DestinationForm(
        initial: destination,
        submitLabel: 'Simpan Perubahan',
        successMessage: 'Data destinasi berhasil diperbarui di Supabase! ✨',
        onSubmit: provider.update,
      ),
    );
  }
}
