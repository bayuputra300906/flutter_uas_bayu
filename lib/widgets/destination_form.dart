import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../utils/constants.dart';

class DestinationForm extends StatefulWidget {
  const DestinationForm({
    super.key,
    this.initial,
    required this.submitLabel,
    required this.successMessage,
    required this.onSubmit,
  });

  final Destination? initial;
  final String submitLabel;
  final String successMessage;

  /// Mengembalikan null jika sukses, atau pesan error.
  final Future<String?> Function(Destination) onSubmit;

  @override
  State<DestinationForm> createState() => _DestinationFormState();
}

class _DestinationFormState extends State<DestinationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _location;
  late final TextEditingController _price;
  late final TextEditingController _rating;
  late final TextEditingController _image;
  late final TextEditingController _description;
  late final TextEditingController _tags;
  late String _category;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initial;
    _name = TextEditingController(text: d?.name ?? '');
    _location = TextEditingController(text: d?.location ?? '');
    _price = TextEditingController(text: d == null ? '' : d.price.round().toString());
    _rating = TextEditingController(text: d == null ? '4.8' : d.rating.toString());
    _image = TextEditingController(text: d?.imageUrl ?? '');
    _description = TextEditingController(text: d?.description ?? '');
    _tags = TextEditingController(
      text: d != null && d.tags.isNotEmpty
          ? d.tags.join(', ')
          : '24/7 Access, Scenic View, Island Friendly',
    );
    _category = d?.category ?? kCategories.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    _price.dispose();
    _rating.dispose();
    _image.dispose();
    _description.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final parsedTags = _tags.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final destination = Destination(
      id: widget.initial?.id,
      name: _name.text.trim(),
      location: _location.text.trim(),
      category: _category,
      description: _description.text.trim(),
      imageUrl: _image.text.trim().isEmpty
          ? 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=85'
          : _image.text.trim(),
      price: double.tryParse(_price.text.trim()) ?? 0.0,
      rating: double.tryParse(_rating.text.trim().replaceAll(',', '.')) ?? 4.5,
      tags: parsedTags.isEmpty ? const ['24/7 Access', 'Scenic View'] : parsedTags,
    );

    setState(() => _saving = true);
    final error = await widget.onSubmit(destination);
    if (!mounted) return;
    setState(() => _saving = false);

    final messenger = ScaffoldMessenger.of(context);
    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $error'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(widget.successMessage),
        backgroundColor: kPrimaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Nama Destinasi *',
                  hintText: 'Contoh: Kelingking Beach',
                  prefixIcon: Icon(Icons.place_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama destinasi wajib diisi';
                  if (val.trim().length < 3) return 'Minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(
                  labelText: 'Lokasi *',
                  hintText: 'Contoh: Nusa Penida, Klungkung, Bali',
                  prefixIcon: Icon(Icons.location_on_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Lokasi wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: kCategories.contains(_category) ? _category : kCategories.first,
                decoration: const InputDecoration(
                  labelText: 'Kategori *',
                  prefixIcon: Icon(Icons.category_rounded),
                  border: OutlineInputBorder(),
                ),
                items: kCategories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _category = val);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Tiket (Rp) *',
                        hintText: '25000',
                        prefixIcon: Icon(Icons.monetization_on_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                        final numVal = double.tryParse(val.trim());
                        if (numVal == null || numVal < 0) return 'Angka tidak valid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _rating,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Rating (1.0 - 5.0) *',
                        hintText: '4.8',
                        prefixIcon: Icon(Icons.star_rounded),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                        final numVal = double.tryParse(val.trim().replaceAll(',', '.'));
                        if (numVal == null || numVal < 1.0 || numVal > 5.0) {
                          return 'Nilai 1.0 s/d 5.0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _image,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar (Opsional)',
                  hintText: 'https://images.unsplash.com/...',
                  prefixIcon: Icon(Icons.image_rounded),
                  border: OutlineInputBorder(),
                  helperText: 'Biarkan kosong untuk menggunakan gambar default Bali',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tags,
                decoration: const InputDecoration(
                  labelText: 'Fasilitas & Keunggulan (pisahkan koma)',
                  hintText: '24/7 Access, Scenic View, Island Friendly',
                  prefixIcon: Icon(Icons.label_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _description,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Destinasi *',
                  hintText: 'Ceritakan keindahan dan daya tarik destinasi ini...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Deskripsi wajib diisi';
                  if (val.trim().length < 10) return 'Minimal 10 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    _saving ? 'Menyimpan...' : widget.submitLabel,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
