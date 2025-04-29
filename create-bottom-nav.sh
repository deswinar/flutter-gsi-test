#!/bin/bash

# ========== Configuration ==========
FEATURE_NAME_RAW=${1:-main_menu}
FEATURE_NAME=$(echo "$FEATURE_NAME_RAW" | sed -r 's/([A-Z])/_\L\1/g' | sed -r 's/^_//')
PASCAL_CASE=$(echo "$FEATURE_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')
BASE_PATH="lib/features/$FEATURE_NAME"

# ========== Create Directory Structure ==========
mkdir -p "$BASE_PATH/presentation/widgets"
mkdir -p "$BASE_PATH/presentation/pages"

# ========== Create AppBottomNavBar ==========
NAV_WIDGET="$BASE_PATH/presentation/widgets/app_bottom_nav_bar.dart"
cat <<EOF > $NAV_WIDGET
import 'package:flutter/material.dart';
import '../menu_config.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: bottomNavBarItems,
    );
  }
}
EOF

# ========== Create Menu Config ==========
MENU_CONFIG="$BASE_PATH/presentation/menu_config.dart"
cat <<EOF > $MENU_CONFIG
import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // TODO: Create this file
import 'pages/profile_page.dart'; // TODO: Create this file
import 'pages/settings_page.dart'; // TODO: Create this file

class MenuItemConfig {
  final IconData icon;
  final String label;
  final Widget view;

  const MenuItemConfig({
    required this.icon,
    required this.label,
    required this.view,
  });
}

// TODO: Define your menu items here
// Example menu items
const List<MenuItemConfig> bottomNavItems = [
  MenuItemConfig(icon: Icons.home, label: 'Home', view: HomeView()),
  MenuItemConfig(icon: Icons.person, label: 'Profile', view: ProfileView()),
  MenuItemConfig(icon: Icons.settings, label: 'Settings', view: SettingsView()),
];

List<BottomNavigationBarItem> get bottomNavBarItems =>
    bottomNavItems
        .map((item) => BottomNavigationBarItem(icon: Icon(item.icon), label: item.label))
        .toList();
EOF

# ========== Create Main Navigation Page ==========
MAIN_NAV_FILE="$BASE_PATH/presentation/pages/${FEATURE_NAME}_page.dart"
cat <<EOF > $MAIN_NAV_FILE
import 'package:flutter/material.dart';
import '../menu_config.dart';
import '../widgets/app_bottom_nav_bar.dart';

class ${PASCAL_CASE}Page extends StatefulWidget {
  const ${PASCAL_CASE}Page({super.key});

  @override
  State<${PASCAL_CASE}Page> createState() => _${PASCAL_CASE}PageState();
}

class _${PASCAL_CASE}PageState extends State<${PASCAL_CASE}Page> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomNavItems[_selectedIndex].view,
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
EOF

echo "✅ Bottom Navigation Boilerplate generated at $BASE_PATH"
