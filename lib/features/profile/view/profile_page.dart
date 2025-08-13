import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/features/auth/login/view/login.dart';
import 'package:salonika/utils/navigator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, dynamic>> menuItems = [
    {"icon": IconlyBroken.heart, "title": "Favorites", "onTap": () {}},
    {"icon": IconlyBroken.wallet, "title": "Payments", "onTap": () {}},
    {"icon": IconlyBroken.setting, "title": "Settings", "onTap": () {}},
    {"icon": Icons.local_offer_outlined, "title": "Promotions", "onTap": () {}},
    {"icon": IconlyBroken.info_circle, "title": "About", "onTap": () {}},
    {"icon": IconlyBroken.logout, "title": "Logout", "onTap": (context) {}},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton.filledTonal(
              icon: const Icon(IconlyBroken.edit, color: Colors.green),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/tractor.jpg'),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Joel Bless Addo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Farmer",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                icon: const Icon(IconlyBroken.call, color: Colors.green),
                onPressed: () {},
              ),
              const Text("0594191843"),
              const SizedBox(width: 20),
              IconButton.filledTonal(
                icon: const Icon(IconlyBroken.message, color: Colors.green),
                onPressed: () {},
              ),
              const Text("johndoe@gmail.com"),
            ],
          ),
          const SizedBox(height: 20),
          Divider(thickness: 1, color: Colors.grey.shade300),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    leading: Icon(
                      menuItems[index]["icon"],
                      color: Colors.green.shade700,
                    ),
                    title: Text(
                      menuItems[index]["title"],
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    onTap: () {
                      customNavigator(context, Login());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
