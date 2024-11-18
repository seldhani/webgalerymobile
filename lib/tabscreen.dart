import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'agenda.dart';
import 'informasi.dart';
import 'galery.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _selectTab(int index) {
    _tabController.animateTo(index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Ubah warna AppBar menjadi hitam
        title: Row(
          children: [
            const Icon(Icons.school,
                size: 40, color: Colors.white), // Ikon putih
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'SMK Negeri 4 Bogor',
                style: GoogleFonts.josefinSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Warna teks putih
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 6.0,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        elevation: 4,
        iconTheme:
            const IconThemeData(color: Colors.white), // Ikon drawer putih
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.2), // Atur opasitas lebih rendah
                ),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5.0, sigmaY: 5.0), // Efek kabur
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.3), // Lapisan putih semi-transparan
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.school,
                              size: 100, color: Colors.black),
                          const SizedBox(height: 10),
                          Text(
                            'SMK Negeri 4 Bogor',
                            style: GoogleFonts.josefinSans(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.black54),
                title: const Text('Informasi',
                    style: TextStyle(color: Colors.black87)),
                onTap: () => _selectTab(0),
              ),
              ListTile(
                leading: const Icon(Icons.view_agenda_outlined,
                    color: Colors.black54),
                title: const Text('Agenda',
                    style: TextStyle(color: Colors.black87)),
                onTap: () => _selectTab(1),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: Colors.black54),
                title: const Text('Gallery',
                    style: TextStyle(color: Colors.black87)),
                onTap: () => _selectTab(2),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InformasiScreen(),
          AgendaScreen(),
          GaleryScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(29.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(30.0),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[600],
            labelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            tabs: const [
              Tab(
                icon: Icon(Icons.info_outline, size: 28),
                text: 'Informasi',
              ),
              Tab(
                icon: Icon(Icons.view_agenda_outlined, size: 28),
                text: 'Agenda',
              ),
              Tab(
                icon: Icon(Icons.photo_library_outlined, size: 28),
                text: 'Gallery',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
