import 'package:flutter/material.dart';

String capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

class CommonUtils {
  static const Map<String, (IconData, Color)> categoryMeta = {
    'All': (Icons.grid_view_rounded, Color(0xFF00BFA5)),
    'Food': (Icons.restaurant_rounded, Color(0xFFFF7043)),
    'Transport': (Icons.directions_car_rounded, Color(0xFF42A5F5)),
    'Shopping': (Icons.shopping_bag_rounded, Color(0xFFAB47BC)),
    'Health': (Icons.favorite_rounded, Color(0xFFEF5350)),
    'Entertainment': (Icons.local_movies_rounded, Color(0xFFFFCA28)),
    'Utilities': (Icons.bolt_rounded, Color(0xFF26C6DA)),
    'Travel': (Icons.flight_takeoff_rounded, Color(0xFF26A69A)),
    'Other': (Icons.more_horiz_rounded, Color(0xFF78909C)),
  };
}
