import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Şimdilik sabit bir kampanya kartı tasarımı yapıyoruz.
    // İleride buraya PageView koyup kaydırılabilir yaparız.
    return Container(
      width: double.infinity,
      height: 180, // Banner yüksekliği
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50, // Arka plan rengi
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. Arka Plan Süsü (Opsiyonel)
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.red.withAlpha(30),
            ),
          ),
          
          // 2. Metinler
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "%30 İndirim",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Efsanevi Pokemonlar\nSeni Bekliyor!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  ),
                  child: const Text("Şimdi Keşfet", style: TextStyle(fontSize: 12)),
                )
              ],
            ),
          ),

          // 3. Görsel (Sağ tarafa bir resim)
          Positioned(
            right: 10,
            bottom: 10,
            top: 10,
            child: Image.network(
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png", // Charizard resmi örnek
              fit: BoxFit.contain,
              errorBuilder: (ctx, _, __) => const Icon(Icons.image, size: 50, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}