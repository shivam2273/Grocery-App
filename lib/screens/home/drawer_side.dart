import 'package:flutter/material.dart';
import 'package:shiv/auth/sign_in.dart';
import 'package:shiv/providers/complain.dart';
import 'package:shiv/config/colors.dart';
import 'package:shiv/widgets/faq_page.dart';
import 'package:shiv/providers/myOrder.dart';
import 'package:shiv/providers/user_provider.dart';
import 'package:shiv/providers/rating_page.dart';
import 'package:shiv/screens/home/home_screen.dart';
import 'package:shiv/screens/review_cart/review_cart.dart';
import 'package:shiv/screens/wishList/wish_list.dart';


class DrawerSide extends StatefulWidget {
  final UserProvider? userProvider;
  DrawerSide({this.userProvider});
  @override
  _DrawerSideState createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  Widget listTile({String? title, IconData? iconData, Function()? onTap}) {
    return Container(
      height: 50,
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          iconData,
          size: 28,
        ),
        title: Text(
          title!,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider?.currentUserData;
    return Drawer(
      child: Container(
        color: Colors.transparent,
        child: ListView(
          children: [
            DrawerHeader(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 43,
                      backgroundColor: Colors.white54,
                      child: CircleAvatar(
                        backgroundColor: Colors.yellow,
                        backgroundImage: NetworkImage(
                          userData?.userImage ??
                              "https://s3.envato.com/files/328957910/vegi_thumb.png",
                        ),
                        radius: 40,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userData?.userName ?? 'User Name Not Available'),
                        Text(
                          userData?.userEmail ?? 'Email Not Available',
                          overflow: TextOverflow.ellipsis,
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
            listTile(
              iconData: Icons.home_outlined,
              title: "Home",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            listTile(
              iconData: Icons.shop_outlined,
              title: "Review Cart",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReviewCart(),
                  ),
                );
              },
            ),
            // listTile(
            //   iconData: Icons.person_outlined,
            //   title: "My Profile",
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => MyProfile(userProvider:widget.userProvider!),
            //       ),
            //     );
            //   },
            // ),
            listTile(iconData: Icons.shopping_cart , title: "My Order",
              onTap: () {
               Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyOrderPage(),
                  ),
                );// Close the drawer
              }
            ),
                //iconData: Icons.notifications_outlined, title: "Notification"),

            listTile(iconData: Icons.star_outline, title: "Rating & Review",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RatingPage(),
                  ),
                );
              },
            ),
            listTile(
                iconData: Icons.favorite_outline,
                title: "Wishlist",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  WishLsit(),
                    ),
                  );
                }),
            listTile(iconData: Icons.copy_outlined, title: "Raise a Complaint",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RaiseComplain(), // Navigate to FAQPage
                  ),
                );
              },),
            listTile(iconData: Icons.format_quote_outlined, title: "FAQs",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FAQPage(), // Navigate to FAQPage
                  ),
                );
              },
            ),
            listTile(
              iconData: Icons.logout,
              title: "Logout",
              onTap: () async {
                await widget.userProvider?.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => SignIn(),
                ));
              },
            ),
            Container(
              height: 350,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Contact Support"),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("Call us:"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("+918793311328"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text("Mail us:"),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "thakurshivamsingh63@gmail.com",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
