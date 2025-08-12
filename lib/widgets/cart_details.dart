import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/screens/check_out_page.dart';

class CartDetails extends StatefulWidget {
  const CartDetails({super.key});

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Cart Details",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton.filledTonal(
                  icon: Icon(IconlyBroken.bag, size: 28),
                  onPressed: () {},
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: const Text(
                      "3",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Cart Item
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              separatorBuilder: (_, __) =>
                  const Divider(thickness: 0.8, color: Colors.grey),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 40),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product name",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Product description",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Ghc 29.99",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            IconlyBroken.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(height: 3),
                        Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.remove, size: 18),
                                ),
                              ),
                              const Text(
                                "1",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.add, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Coupon Code Field
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.local_offer_outlined, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Add coupon code",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Total:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₵ 348.50 GHC",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Checkout()),
                    );
                  },
                  child: const Text(
                    "Proceed to Checkout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
