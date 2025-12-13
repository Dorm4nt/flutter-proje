import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product? product; // Eğer null ise "Yeni Ekle", dolu ise "Düzenle" modudur
  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late String _description;
  late String _imageUrl;
  late String _category;
  late int _stock;

  @override
  void initState() {
    super.initState();
    // Başlangıç değerlerini ata
    _name = widget.product?.name ?? '';
    _price = widget.product?.price ?? 0;
    _description = widget.product?.description ?? '';
    _imageUrl = widget.product?.imageUrl ?? '';
    _category = widget.product?.category ?? 'Genel';
    _stock = widget.product?.stock ?? 1;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<ProductProvider>(context, listen: false);

      final newProduct = Product(
        id: widget.product?.id ?? DateTime.now().toString(),
        name: _name,
        category: _category,
        price: _price,
        stock: _stock,
        description: _description,
        imageUrl: _imageUrl,
      );

      if (widget.product != null) {
        provider.updateProduct(widget.product!.id, newProduct);
      } else {
        provider.addProduct(newProduct);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? "Yeni Ürün Ekle" : "Ürün Düzenle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Ürün Adı'),
                validator: (val) => val!.isEmpty ? 'İsim gerekli' : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Fiyat'),
                keyboardType: TextInputType.number,
                validator: (val) => double.tryParse(val!) == null ? 'Geçerli sayı gir' : null,
                onSaved: (val) => _price = double.parse(val!),
              ),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori'),
                onSaved: (val) => _category = val!,
              ),
               TextFormField(
                initialValue: _stock.toString(),
                decoration: const InputDecoration(labelText: 'Stok Adeti'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _stock = int.parse(val!),
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                onSaved: (val) => _description = val!,
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: const InputDecoration(labelText: 'Resim URL'),
                keyboardType: TextInputType.url,
                validator: (val) => val!.isEmpty ? 'Resim URL gerekli' : null,
                onSaved: (val) => _imageUrl = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveForm, child: const Text("KAYDET"))
            ],
          ),
        ),
      ),
    );
  }
}