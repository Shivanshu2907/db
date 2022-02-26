import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoping_app/database/db_provider.dart';
import 'package:shoping_app/methods/cart_methods.dart';
import 'package:shoping_app/modals/product_modat.dart';
import 'package:cool_alert/cool_alert.dart';
import '../globals.dart' as globals;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Product extends StatefulWidget {
  String imgurl;
  String buyCost;
  String sellcost;
  String productName;
  ProductModal product;

  Product({
    Key? key,
    required this.buyCost,
    required this.imgurl,
    required this.sellcost,
    required this.productName,
    required this.product,
  }) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> with SingleTickerProviderStateMixin {
  Future<bool> addToCart(String url, String name, String buyPrice,
      String sellPrice, int quantity) async {
    print('getImage function called');
    File image = File(url);
    Uint8List bytes = image.readAsBytesSync();
    print('saving image');
    int i = await DbProvider.instance
        .add(url, bytes, name, buyPrice, sellPrice, quantity);
    print('saved image');
    print('the id we got is $i');
    if (i != null) {
      return true;
    }

    return false;
  }

  Future<String> _findPath(String imageUrl) async {
    final cache = DefaultCacheManager(); // Gives a Singleton instance
    final file = await cache.getSingleFile(imageUrl);
    return file.path;
  }

  @override
  void initState() {
    super.initState();
  }

  String url =
      "https://www.ifbappliances.com/media/catalog/product/cache/1/image/550x629/9df78eab33525d08d6e5fb8d27136e95/m/a/maxidry-550-side-angle-clothes-dryer_1.jpg";
  String okURL =
      "https://thumbs.dreamstime.com/b/placeholder-rgb-color-icon-image-gallery-photo-thumbnail-available-album-digital-media-multimedia-file-visual-content-snapshot-187369540.jpg";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Card(
        elevation: 7,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CachedNetworkImage(
                imageUrl: widget.imgurl == url ? okURL : widget.imgurl,
                placeholder: (context, url) => Transform.scale(
                  scale: 0.35,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.shop_sharp),
              title: Text(widget.productName),
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
                        widget.buyCost,
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
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      Text(
                        widget.sellcost,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String path = '';
                    await _findPath(widget.imgurl).then((value) {
                      path = value.toString();
                      print(
                        value.toString(),
                      );
                    });
                    bool isAdded = await addToCart(path, widget.productName,
                        widget.buyCost, widget.sellcost, 1);

                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: 'Item added to cart',
                        autoCloseDuration: const Duration(seconds: 2));
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Icon starIcon(Color color) {
    return Icon(
      Icons.star,
      size: 10.0,
      color: color,
    );
  }
}
