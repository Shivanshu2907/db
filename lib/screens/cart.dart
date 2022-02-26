import 'package:flutter/material.dart';
import 'package:shoping_app/database/db_provider.dart';
import 'package:shoping_app/methods/cart_methods.dart';
import 'package:shoping_app/modals/product_modat.dart';
import 'package:cool_alert/cool_alert.dart';

class Cart extends StatefulWidget {
  const Cart({
    Key? key,
  }) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with SingleTickerProviderStateMixin {
  String url =
      "https://www.ifbappliances.com/media/catalog/product/cache/1/image/550x629/9df78eab33525d08d6e5fb8d27136e95/m/a/maxidry-550-side-angle-clothes-dryer_1.jpg";
  String okURL =
      "https://thumbs.dreamstime.com/b/placeholder-rgb-color-icon-image-gallery-photo-thumbnail-available-album-digital-media-multimedia-file-visual-content-snapshot-187369540.jpg";
  @override
  void initState() {
    super.initState();
  }

  Icon starIcon(Color color) {
    return Icon(
      Icons.star,
      size: 10.0,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: DbProvider.instance.getItems(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Text('no data');
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 7,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Image.memory(
                        snapshot.data![index]['picture'],
                        fit: BoxFit.fill,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.shop_sharp),
                      title: Text(snapshot.data![index]['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Product MRP : ',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                              Text(
                                snapshot.data![index]['buyPrice'],
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Selling Price : ',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              Text(
                                snapshot.data![index]['sellPrice'],
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  DbProvider.instance
                                      .delete(snapshot.data![index]['name']);
                                  setState(() {});
                                },
                                child: const Text('Remove'),
                              ),
                              const SizedBox(
                                width: 60,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await DbProvider.instance.decreaseQuantity(
                                      snapshot.data![index]['name']);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                snapshot.data![index]['quantity'].toString(),
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await DbProvider.instance.increaseQuantity(
                                      snapshot.data![index]['name']);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
