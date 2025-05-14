// import 'package:flutter/material.dart';


// class Movie extends StatefulWidget {
//   const Movie({super.key});

//   @override
//   State<Movie> createState() => _MovieState();
// }

// class _MovieState extends State<Movie> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }




// class MovieGrid extends StatelessWidget {


//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 5,
//                     mainAxisSpacing: 5,
//                     childAspectRatio: 0.7,
//                     ),
//                     itemCount: movies.length,
//                  itemBuilder: (context,index){
//                     return Moviegrid(
//                        image: movies[index]["image"]!,
//                        title: movies[index]["title"]!,
//                     );
                   
//                 } 
//             )  
//     );
//   }
// }
// class Moviecard extends StatelessWidget{
//     final String image;
//     final String title;

//     const Moviecard ({Key? key, required this.image, required this.title}) : super(key: key);
    
//       @override
//       Widget build(BuildContext context) {
//         return Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//             ),
//             child: Stack(
//                 alignment: Alignment.bottomLeft,
//                 children: [
//                     ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.asset(
//                             image,
//                             width:double.infinity,
//                             height: double.infinity,
//                             fit: BoxFit.cover,
//                         ),
//                     ),
//                     Positioned(
//                         left: 10,
//                         bottom: 10,
//                         child: Text(
//                            title,
//                            style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600
//                            ), 
//                         ))
//                 ],
//             ),
//         );
//         }
// }