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

    // Listener untuk memperbarui Live Preview gambar seketika saat URL diketik / di-paste
    _image.addListener(_onImageChanged);
  }

  void _onImageChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _image.removeListener(_onImageChanged);
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

    final inputUrl = _image.text.trim();

    // Menyimpan PERSIS seperti yang di-input pengguna
    final destination = Destination(
      id: widget.initial?.id,
      name: _name.text.trim(),
      location: _location.text.trim(),
      category: _category,
      description: _description.text.trim(),
      imageUrl: inputUrl.isNotEmpty ? inputUrl : defaultCategoryImage(_category),
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
    final currentImageUrl = _image.text.trim();
    final isPinterestWeb = currentImageUrl.contains('pinterest.com/pin/') ||
        currentImageUrl.contains('id.pinterest.com/pin/');

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
                  hintText: 'Contoh: Babi Guling Gianyar / Kelingking Beach',
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
                  hintText: 'Contoh: Gianyar, Bali',
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
                  if (val != null) {
                    setState(() {
                      _category = val;
                      // Jika kolom gambar masih kosong, beri foto default kategori
                      if (_image.text.trim().isEmpty) {
                        _image.text = defaultCategoryImage(val);
                      }
                    });
                  }
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

              // KOLOM URL GAMBAR WAJIB + TOMBOL REKOMENDASI
              TextFormField(
                controller: _image,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'URL Gambar Destinasi *',
                  hintText: 'https://images.unsplash.com/... atau link .jpg / .png',
                  prefixIcon: const Icon(Icons.image_rounded),
                  suffixIcon: IconButton(
                    tooltip: 'Gunakan Foto Rekomendasi Sesuai Kategori',
                    icon: const Icon(Icons.auto_fix_high_rounded, color: kPrimaryColor),
                    onPressed: () {
                      setState(() {
                        _image.text = defaultCategoryImage(_category);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Foto rekomendasi berhasil diterapkan! ✨'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  border: const OutlineInputBorder(),
                  helperText: 'Wajib link file gambar langsung (misal Unsplash, atau berakhiran .jpg / .png).',
                  helperMaxLines: 2,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'URL gambar wajib diisi. Tekan ikon tongkat ajaib ✨ untuk foto otomatis.';
                  }
                  final clean = val.trim().toLowerCase();
                  if (!clean.startsWith('http://') && !clean.startsWith('https://')) {
                    return 'URL harus diawali http:// atau https://';
                  }
                  if (clean.contains('pinterest.com/pin/')) {
                    return 'Peringatan: Ini link halaman Pinterest, bukan file gambar. Klik kanan foto di Pinterest ➔ Salin Alamat Gambar.';
                  }
                  return null;
                },
              ),

              // PINTASAN REKOMENDASI GAMBAR POPULER BALI
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _PhotoPresetChip(
                    label: '🍲 Foto Babi Guling',
                    url: 'https://images.unsplash.com/photo-1570275239833-cf846839b0f8?auto=format&fit=crop&w=1200&q=85',
                    onSelect: (url) => setState(() => _image.text = url),
                  ),
                  _PhotoPresetChip(
                    label: '🌋 Foto Gunung Agung',
                    url: 'https://images.unsplash.com/photo-1698529471890-fddb93a2954f?auto=format&fit=crop&w=1200&q=85',
                    onSelect: (url) => setState(() => _image.text = url),
                  ),
                  _PhotoPresetChip(
                    label: '🏖️ Foto Pantai Bali',
                    url: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=85',
                    onSelect: (url) => setState(() => _image.text = url),
                  ),
                ],
              ),

              // LIVE IMAGE PREVIEW CONTAINER
              const SizedBox(height: 14),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPinterestWeb
                        ? Colors.red.shade300
                        : (currentImageUrl.isNotEmpty ? kPrimaryColor.withValues(alpha: 0.3) : Colors.black12),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: currentImageUrl.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.image_search_rounded, size: 40, color: Colors.black26),
                              SizedBox(height: 6),
                              Text(
                                'Ketik atau tempel URL gambar di atas untuk melihat preview',
                                style: TextStyle(fontSize: 12, color: Colors.black45),
                              ),
                            ],
                          ),
                        )
                      : isPinterestWeb
                          ? Container(
                              padding: const EdgeInsets.all(16),
                              color: Colors.red.shade50,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.warning_amber_rounded, size: 36, color: Colors.red),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'URL Halaman Web Pinterest Terdeteksi!',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Flutter tidak dapat membaca halaman web sebagai gambar.\nCara benar: Klik Kanan pada foto di Pinterest ➔ "Salin Alamat Gambar" (diawali i.pinimg.com).',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 11, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  currentImageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    padding: const EdgeInsets.all(16),
                                    color: Colors.amber.shade50,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.broken_image_rounded, size: 36, color: Colors.amber),
                                          const SizedBox(height: 6),
                                          const Text(
                                            'Gambar Gagal Dimuat',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Periksa kembali URL gambar atau gunakan tombol rekomendasi di atas.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(color: kPrimaryColor),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.65),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 12),
                                        SizedBox(width: 4),
                                        Text(
                                          'Preview Gambar',
                                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

class _PhotoPresetChip extends StatelessWidget {
  const _PhotoPresetChip({
    required this.label,
    required this.url,
    required this.onSelect,
  });

  final String label;
  final String url;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.photo_library_rounded, size: 14, color: kPrimaryColor),
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.white,
      side: BorderSide(color: kPrimaryColor.withValues(alpha: 0.3)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () => onSelect(url),
    );
  }
}
