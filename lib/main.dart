import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MenuItem {
  final String name;
  final int price;
  final String imagePath; // Ubah tipe data menjadi String

  MenuItem({required this.name, required this.price, required this.imagePath});
}

class MyApp extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(name: 'Ayam Kuning', price: 15000, imagePath: 'https://cdn-brilio-net.akamaized.net/news/2020/12/03/196607/1363982-resep-ayam-bumbu-kuning.jpg'),
    MenuItem(name: 'Bubur Ayam', price: 12000, imagePath: 'https://2.bp.blogspot.com/-f9ZLPsXKKg4/Whs1t9wcijI/AAAAAAAACfM/xQNY-fYV3pA0QE1wSd-WinChk_9pB6fXgCLcBGAs/s1600/DSC_0113.JPG'),
    MenuItem(name: 'ES Teh', price: 18000, imagePath: 'https://th.bing.com/th/id/OIP.1V3oGvHDwbBTu13MZdRJhgHaLD?pid=ImgDet&rs=1'),
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuList(menuItems: menuItems),
    );
  }
}

class MenuList extends StatelessWidget {
  final List<MenuItem> menuItems;

  MenuList({required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Makanan'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(menuItems[index].name),
            subtitle: Text('Harga: Rp ${menuItems[index].price}'),
            leading: Image.network(
              menuItems[index].imagePath,
              width: 100,
              height: 100,
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuDetail(menuItem: menuItems[index]),
                  ),
                );
              },
              child: Text('Pesan'),
            ),
          );
        },
      ),
    );
  }
}

class MenuDetail extends StatefulWidget {
  final MenuItem menuItem;

  MenuDetail({required this.menuItem});

  @override
  _MenuDetailState createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    int total = quantity * widget.menuItem.price;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Menu'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Menu: ${widget.menuItem.name}'),
          Text('Harga: Rp ${widget.menuItem.price}'),
          Text('Jumlah Pesanan: $quantity'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (quantity > 1) {
                      quantity--;
                    }
                  });
                },
                child: Text('-'),
              ),
              SizedBox(width: 16),
              Text('$quantity'),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
                child: Text('+'),
              ),
            ],
          ),
          FutureBuilder(
            future: precacheImage(NetworkImage(widget.menuItem.imagePath), context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Image.network(
                  widget.menuItem.imagePath,
                  width: 100,
                  height: 100,
                );
              } else {
                return CircularProgressIndicator(); // or any other loading indicator
              }
            },
          ),
          Text('Total Bayar: Rp $total'),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSummary(menuItem: widget.menuItem, quantity: quantity, total: total),
                ),
              );
            },
            child: Text('Pesan'),
          ),
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final MenuItem menuItem;
  final int quantity;
  final int total;

  OrderSummary({required this.menuItem, required this.quantity, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pemesanan Selesai'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pesanan Anda:'),
          Text('Menu: ${menuItem.name}'),
          Text('Jumlah: $quantity'),
          FutureBuilder(
            future: precacheImage(NetworkImage(menuItem.imagePath), context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Image.network(
                  menuItem.imagePath,
                  width: 100,
                  height: 100,
                );
              } else {
                return CircularProgressIndicator(); // or any other loading indicator
              }
            },
          ),
          Text('Total Bayar: Rp $total'),
        ],
      ),
    );
  }
}

