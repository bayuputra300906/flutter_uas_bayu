import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/destination_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/destination_form.dart';

class AddDestinationScreen extends StatelessWidget {
  const AddDestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DestinationProvider>();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Tambah Destinasi Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: DestinationForm(
        submitLabel: 'Simpan ke Database',
        successMessage: 'Destinasi wisata berhasil disimpan ke Supabase! ✨',
        onSubmit: provider.add,
      ),
    );
  }
}
