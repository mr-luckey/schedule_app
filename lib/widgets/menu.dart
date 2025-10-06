import 'package:flutter/material.dart';
import 'package:schedule_app/theme/app_colors.dart';
import 'package:schedule_app/widgets/booking_summary.dart';

class FoodBeverageSelection extends StatefulWidget {
  final int guestCount;

  const FoodBeverageSelection({super.key, required this.guestCount});

  @override
  _FoodBeverageSelectionState createState() => _FoodBeverageSelectionState();
}

class _FoodBeverageSelectionState extends State<FoodBeverageSelection> {
  bool isConfirmed = false;
  bool isEditing = false;

  late Map<String, List<Map<String, dynamic>>> menu;

  final List<Map<String, dynamic>> availableFood = [
    // {"name": "Chicken Tikka", "price": 250.0},
    // {"name": "Paneer Tikka", "price": 250.0},
    // {"name": "Mutton Biryani", "price": 350.0},
    // {"name": "Butter Chicken", "price": 300.0},
    // {"name": "Gulab Jamun", "price": 150.0},
    // {"name": "Ice Cream", "price": 200.0},
    // {"name": "Soft Drinks", "price": 100.0},
    // {"name": "Mocktails", "price": 180.0},
  ];

  final List<Map<String, dynamic>> availableServices = [
    // {"name": "Waiter Service", "price": 1000.0},
    // {"name": "Decoration", "price": 2000.0},
    // {"name": "DJ", "price": 3000.0},
    // {"name": "Lighting", "price": 1500.0},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize menu with guestCount as qty for food items, services default to qty 1
    menu = {
      "Food Items": [
        // {"name": "Chicken Tikka", "price": 250.0, "qty": widget.guestCount},
        // {"name": "Paneer Tikka", "price": 250.0, "qty": widget.guestCount},
      ],
      "Services": [
        // {"name": "Waiter Service", "price": 1000.0, "qty": 1},
      ],
    };

    // Remove already added defaults from available lists
    availableFood.removeWhere(
      (item) => menu["Food Items"]!.any((dish) => dish["name"] == item["name"]),
    );
    availableServices.removeWhere(
      (item) => menu["Services"]!.any((srv) => srv["name"] == item["name"]),
    );
  }

  double get foodAndBeverageCost {
    double total = 0;
    for (var section in menu.values) {
      for (var dish in section) {
        final int qty = (dish["qty"] as int);
        final double price = (dish["price"] as double);
        total += qty * price;
      }
    }
    return total;
  }

  double get serviceCharges => 0.10 * (foodAndBeverageCost);
  double get tax => 0.13 * (foodAndBeverageCost + serviceCharges);
  double get totalAmount => foodAndBeverageCost + serviceCharges + tax;

  void increment(Map<String, dynamic> dish) {
    setState(() => dish["qty"] = (dish["qty"] ?? 0) + 1);
  }

  void decrement(Map<String, dynamic> dish) {
    setState(() {
      if ((dish["qty"] ?? 0) > 0) {
        dish["qty"] = (dish["qty"] ?? 0) - 1;
      }
    });
  }

  void removeDish(String category, Map<String, dynamic> dish) {
    setState(() {
      menu[category]?.remove(dish);

      // Add back to available lists
      if (category == "Food Items") {
        availableFood.add({"name": dish["name"], "price": dish["price"]});
      } else if (category == "Services") {
        availableServices.add({"name": dish["name"], "price": dish["price"]});
      }
    });
  }

  void addDish(String category) {
    final options = category == "Food Items"
        ? availableFood
        : availableServices;
    Map<String, dynamic>? selectedItem;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add $category"),
          content: options.isEmpty
              ? const Text("No more items available.")
              : StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return DropdownButton<Map<String, dynamic>>(
                      isExpanded: true,
                      value: selectedItem,
                      hint: const Text("Select an item"),
                      items: options.map((item) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: item,
                          child: Text("${item["name"]} (£${item["price"]})"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedItem = value;
                        });
                      },
                    );
                  },
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedItem != null) {
                  setState(() {
                    menu[category]!.add({
                      "name": selectedItem!["name"],
                      "price": selectedItem!["price"],
                      "qty": category == "Food Items" ? widget.guestCount : 1,
                    });
                    options.remove(selectedItem); // Remove from available
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget buildItemRow(String category, Map<String, dynamic> dish) {
    final isFoodItem = category == "Food Items";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dish name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dish["name"], style: const TextStyle(fontSize: 15)),
                Text(
                  "£${(dish["price"] as double).toStringAsFixed(0)} per person",
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),

          // Quantity
          if (isFoodItem && isEditing)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_outlined, size: 20),
                    onPressed: () => decrement(dish),
                  ),
                  Text(
                    dish["qty"].toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () => increment(dish),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Qty: ${dish["qty"]}"),
            ),

          // Remove button
          if ((isFoodItem && isEditing) || (!isFoodItem))
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: () => removeDish(category, dish),
            ),
        ],
      ),
    );
  }

  Widget buildSummary() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            summaryRow("Food & Beverage", foodAndBeverageCost),
            summaryRow("Service Charges (10%)", serviceCharges),
            summaryRow("Tax (13%)", tax),
            const Divider(),
            summaryRow("Total Amount", totalAmount, isBold: true, fontSize: 18),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(
    String label,
    double value, {
    bool isBold = false,
    double fontSize = 16,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "£${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isConfirmed) {
      return BookingSummary();
    }

    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Food Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Food Items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () => addDish("Food Items"),
                ),
              ],
            ),
            const Divider(),
            ...menu["Food Items"]!.map(
              (dish) => buildItemRow("Food Items", dish),
            ),

            const SizedBox(height: 20),

            // Services Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Services",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () => addDish("Services"),
                ),
              ],
            ),
            const Divider(),
            ...menu["Services"]!.map(
              (service) => buildItemRow("Services", service),
            ),

            buildSummary(),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: Text(isEditing ? "Done" : "Edit"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isConfirmed = true;
                    });
                  },
                  child: const Text("Confirm Booking"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
