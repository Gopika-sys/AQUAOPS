import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';

class AIAdvisorScreen extends StatefulWidget {
  const AIAdvisorScreen({super.key});

  @override
  State<AIAdvisorScreen> createState() => _AIAdvisorScreenState();
}

class _AIAdvisorScreenState extends State<AIAdvisorScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      "isAi": true,
      "text": "Greetings. I am the Hydra-AI Advisor. How can I assist you with the campus water neural network today?",
      "time": DateFormat('hh:mm a').format(DateTime.now())
    },
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getAiResponse(String query) {
    query = query.toLowerCase();
    
    if (query.contains("hi") || query.contains("hello") || query.contains("hey")) {
      return "Hello! I am online and monitoring the campus water grid. What specific data do you require?";
    } else if (query.contains("status") || query.contains("health")) {
      return "Current Neural System Status: 98.4% Efficiency. All primary nodes are operational. I've detected a minor pressure fluctuation in the North Sector, but it's within safety margins.";
    } else if (query.contains("leak") || query.contains("pipe") || query.contains("break")) {
      return "Scanning for anomalies... No active leaks detected in the main lines. However, flow sensors in the Hostel Wing suggest a potential faucet drip in Block C, Room 402.";
    } else if (query.contains("level") || query.contains("reservoir") || query.contains("tank") || query.contains("volume")) {
      return "Main Reservoir is at 85% capacity (420,000 Liters). At current consumption rates, this is sufficient for the next 72 hours without replenishment.";
    } else if (query.contains("hostel") || query.contains("academic") || query.contains("cafe")) {
      return "Sector Intelligence: The Academic Wing is currently at 45% usage (Optimized). The Hostel Complex is peaking at 92% due to morning routines. I have redirected surplus flow to compensate.";
    } else if (query.contains("save") || query.contains("conservation") || query.contains("index")) {
      return "Our current Sustainability Index is 74/100 (Excellent). To improve this, I recommend scheduling the lawn irrigation systems for 02:00 AM to minimize evaporation loss.";
    } else if (query.contains("who") || query.contains("what")) {
      return "I am HYDRA-AI, a neural processing unit designed to optimize campus water distribution and conservation through real-time sensor analytics.";
    } else {
      return "That is an interesting inquiry. While I don't have a direct protocol for that, I can provide system health, leak reports, or reservoir levels. Which would you prefer?";
    }
  }

  void _sendMessage() {
    final String userText = _messageController.text.trim();
    if (userText.isEmpty) return;
    
    final String currentTime = DateFormat('hh:mm a').format(DateTime.now());
    
    setState(() {
      _messages.add({
        "isAi": false,
        "text": userText,
        "time": currentTime
      });
      _messageController.clear();
    });
    _scrollToBottom();

    // Simulate AI Response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            "isAi": true,
            "text": _getAiResponse(userText),
            "time": DateFormat('hh:mm a').format(DateTime.now())
          });
        });
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color aquaBlue = Color(0xFF22D3EE);
    const Color deepPurple = Color(0xFF6366F1);
    const Color canvasBg = Color(0xFF020509);

    return Scaffold(
      backgroundColor: canvasBg,
      body: Stack(
        children: [
          // Background Glows
          Positioned(top: -100, right: -50, child: _buildGlow(deepPurple.withValues(alpha: 0.15), 400)),
          Positioned(bottom: 100, left: -150, child: _buildGlow(aquaBlue.withValues(alpha: 0.1), 500)),
          
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: _buildChatBubble(msg["isAi"], msg["text"], msg["time"]),
                    );
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 150, spreadRadius: 50)],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: const Color(0xFF22D3EE).withValues(alpha: 0.1),
              child: const Icon(Icons.psychology_rounded, color: Color(0xFF22D3EE)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "HYDRA AI ADVISOR",
                      style: GoogleFonts.syne(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                  ),
                  Text(
                    "NEURAL LINK ACTIVE",
                    style: GoogleFonts.montserrat(color: const Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(bool isAi, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAi) ...[
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFF22D3EE).withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF22D3EE), size: 12),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            flex: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isAi ? Colors.white.withValues(alpha: 0.05) : const Color(0xFF6366F1).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isAi ? 0 : 20),
                    bottomRight: Radius.circular(isAi ? 20 : 0),
                  ),
                  border: Border.all(color: isAi ? Colors.white.withValues(alpha: 0.08) : const Color(0xFF6366F1).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      text,
                      style: GoogleFonts.montserrat(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isAi) const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Ask Hydra AI...",
                  hintStyle: GoogleFonts.montserrat(color: Colors.white24, fontSize: 14),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFF22D3EE), shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
