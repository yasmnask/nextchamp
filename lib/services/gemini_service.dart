import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nextchamp/models/chat_model.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:nextchamp/providers/course_provider.dart';
import 'package:nextchamp/providers/category_provider.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class GeminiService {
  late final GenerativeModel _model;

  // OPTIMIZED: Shorter, more focused generation config
  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4, // REDUCED: More focused responses
        topK: 20, // REDUCED: Less randomness
        topP: 0.8, // REDUCED: More deterministic
        maxOutputTokens: 150, // REDUCED: Force shorter responses
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );
  }

  // Get dynamic app context based on real data
  String _buildAppContext(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    final totalCourses = courseProvider.courses.length;
    final totalCategories = categoryProvider.categories.length;

    // Build category breakdown
    final categoryBreakdown = categoryProvider.categories
        .map((category) {
          final coursesInCategory = courseProvider.courses
              .where((course) => course.categoryId == category.id)
              .length;
          return '• ${category.name} ($coursesInCategory program)';
        })
        .join('\n  ');

    // Get popular course titles
    final popularCourses = courseProvider.courses
        .take(5)
        .map((course) => course.title)
        .join(', ');

    return '''
  Anda adalah ChampBot, asisten AI NextChamp yang ramah dan profesional.
  
  PROFIL NEXTCHAMP:
  • Platform pendampingan lomba akademik & non-akademik mahasiswa Indonesia
  • Total: $totalCourses+ program pendampingan tersedia dengan mentor berpengalaman
  • $totalCategories kategori kompetisi utama
  • Benefit: Mentoring 1-on-1, template proposal, review karya, sertifikat, komunitas pemenang
  • Target: Mahasiswa yang ingin berprestasi di kompetisi nasional & internasional
  • Success Rate: 85% peserta lolos tahap seleksi, 60% masuk final

  KATEGORI KOMPETISI TERSEDIA:
  $categoryBreakdown

  PROGRAM POPULER:
  $popularCourses

  ATURAN WAJIB:
  1. JAWABAN MAKSIMAL 2-3 KALIMAT (50-80 kata)
  2. Gunakan emoji yang relevan (1-2 per respons)
  3. Selalu proaktif tawarkan bantuan spesifik terkait kompetisi
  4. Fokus pada achievement dan prestasi mahasiswa
  5. Gunakan bahasa motivational dan supportive
  6. Jika di luar topik: redirect ke kompetisi dengan sopan
  
  CUSTOMER SERVICE EXCELLENCE:
  • Pahami passion dan minat kompetisi mahasiswa
  • Berikan rekomendasi kompetisi berdasarkan jurusan/skill
  • Follow up dengan timeline kompetisi yang relevan
  • Motivasi dengan success story alumni
  • Highlight peluang beasiswa dan karir dari prestasi kompetisi
  ''';
  }

  Future<String> generateResponse({
    required String prompt,
    required BuildContext context,
    List<ChatMessage>? history,
  }) async {
    User? user;

    try {
      final promptPreview = prompt.length > 30
          ? '${prompt.substring(0, 30)}...'
          : prompt;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      user = userProvider.user;

      // Get real data context
      final appContext = _buildAppContext(context);

      // OPTIMIZED: Concise user context
      final userContext = user != null
          ? 'User: ${user.username ?? 'Guest'} (Mahasiswa)'
          : 'User: Guest (Mahasiswa)';

      // OPTIMIZED: Smart history analysis with real data
      String conversationFlow = _analyzeConversationFlow(history, context);

      // OPTIMIZED: Highly structured prompt for short responses
      final optimizedPrompt =
          '''
$appContext

KONTEKS PERCAKAPAN:
$userContext
$conversationFlow

USER BERKATA: "$prompt"

INSTRUKSI RESPONS:
- WAJIB: Maksimal 2-3 kalimat (50-80 kata)
- Format: [Motivasi/Acknowledgment] + [Solusi Kompetisi] + [Call-to-Action]
- Gunakan 1-2 emoji yang relevan
- Akhiri dengan pertanyaan atau ajakan bertindak
- Jika bukan tentang kompetisi: redirect dengan sopan ke topik kompetisi
- Gunakan data kategori dan program yang tersedia

CONTOH FORMAT:
"Wah, semangat berprestasi! 🏆 [solusi kompetisi singkat]. Mau saya rekomendasikan kompetisi yang cocok untuk Anda?"

RESPONS:''';

      final response = await _model
          .generateContent([Content.text(optimizedPrompt)])
          .timeout(Duration(seconds: 20));

      final responseText = response.text?.trim();
      if (responseText != null && responseText.isNotEmpty) {
        final optimizedResponse = _optimizeResponse(responseText, prompt);
        return optimizedResponse;
      } else {
        return _getSmartFallback(prompt, user?.username, context);
      }
    } catch (e) {
      print('❌ Gemini error: $e');
      return _getSmartFallback(prompt, user?.username, context);
    }
  }

  // OPTIMIZED: Analyze conversation flow with real data context
  String _analyzeConversationFlow(
    List<ChatMessage>? history,
    BuildContext context,
  ) {
    if (history == null || history.isEmpty) {
      return 'Status: Percakapan baru - siap membantu kompetisi';
    }

    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    final recent = history.takeLast(2);
    final lastUserMessage = recent.where((m) => !m.isFromBot).lastOrNull;

    // Detect conversation patterns with real category data
    if (lastUserMessage != null) {
      final content = lastUserMessage.content.toLowerCase();

      // Check against real categories
      for (final category in categoryProvider.categories) {
        if (content.contains(category.name.toLowerCase())) {
          final coursesInCategory = courseProvider.courses
              .where((course) => course.categoryId == category.id)
              .length;
          return 'Context: User tertarik ${category.name} ($coursesInCategory program tersedia)';
        }
      }

      // Check against real course titles
      for (final course in courseProvider.courses.take(10)) {
        final courseWords = course.title.toLowerCase().split(' ');
        if (courseWords.any(
          (word) => content.contains(word) && word.length > 3,
        )) {
          return 'Context: User menanyakan tentang "${course.title}"';
        }
      }

      // Generic patterns
      if (content.contains('mentor') || content.contains('bimbingan')) {
        return 'Context: User butuh mentoring';
      } else if (content.contains('deadline') || content.contains('timeline')) {
        return 'Context: User menanyakan jadwal kompetisi';
      } else if (content.contains('jurusan') || content.contains('fakultas')) {
        return 'Context: User mencari kompetisi sesuai jurusan';
      }
    }

    return 'Context: Percakapan berlanjut tentang kompetisi';
  }

  // OPTIMIZED: Post-process response to ensure optimal length and format
  String _optimizeResponse(String response, String userPrompt) {
    // Remove "RESPONS:" prefix if exists
    String cleaned = response.replaceFirst(RegExp(r'^RESPONS:\s*'), '');

    // Split into sentences
    List<String> sentences = cleaned
        .split(RegExp(r'[.!?]+'))
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();

    // Keep only 2-3 most relevant sentences
    if (sentences.length > 3) {
      sentences = sentences.take(3).toList();
    }

    // Reconstruct with proper punctuation
    String result = sentences.join('. ');
    if (!result.endsWith('.') &&
        !result.endsWith('!') &&
        !result.endsWith('?')) {
      result += '.';
    }

    // Ensure it ends with a question or call-to-action if it doesn't
    if (!result.contains('?') &&
        !result.contains('Apakah') &&
        !result.contains('Bagaimana') &&
        !result.contains('Mau')) {
      result += ' Butuh rekomendasi kompetisi yang cocok? 🎯';
    }

    return result;
  }

  // OPTIMIZED: Smart fallback responses with real data
  String _getSmartFallback(
    String prompt,
    String? username,
    BuildContext context,
  ) {
    final name = username ?? 'Kak';
    final lowerPrompt = prompt.toLowerCase();

    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    final totalCourses = courseProvider.courses.length;
    final totalCategories = categoryProvider.categories.length;

    // Greeting responses
    if (lowerPrompt.contains(RegExp(r'\b(hai|halo|hello|hi)\b'))) {
      return 'Hai $name! 👋 Saya ChampBot, siap membantu Anda meraih prestasi di kompetisi mahasiswa. Kami punya $totalCourses program di $totalCategories kategori!';
    }

    // Category-specific responses using real data
    for (final category in categoryProvider.categories) {
      if (lowerPrompt.contains(category.name.toLowerCase())) {
        final coursesInCategory = courseProvider.courses
            .where((course) => course.categoryId == category.id)
            .length;
        return '${category.name} pilihan yang tepat! 🚀 Kami punya $coursesInCategory program pendampingan khusus. Mau lihat program yang mana dulu?';
      }
    }

    // Course-specific responses using real data
    for (final course in courseProvider.courses.take(5)) {
      final courseWords = course.title.toLowerCase().split(' ');
      if (courseWords.any(
        (word) => lowerPrompt.contains(word) && word.length > 3,
      )) {
        return 'Program "${course.title}" sangat populer! 🏆 ${course.description.length > 50 ? course.description.substring(0, 50) + '...' : course.description} Mau info lengkapnya?';
      }
    }

    // Mentor inquiry
    if (lowerPrompt.contains(
      RegExp(r'\b(mentor|bimbingan|coaching|guidance)\b'),
    )) {
      return 'Mentor kami adalah juara kompetisi nasional & internasional! 🌟 Mentoring tersedia untuk semua $totalCategories kategori. Butuh mentor untuk kompetisi apa?';
    }

    // General course inquiry
    if (lowerPrompt.contains(
      RegExp(r'\b(program|kursus|course|belajar|materi)\b'),
    )) {
      final popularCategories = categoryProvider.categories
          .take(3)
          .map((c) => c.name)
          .join(', ');
      return 'Kami punya $totalCourses program pendampingan! 🚀 Kategori populer: $popularCategories. Mana yang paling menarik untuk Anda?';
    }

    // Timeline/Deadline inquiry
    if (lowerPrompt.contains(RegExp(r'\b(deadline|timeline|jadwal|kapan)\b'))) {
      return 'Timeline kompetisi penting banget! ⏰ Saya bisa kasih jadwal lengkap untuk semua $totalCategories kategori kompetisi. Kompetisi mana yang mau Anda kejar?';
    }

    // Success story inquiry
    if (lowerPrompt.contains(
      RegExp(r'\b(alumni|pemenang|juara|success|berhasil)\b'),
    )) {
      return 'Alumni NextChamp sudah raih 500+ prestasi dari $totalCourses program kami! 🏅 Success rate 85% lolos seleksi. Mau dengar success story yang mana?';
    }

    // Off-topic redirect
    if (!lowerPrompt.contains(
      RegExp(r'\b(kompetisi|lomba|contest|program|mentor|bimbingan)\b'),
    )) {
      return 'Maaf, saya fokus membantu kompetisi mahasiswa 😊 Yuk, cerita kompetisi apa yang ingin Anda ikuti dari $totalCategories kategori kami?';
    }

    // Default with real data
    return 'Siap membantu perjalanan kompetisi Anda! 🎯 NextChamp punya $totalCourses program di $totalCategories kategori. Kompetisi apa yang paling menarik untuk Anda?';
  }
}

// OPTIMIZED: Enhanced list extension
extension ListExtension<T> on List<T> {
  List<T> takeLast(int count) {
    if (isEmpty || count <= 0) return [];
    return length <= count ? this : sublist(length - count);
  }

  T? get lastOrNull => isEmpty ? null : last;
}
