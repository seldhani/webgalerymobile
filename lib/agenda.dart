import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> fotoList = [];

  @override
  void initState() {
    super.initState();
    fetchFotoWithKategori3(); // Mengambil foto berdasarkan kategori_id 3
  }

  // Fungsi untuk mengambil data foto berdasarkan kategori_id 3
  Future<void> fetchFotoWithKategori3() async {
    try {
      // Mengambil data posts berdasarkan kategori_id 3
      final postResponse = await http
          .get(Uri.parse('http://10.0.2.2:8000/api/posts/kategori/3'));
      if (postResponse.statusCode == 200) {
        final postData = jsonDecode(postResponse.body);
        final List postsWithKategori3 = postData['data'];

        // Mengambil data foto
        final fotoResponse =
            await http.get(Uri.parse('http://10.0.2.2:8000/api/foto'));
        if (fotoResponse.statusCode == 200) {
          final fotoData = jsonDecode(fotoResponse.body);
          final List fotos = fotoData['data'];

          // Memfilter foto berdasarkan post_id yang relevan dengan kategori_id 3
          setState(() {
            fotoList = fotos
                .where((foto) => postsWithKategori3
                    .any((post) => post['id'] == foto['post_id']))
                .map((foto) => {
                      "file": foto['file'],
                      "judul": foto['judul'],
                      "isi": postsWithKategori3.firstWhere(
                          (post) => post['id'] == foto['post_id'])['isi'],
                    })
                .toList();
            isLoading = false;
          });
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agenda Sekolah',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: fotoList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: fotoList.length,
                itemBuilder: (ctx, index) {
                  final foto = fotoList[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    'http://10.0.2.2:8000/images/${foto["file"]}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.broken_image, size: 50);
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  foto['judul'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  foto['isi'] ?? 'No Content Available',
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                'http://10.0.2.2:8000/images/${foto["file"]}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.broken_image, size: 50);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              foto['judul'],
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
