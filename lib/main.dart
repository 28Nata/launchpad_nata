import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Launchpad Jose',
      // Tema Gelap (Dark Mode)
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), 
      ),
      home: const LaunchpadPage(),
    );
  }
}

class LaunchpadPage extends StatefulWidget {
  const LaunchpadPage({super.key});

  @override
  State<LaunchpadPage> createState() => _LaunchpadPageState();
}

class _LaunchpadPageState extends State<LaunchpadPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Color> _colors = [
    Colors.redAccent, Colors.deepOrange, Colors.orange, Colors.amber,
    Colors.yellow, Colors.lime, Colors.lightGreen, Colors.green,
    Colors.teal, Colors.cyan, Colors.lightBlue, Colors.blue,
    Colors.indigo, Colors.purple, Colors.deepPurple, Colors.pink,
  ];

  Future<void> _playSound(int index) async {
   
    int soundNumber = index + 1;
    String extension = 'mp3';

    if (soundNumber >= 20) {
      extension = 'wav'; 
    }

    final String fileName = 'audio/$soundNumber.$extension';
    debugPrint("Memutar: $fileName"); 

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(fileName));
    } catch (e) {
      debugPrint("Error memutar suara: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/image/icon.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 12), // Jarak spasi antara icon dan teks
            const Text("LAUNCHPAD 28"),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,     
              crossAxisSpacing: 10,  
              mainAxisSpacing: 10,   
              childAspectRatio: 1.1, 
            ),
            
          
            itemCount: 28, 
            
            itemBuilder: (context, index) {
              final color = _colors[index % _colors.length];

              return PadButton(
                color: color,
                label: "${index + 1}", 
                onTap: () => _playSound(index),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PadButton extends StatefulWidget {
  final Color color;
  final String label;
  final VoidCallback onTap;

  const PadButton({
    super.key, 
    required this.color, 
    required this.label,
    required this.onTap
  });

  @override
  State<PadButton> createState() => _PadButtonState();
}

class _PadButtonState extends State<PadButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.0,
      upperBound: 0.1, 
    );
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = 1.0 - _controller.value;
    
    return GestureDetector(
      onTapDown: (_) { 
        _controller.forward(); 
        widget.onTap();        
      },
      onTapUp: (_) => _controller.reverse(),     
      onTapCancel: () => _controller.reverse(),  
      child: Transform.scale(
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withOpacity(0.9),
                widget.color.withOpacity(0.6),
              ],
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}