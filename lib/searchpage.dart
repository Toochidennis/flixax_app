// import 'package:flixax_app/homepage.dart';
import 'package:flixax_app/widgets.dart';
import 'package:flutter/material.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: (){ Navigator.pop(context);},
               icon:Icon(
                Icons.arrow_back_ios,
               color: Colors.white,
               size: 28,
               )
               ),
            Expanded(child: 
              SizedBox(
                width: 10,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Browse by minister",
                    hintStyle: TextStyle(fontSize: 12),
                    prefixIcon: Icon(Icons.search),
                     fillColor: Color.fromRGBO(255, 255, 255, 0.404),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                  ),
                   contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              )
            )
          ],
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       DefaultTabController(
        length: 5, 
        child:Column(
          children: [ TabBar(
          isScrollable: true,
           labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          indicator: SimpleGradientTabIndicator(
            gradient:LinearGradient(
              colors: [
                Color.fromRGBO(255,190,0,1),
                Color.fromRGBO(255,85,253,1),
                Color.fromRGBO(127,187,255,1)
              ]
            )
          ),
          indicatorWeight: 0,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: 'Recommended',),
            Tab(text: 'Popular',),
            Tab(text: 'New',),
            Tab(text: 'Asabawood',),
            Tab(text: 'Filipino',),
          ]),],
        ) ),
        SizedBox(height: 28,),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text('TOP 10 SEARCHES',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color.fromRGBO(255,255,255,0.8)
              ),
          ),
        ),
          SizedBox(height: 2),
           Expanded(
             child: ListView.builder(
              // padding: EdgeInsets.only(top: 10),
              itemCount: movieslist.length,
              itemBuilder: (context,index){
                return Searchlist(
                  image: movieslist[index]["image"]!, 
                  title: movieslist[index]["title"]!, 
                  genre: movieslist[index]["genre"]!, 
                  popularity: movieslist[index]["popularity"]!,
                  );
              },
              ),
           ),
        ],
      )
      
    );
  }
}
final List<Map<String,String>> movieslist =[
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl (DUBBED)\nEscaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
  {"image":"assets/images/img1.png",
  "title": "Escaping the crazy CEO Wife and the farm girl",
  "genre":"CEO, Romance, Revenge",
  "popularity":"2.5k"
  },
];