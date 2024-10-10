import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/consts/firebase_consts.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';

// class HeartBTN extends StatefulWidget {
//   const HeartBTN({Key? key, required this.productId, this.isInWishlist = false})
//       : super(key: key);
//   final String productId;
//   final bool? isInWishlist;
//
//   @override
//   State<HeartBTN> createState() => _HeartBTNState();
// }

// class _HeartBTNState extends State<HeartBTN> {
//   bool loading = false;
//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductsProvider>(context);
//     final getCurrProduct = productProvider.findProdById(widget.productId);
//     final wishlistProvider = Provider.of<WishlistProvider>(context);
//     final Color color = Utils(context).color;
//     return GestureDetector(
//       onTap: () async {
//         setState(() {
//           loading = true;
//         });
//         try {
//           final User? user = authInstance.currentUser;
//
//           if (user == null) {
//             GlobalMethods.errorDialog(
//                 subtitle: 'No user found, Please login first',
//                 context: context);
//             return;
//           }
//           if (widget.isInWishlist == false && widget.isInWishlist != null) {
//             await GlobalMethods.addToWishList(
//                 productId: widget.productId, context: context);
//           } else {
//             await wishlistProvider.removeOneItem(
//                 wishlistId:
//                     wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
//                 productId: widget.productId);
//           }
//           await wishlistProvider.fetchWishList();
//           setState(() {
//             loading = false;
//           });
//         } catch (error) {
//           GlobalMethods.errorDialog(subtitle: '$error', context: context);
//         } finally {
//           setState(() {
//             loading = false;
//           });
//         }
//         // final User? user = authInstance.currentUser;
//         // if (user == null) {
//         //   GlobalMethods.errorDialog(
//         //       subtitle: "No user found, Please login first", context: context);
//         //   return;
//         // }
//
//         //print('User Id is: $user.uid');
//         // wishlistProvider.addRemoveProductToWishlist(productId: productId);
//         // wishlistProvider.fetchWishlist();
//       },
//       child: loading
//           ? const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: SizedBox(
//                   height: 20, width: 20, child: CircularProgressIndicator()),
//             )
//           : Icon(
//               widget.isInWishlist != null && widget.isInWishlist == true
//                   ? IconlyBold.heart
//                   : IconlyLight.heart,
//               size: 22,
//               color: widget.isInWishlist != null && widget.isInWishlist == true
//                   ? Colors.red
//                   : color,
//             ),
//     );
//   }
// }
class HeartBTN extends StatefulWidget {
  const HeartBTN({Key? key, required this.productId, this.isInWishlist = false})
      : super(key: key);

  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;
  late bool isFavorited; // Internal state to track if the item is favorited

  @override
  void initState() {
    super.initState();
    isFavorited =
        widget.isInWishlist ?? false; // Initialize the favorited state
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;

    return GestureDetector(
      onTap: () async {
        setState(() {
          loading = true; // Set loading state
        });

        try {
          final User? user = authInstance.currentUser;

          if (user == null) {
            // Show the error dialog
            await GlobalMethods.errorDialog(
              subtitle: 'No User Found, Please login first',
              context: context,
            );

            // Redirect to the login screen
            await Navigator.pushNamed(
                context, '/LoginScreen'); // Change '/login' to your login route
            return;
          }

          // Toggle the favorite state
          if (!isFavorited) {
            await GlobalMethods.addToWishList(
                productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
              wishlistId:
                  wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
              productId: widget.productId,
            );
          }

          await wishlistProvider.fetchWishList(); // Refresh the wishlist

          // Toggle internal state
          setState(() {
            isFavorited = !isFavorited; // Update the favorite state
          });
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {
          setState(() {
            loading = false; // Reset loading state
          });
        }
      },
      child: loading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Icon(
              isFavorited
                  ? IconlyBold.heart
                  : IconlyLight.heart, // Change icon based on favorite state
              size: 22,
              color: isFavorited
                  ? Colors.red
                  : color, // Change color based on favorite state
            ),
    );
  }
}
