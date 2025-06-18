import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseJoinedPage extends StatefulWidget {
  const CourseJoinedPage({super.key});

  @override
  _CourseJoinedPageState createState() => _CourseJoinedPageState();
}

class _CourseJoinedPageState extends State<CourseJoinedPage> {
  int _selectedModuleIndex = 0; // Track selected module

  void _selectModule(int moduleIndex) {
    setState(() {
      _selectedModuleIndex = moduleIndex;
    });
  }

  void _previousModule() {
    if (_selectedModuleIndex > 0) {
      setState(() {
        _selectedModuleIndex--;
      });
    }
  }

  void _nextModule() {
    if (_selectedModuleIndex < 3) {
      setState(() {
        _selectedModuleIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCourseImage(),
                  _buildCourseTitle(),
                  _buildDescription(),
                  _buildRequirements(),
                  _buildActionButtons(),
                  SizedBox(height: 50), // Space for bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Color(0xFF1E293B), // Dark blue background
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Course Detail',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.menu_book, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseImage() {
    String imageUrl;
    switch (_selectedModuleIndex) {
      case 0:
        imageUrl =
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/bisnis%20plan-8d9qdNSsgUP9AO2xujDM6NQdsZHQEc.png';
        break;
      case 1:
        imageUrl =
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/NextChamp%20IT%20Product%20Innovation-aMBLIM0YwHNMI2occ9ooYmPXNco78A.png';
        break;
      case 2:
        imageUrl =
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/NextChamp%20IT%20Product%20Innovation%20%281%29-GXfMIqSKx2DxE4OEFkXN0kEZEKuOnY.png';
        break;
      case 3:
        imageUrl =
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/NextChamp%20IT%20Product%20Innovation%20%282%29-rDIq0uSwK1iB40JAiWDERuzT7YRRSM.png';
        break;
      default:
        imageUrl =
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/bisnis%20plan-8d9qdNSsgUP9AO2xujDM6NQdsZHQEc.png';
    }

    return Container(
      margin: EdgeInsets.all(16),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading image: $error");
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Video will play here')),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseTitle() {
    String title;
    switch (_selectedModuleIndex) {
      case 0:
        title = 'Dasar - Dasar Business Plan';
        break;
      case 1:
        title = 'Analisis Pasar dan Kompetitor';
        break;
      case 2:
        title = 'Struktur dan Komponen Utama Business Plan';
        break;
      case 3:
        title = 'Membuat Proyeksi Keuangan Sederhana';
        break;
      default:
        title = 'Dasar - Dasar Business Plan';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Times New Roman',
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Mentor : ',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontFamily: 'Times New Roman',
                ),
              ),
              Text(
                'Zakiyah Yasmin',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontFamily: 'Times New Roman',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Add course stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCourseStat(Icons.access_time, '6 Hours'),
              _buildCourseStat(Icons.video_library, '24 Lessons'),
              _buildCourseStat(Icons.people, '1.2k Students'),
              _buildCourseStat(Icons.star, '4.8 (256)'),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCourseStat(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF64748B), size: 20),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontFamily: 'Times New Roman',
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    String description;
    switch (_selectedModuleIndex) {
      case 0:
        description =
            'Pelajari dasar-dasar pembuatan business plan yang efektif dan menarik untuk calon investor maupun keperluan internal bisnis. Course ini dirancang untuk pemula yang ingin memahami elemen penting dalam menyusun rencana bisnis dari nol, mulai dari riset pasar hingga strategi keuangan.';
        break;
      case 1:
        description =
            'Analisis pasar dan kompetitor adalah proses penting untuk memahami lingkungan bisnis. Pelajari cara mengidentifikasi target pasar, menganalisis perilaku konsumen, dan memahami strategi kompetitor. Dengan informasi ini, Anda dapat membuat keputusan bisnis yang lebih efektif dan kompetitif.';
        break;
      case 2:
        description =
            'Struktur dan komponen utama business plan meliputi ringkasan eksekutif, deskripsi bisnis, analisis pasar, rencana pemasaran, rencana operasional, analisis keuangan, dan manajemen. Pelajari cara menyusun setiap komponen dengan baik untuk menghasilkan business plan yang komprehensif dan menarik bagi investor.';
        break;
      case 3:
        description =
            'Proyeksi keuangan sederhana adalah perkiraan kinerja keuangan di masa depan berdasarkan data historis dan asumsi. Langkah-langkah membuat proyeksi meliputi analisis pendapatan, biaya operasional, proyeksi pendapatan dan pengeluaran, persiapan arus kas, dan evaluasi kelayakan finansial bisnis.';
        break;
      default:
        description =
            'Pelajari dasar-dasar pembuatan business plan yang efektif dan menarik untuk calon investor maupun keperluan internal bisnis. Course ini dirancang untuk pemula yang ingin memahami elemen penting dalam menyusun rencana bisnis dari nol, mulai dari riset pasar hingga strategi keuangan.';
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Times New Roman',
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              fontFamily: 'Times New Roman',
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRequirements() {
    List<String> requirements;
    switch (_selectedModuleIndex) {
      case 0:
        requirements = [
          'Memiliki ide bisnis atau minat dalam kewirausahaan',
          'Mampu mengoperasikan komputer dan Microsoft Office (Word, Excel)',
          'Tidak diperlukan pengalaman bisnis sebelumnya',
          'Koneksi internet untuk mengakses materi video',
        ];
        break;
      case 1:
        requirements = [
          'Memiliki pasar atau kompetitor sederhana yang ingin dianalisis',
          'Mampu mengoperasikan komputer dan aplikasi web',
          'Memahami konsumen dasar mengenai pasar sasaran',
          'Koneksi internet untuk mengakses materi video',
        ];
        break;
      case 2:
        requirements = [
          'Sudah menyelesaikan modul dasar business plan',
          'Memiliki draft awal business plan yang akan disempurnakan',
          'Mampu mengoperasikan software presentasi (PowerPoint, Canva)',
          'Koneksi internet untuk mengakses materi video',
        ];
        break;
      case 3:
        requirements = [
          'Pemahaman dasar keuangan bisnis',
          'Memiliki data keuangan dasar yang akan diproyeksikan',
          'Bisa menggunakan spreadsheet software (Excel, Google Sheets)',
          'Koneksi internet untuk mengakses materi video',
        ];
        break;
      default:
        requirements = [
          'Memiliki ide bisnis atau minat dalam kewirausahaan',
          'Mampu mengoperasikan komputer dan Microsoft Office (Word, Excel)',
          'Tidak diperlukan pengalaman bisnis sebelumnya',
          'Koneksi internet untuk mengakses materi video',
        ];
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requirements',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Times New Roman',
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 12),
          ...requirements
              .map((requirement) => _buildRequirementItem(requirement))
              .toList(),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.star, color: Color(0xFFFACC15), size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                fontFamily: 'Times New Roman',
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _showCourseContentModal();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB8D4E3),
            foregroundColor: Color(0xFF1E293B),
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Course Content',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Times New Roman',
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showCourseContentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.68,
            decoration: BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Course Content',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '4 modules • 12 lessons • 3h 15m total length',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                        SizedBox(height: 20),
                        ..._getCourseModules()
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildModalModuleItem(
                                entry.value,
                                entry.key,
                                setModalState,
                              ),
                            )
                            .toList(),
                        SizedBox(height: 20),
                        // Previous and Next buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _previousModule();
                                  setModalState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedModuleIndex > 0
                                      ? Color(0xFF475569)
                                      : Color.fromARGB(255, 56, 57, 58),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Previous',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _nextModule();
                                  setModalState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedModuleIndex < 3
                                      ? Color(0xFF475569)
                                      : Color.fromARGB(255, 56, 57, 58),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Times New Roman',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getCourseModules() {
    return [
      {
        'title': 'Pengenalan Business Plan',
        'duration': '12:55 Mins',
        'number': '1',
      },
      {
        'title': 'Analisis Pasar dan Kompetitor',
        'duration': '18:25 Mins',
        'number': '2',
      },
      {
        'title': 'Struktur dan Komponen Utama Business Plan',
        'duration': '20:50 Mins',
        'number': '3',
      },
      {
        'title': 'Membuat Proyeksi Keuangan Sederhana',
        'duration': '27:35 Mins',
        'number': '4',
      },
    ];
  }

  Widget _buildModalModuleItem(
    Map<String, dynamic> module,
    int index,
    StateSetter setModalState,
  ) {
    bool isSelected = _selectedModuleIndex == index;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _selectModule(index);
            setModalState(() {});
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFB8D4E3) : Color(0xFF9BB5C4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Center(
                    child: Text(
                      module['number'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Color(0xFF1E293B)
                            : Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module['duration'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        module['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF1E293B) : Color(0xFF64748B),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
