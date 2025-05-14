import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class MovieItem extends StatelessWidget {
  final String image;
  final String title;
  const MovieItem({super.key,
  required this.image,
  required this.title

  });

  @override
  Widget build(BuildContext context) {
     return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 150,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,fontFamily: 'Nunito',fontSize: 14),
      ),
    ],
  );
  }
}

class MovieItem2 extends StatelessWidget {
  final String image;
  final String title;
  final Color crank;
  final String rank;

  const MovieItem2({
    Key? key,
    required this.image,
    required this.title,
    required this.crank,
    required this.rank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(color: const Color.fromARGB(137, 46, 44, 44)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              child: Image.asset(
                image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Nunito'
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: EdgeInsets.only(left: 8, bottom: 8),
            decoration: BoxDecoration(
              color: crank.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              rank,
              style: TextStyle(
                color: crank, // Text color inside highlight
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Nunito'
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String name;
 const Section({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: EdgeInsets.only(left: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "Rewards from daily takes",
              style: TextStyle(
                color: Colors.amber, // Text color inside highlight
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

class SocialTask extends StatelessWidget{
  final String svgAsset;
  final String taskTitle;
  final Color bonusTextColor;

  SocialTask({
  Key?key,
  required this.svgAsset,
  required this.taskTitle,
  required this.bonusTextColor
  }):super (key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(31,33,43,1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            child: Center(
              child: SvgPicture.asset(
                svgAsset,
                width: 40,
                height: 40,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 4),
              Text("+200 Bonus",
              style: TextStyle(
                color: bonusTextColor,
                fontSize: 14,
                ),
              )     
            ],
          )),
          Container(
            width: 80,
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
             decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255,190,0,1), 
                  Color.fromRGBO(255,85,253,1), 
                  Color.fromRGBO(127,187,255,1), 
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                )
             ),
             child: Center(
               child: Text(
                "Go",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito'
                ),
               ),
             ),
          )
        ],
      ),
    );
    
  }
}

class SocialTask2 extends StatelessWidget{
  final String svgAsset;
  final String taskTitle;
  final Color bonusTextColor;

  SocialTask2({
  Key?key,
  required this.svgAsset,
  required this.taskTitle,
  required this.bonusTextColor
  }):super (key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromRGBO(31,33,43,1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            child: Center(
              child: SvgPicture.asset(
                svgAsset,
                width: 60,
                height: 60,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 4),
              Text("+200 Bonus",
              style: TextStyle(
                color: bonusTextColor,
                fontSize: 14,
                ),
              )     
            ],
          )),
          Container(
            width: 80,
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
             decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255,190,0,1), 
                  Color.fromRGBO(255,85,253,1), 
                  Color.fromRGBO(127,187,255,1), 
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                )
             ),
             child: Center(
               child: Text(
                "Go",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito'
                ),
               ),
             ),
          )
        ],
      ),
    );
    
  }
}

class MovieItem3 extends StatelessWidget {
  final String image;
  final String title2;
  final String genre;

  const MovieItem3({
    Key? key,
    required this.image,
    required this.title2,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          ClipRRect(
            child: Image.asset(image, width: 50, height: 90, fit: BoxFit.cover),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito'
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  genre,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito'
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String name;
 const SectionHeader({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Nunito'
            ),
          ),
          
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

class Searchlist extends StatelessWidget {
  final String image;
  final String title;
  final String genre;
  final String popularity;

  const Searchlist({
    Key? key,
    required this.image,
    required this.title,
    required this.genre,
    required this.popularity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(34,34,34,1),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          /// Movie Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(image, width: 60, height: 90, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),

          /// Title and Genre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito'
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  genre,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontFamily: 'Nunito'
                  ),
                ),
              ],
            ),
          ),

          /// Fire Icon & Popularity - Aligned to Right
        Row(
  mainAxisSize: MainAxisSize.min, // Keeps it compact
  children: [
    SvgPicture.asset(
      'assets/icons/fire.svg', // path to your SVG file
      width: 20,
      height: 20,
    ),
    const SizedBox(width: 5),
    Text(
      popularity,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontFamily: 'Nunito',
      ),
    ),
  ],
)

        ],
      ),
    );
  }
}

class SimpleGradientTabIndicator extends Decoration {
  final Gradient gradient;
  final double strokeWidth;

  const SimpleGradientTabIndicator({
    required this.gradient,
    this.strokeWidth = 3.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _SimpleGradientPainter(gradient, strokeWidth);
  }
}

class _SimpleGradientPainter extends BoxPainter {
  final Gradient gradient;
  final double strokeWidth;

  _SimpleGradientPainter(this.gradient, this.strokeWidth);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = Offset(offset.dx, cfg.size!.height - strokeWidth) &
        Size(cfg.size!.width, strokeWidth);
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);
  }
}
