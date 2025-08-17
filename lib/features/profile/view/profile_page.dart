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
  DatabaseReference? _userRef;

  String _sanitize(String email) =>
      email.replaceAll('.', '_').replaceAll('@', '_');

  @override
  void initState() {
    super.initState();
    _resolveUserRef();
  }

  Future<void> _resolveUserRef() async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) return;

    // Try users/<uid>
    final uidRef = _db.child('users/${authUser.uid}');
    final uidSnap = await uidRef.get();
    if (uidSnap.exists) {
      setState(() => _userRef = uidRef);
      return;
    }

    // Fallback users/<sanitizedEmail> (legacy)
    final email = authUser.email;
    if (email != null) {
      final legacyRef = _db.child('users/${_sanitize(email)}');
      final legSnap = await legacyRef.get();
      if (legSnap.exists) {
        setState(() => _userRef = legacyRef);
        return;
      }
    }

    // Nothing found — still show auth fallback
    setState(() => _userRef = null);
  }

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: _userRef == null
          ? _AuthFallback(authUser: authUser)
          : StreamBuilder<DatabaseEvent>(
              stream: _userRef!.onValue,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                Map<String, dynamic> data = {};
                final raw = snap.data?.snapshot.value;
                if (raw is Map) {
                  data = Map<String, dynamic>.from(raw as Map);
                }

                final fullName =
                    (data['fullName'] ?? authUser?.displayName ?? 'Your name')
                        .toString();
                final email = (data['email'] ?? authUser?.email ?? '')
                    .toString();
                final phone = (data['phone'] ?? '').toString();

                return Column(
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                if (email.isNotEmpty)
                                  Text(
                                    email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                if (phone.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    phone,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            onTap: () => customNavigator(
                              context,
                              const PromotionsPage(),
                            ),
                          ),
                          _Tile(
                            icon: IconlyBroken.info_circle,
                            title: 'About',
                            onTap: () =>
                                customNavigator(context, const AboutPage()),
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
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Logout'),
                                      content: const Text(
                                        'Are you sure you want to logout?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
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
                                MaterialPageRoute(
                                  builder: (_) => const Login(),
                                ),
                                (_) => false,
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

class _AuthFallback extends StatelessWidget {
  final User? authUser;
  const _AuthFallback({required this.authUser});
  @override
  Widget build(BuildContext context) {
    final fullName = authUser?.displayName ?? 'Your name';
    final email = authUser?.email ?? '';
    return Column(
      children: [
        const SizedBox(height: 24),
        ListTile(
          leading: const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('assets/tractor.jpg'),
          ),
          title: Text(
            fullName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: email.isNotEmpty ? Text(email) : null,
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "We couldn't find a profile record in the database.\n"
            "You can continue using your auth info.",
            textAlign: TextAlign.center,
          ),
        ),
      ],
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
