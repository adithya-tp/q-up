import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  int _currentIndex = 0;
  List imgList = [
    'assets/images/clothes.jpg',
    'assets/images/supermarket.jpg',
    'assets/images/restaurants.jpg',
    'assets/images/malls.jpg',
    'assets/images/theatre.jpg',
    'assets/images/museum.jpeg',
  ];

  List imgTitle = [
    'Clothes',
    'Food Marts',
    'Restaurant',
    'Malls',
    'Theatres',
    'Museums',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            items: imgList.map((img) {
              String title = "${imgTitle[_currentIndex]}";
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
//                      Navigator.push(context, MaterialPageRoute(
//                        builder: (context) {
//                          return Details(category: title,);
//                        },
//                      ));
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(img),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          height: 250.0,
                        ),
                        Positioned(
                          left: 30.0,
                          bottom: 60.0,
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.5),
                              ],
                              stops: [
                                0.5, 1
                              ],
                              begin: Alignment.bottomLeft,
                            ),
                            color: Colors.grey,
                          ),
                          height: 250.0,
                        )
                      ],
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 300.0,
              enlargeCenterPage: true,
              initialPage: 0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              pauseAutoPlayOnTouch: true,
              autoPlayAnimationDuration: Duration(milliseconds: 500),
              onPageChanged: (index, reason) {
                if(mounted) {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}