// lib/features/profile/view/profile_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:salonika/features/auth/login/view/login.dart';

import 'package:salonika/features/profile/view/widgets/about.dart';
import 'package:salonika/features/profile/view/widgets/fav.dart';
import 'package:salonika/features/profile/view/widgets/promo.dart';
import 'package:salonika/utils/navigator.dart';
import '../../auth/auth_view_model/auth_vm.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _db = FirebaseDatabase.instance.ref();

  String _sanitize(String email) =>
      email.replaceAll('.', '_').replaceAll('@', '_');

  Stream<Map<String, dynamic>?> _watchUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return const Stream.empty();
    }
    final key = _sanitize(user.email!);
    return _db.child('users/$key').onValue.map((e) {
      final v = e.snapshot.value;
      if (v == null) return null;
      return Map<String, dynamic>.from(v as Map);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [],
      ),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: _watchUser(),
        builder: (context, snap) {
          final data = snap.data ?? {};
          final fullName =
              (data['fullName'] ?? authUser?.displayName ?? 'Email').toString();
          final email = authUser?.email ?? (data['email'] ?? '').toString();
          final phone = (data['phone'] ?? '').toString();

          return Column(
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/tractor.jpg'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     IconButton.filledTonal(
              //       icon: const Icon(IconlyBroken.call, color: Colors.green),
              //       onPressed: () {}, // optional: add url_launcher to dial
              //     ),
              //     Text(phone.isEmpty ? 'No phone' : phone),
              //   ],
              // ),
              const SizedBox(height: 12),
              Divider(thickness: 1, color: Colors.grey.shade300),

              // Menu
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    _Tile(
                      icon: IconlyBroken.heart,
                      title: 'Favorites',
                      onTap: () =>
                          customNavigator(context, const FavoritesPage()),
                    ),
                    _Tile(
                      icon: Icons.local_offer_outlined,
                      title: 'Promotions',
                      onTap: () =>
                          customNavigator(context, const PromotionsPage()),
                    ),
                    _Tile(
                      icon: IconlyBroken.info_circle,
                      title: 'About',
                      onTap: () => customNavigator(context, const AboutPage()),
                    ),
                    _Tile(
                      icon: IconlyBroken.logout,
                      title: 'Logout',
                      onTap: () async {
                        final vm = Provider.of<AuthViewModel>(
                          context,
                          listen: false,
                        );
                        final confirm =
                            await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            ) ??
                            false;
                        if (!confirm) return;
                        await vm.logout();
                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const Login()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _Tile({required this.icon, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade700),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade500,
        ),
        onTap: onTap,
      ),
    );
  }
}
