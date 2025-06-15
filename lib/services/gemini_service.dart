import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nextchamp/models/chat_model.dart';
import 'package:nextchamp/models/user_model.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class GeminiService {
  late final GenerativeModel _model;

  final String _appContext = '''
  Anda adalah ChampBot, asisten AI customer service NextChamp yang ramah dan profesional.
  
  PROFIL NEXTCHAMP:
  • Platform kursus online premium dengan 50+ materi berkualitas
  • Spesialisasi: Programming, Digital Business, Graphic Design
  • Benefit: Sertifikat resmi, mentor berpengalaman, komunitas aktif
  • Target: Profesional muda yang ingin upgrade skill

  ATURAN WAJIB:
  1. JAWABAN MAKSIMAL 2-3 KALIMAT (50-80 kata)
  2. Gunakan emoji yang relevan (1-2 per respons)
  3. Selalu proaktif tawarkan bantuan spesifik
  4. Fokus pada solusi, bukan masalah
  5. Gunakan bahasa conversational dan friendly
  6. Jika di luar topik: redirect ke kursus dengan sopan
  
  CUSTOMER SERVICE EXCELLENCE:
  • Dengarkan kebutuhan user dengan empati
  • Berikan rekomendasi personal berdasarkan profil
  • Follow up dengan pertanyaan yang membantu
  • Ciptakan sense of urgency yang natural
  • Highlight value proposition NextChamp
  ''';

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

      // OPTIMIZED: Concise user context
      final userContext = user != null
          ? 'User: ${user.username ?? 'Guest'}'
          : 'User: Guest';

      // OPTIMIZED: Smart history analysis
      String conversationFlow = _analyzeConversationFlow(history);

      // OPTIMIZED: Highly structured prompt for short responses
      final optimizedPrompt =
          '''
$_appContext

KONTEKS PERCAKAPAN:
$userContext
$conversationFlow

USER BERKATA: "$prompt"

INSTRUKSI RESPONS:
- WAJIB: Maksimal 2-3 kalimat (50-80 kata)
- Format: [Empati/Acknowledgment] + [Solusi/Info] + [Call-to-Action]
- Gunakan 1-2 emoji yang relevan
- Akhiri dengan pertanyaan atau ajakan bertindak
- Jika bukan tentang kursus: redirect dengan sopan ke topik pembelajaran

CONTOH FORMAT:
"Saya paham kebutuhan Anda! 😊 [solusi singkat]. Apakah Anda tertarik untuk [specific action]?"

RESPONS:''';

      final response = await _model
          .generateContent([Content.text(optimizedPrompt)])
          .timeout(Duration(seconds: 20));

      final responseText = response.text?.trim();
      if (responseText != null && responseText.isNotEmpty) {
        final optimizedResponse = _optimizeResponse(responseText, prompt);
        return optimizedResponse;
      } else {
        return _getSmartFallback(prompt, user?.username);
      }
    } catch (e) {
      print('❌ Gemini error: $e');
      return _getSmartFallback(prompt, user?.username);
    }
  }

  // OPTIMIZED: Analyze conversation flow for better context
  String _analyzeConversationFlow(List<ChatMessage>? history) {
    if (history == null || history.isEmpty) {
      return 'Status: Percakapan baru';
    }

    final recent = history.takeLast(2);
    final lastUserMessage = recent.where((m) => !m.isFromBot).lastOrNull;
    final lastBotMessage = recent.where((m) => m.isFromBot).lastOrNull;

    // Detect conversation patterns
    if (lastUserMessage != null) {
      final content = lastUserMessage.content.toLowerCase();

      if (content.contains('harga') || content.contains('biaya')) {
        return 'Context: User menanyakan pricing';
      } else if (content.contains('kursus') || content.contains('course')) {
        return 'Context: User tertarik kursus';
      } else if (content.contains('sertifikat')) {
        return 'Context: User menanyakan sertifikasi';
      } else if (content.contains('daftar') || content.contains('join')) {
        return 'Context: User siap mendaftar';
      }
    }

    return 'Context: Percakapan berlanjut';
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
        !result.contains('Bagaimana')) {
      result += ' Ada yang bisa saya bantu lagi? 😊';
    }

    return result;
  }

  // OPTIMIZED: Smart fallback responses based on keywords
  String _getSmartFallback(String prompt, String? username) {
    final name = username ?? 'Kak';
    final lowerPrompt = prompt.toLowerCase();

    // Greeting responses
    if (lowerPrompt.contains(RegExp(r'\b(hai|halo|hello|hi)\b'))) {
      return 'Hai $name! 👋 Saya ChampBot, siap membantu Anda explore kursus NextChamp. Skill apa yang ingin Anda tingkatkan?';
    }

    // Course inquiry
    if (lowerPrompt.contains(RegExp(r'\b(kursus|course|belajar|materi)\b'))) {
      return 'Kami punya 50+ kursus berkualitas di Programming, Digital Business & Design! 🚀 Bidang mana yang paling menarik untuk Anda?';
    }

    // Pricing inquiry
    if (lowerPrompt.contains(RegExp(r'\b(harga|biaya|price|cost|bayar)\b'))) {
      return 'Investasi terbaik untuk masa depan Anda! 💰 Mau saya carikan paket yang sesuai budget? Berapa range yang Anda pertimbangkan?';
    }

    // Certificate inquiry
    if (lowerPrompt.contains(RegExp(r'\b(sertifikat|certificate|ijazah)\b'))) {
      return 'Ya, semua kursus dapat sertifikat resmi! 🏆 Perfect untuk boost CV dan LinkedIn profile. Mau lihat contoh sertifikatnya?';
    }

    // Registration intent
    if (lowerPrompt.contains(RegExp(r'\b(daftar|join|gabung|mulai)\b'))) {
      return 'Wah, mantap $name! 🎉 Tinggal pilih kursus dan langsung bisa mulai belajar. Butuh rekomendasi kursus yang cocok?';
    }

    // Off-topic redirect
    if (!lowerPrompt.contains(
      RegExp(r'\b(kursus|belajar|skill|programming|design|business)\b'),
    )) {
      return 'Maaf, saya fokus membantu tentang kursus dan pembelajaran 😊 Yuk, cerita skill apa yang ingin Anda kembangkan?';
    }

    // Default
    return 'Terima kasih $name! 😊 Saya siap membantu dengan info kursus NextChamp. Ada yang spesifik ingin Anda tanyakan?';
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
