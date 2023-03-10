import 'package:carousel_slider/carousel_slider.dart';
import 'package:dog_breed_detection/resources/colormanager.dart';
import 'package:dog_breed_detection/resources/fontsmanager.dart';
import 'package:dog_breed_detection/resources/routesmanager.dart';
import 'package:dog_breed_detection/resources/stringmanager.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../ads_services/ads_services.dart';
import '../resources/assets.dart';
import 'widgets/card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          generateBluredImage(),
          SafeArea(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AdsServices.displayBannerAd(),
                    Text(
                      AppStrings.detect,
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 40.0,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    rectShapeContainer(),
                    // AdsServices.displayBannerAd(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget generateBluredImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageAssets.bottom,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
        ),
      ),
    );
  }

  Widget rectShapeContainer() {
    return Container(
      width: double.infinity,
      // margin: EdgeInsets.only(top: 50),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
        color: ColorManager.primary,
      ),
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned(
          top: -60,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
                color: ColorManager.white,
                shape: BoxShape.circle,
                image: const DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(ImageAssets.stackimage))),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 8.0),
            //   child: Text(
            //     AppStrings.about,
            //     textAlign: TextAlign.justify,
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: FontSize.s20,
            //       fontFamily: 'SourceSansPro',

            //       // fontWeight: FontWeight.w700,
            //     ),
            //   ),
            // ),
            carouselSlider(),
            const SizedBox(
              height: 20,
            ),
            HomeCard(
              name: AppStrings.camera,
              route: Routes.main,
              icon: Icon(
                Icons.image_search_sharp,
                color: ColorManager.primary,
                size: 30,
              ),
            ),
            HomeCard(
              name: AppStrings.live,
              route: Routes.live,
              icon: Icon(
                Icons.linked_camera_rounded,
                color: ColorManager.primary,
                size: 30,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget carouselSlider() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView(
        children: [
          CarouselSlider(
            items: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/1.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/2.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/3.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/4.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // AdsServices.displayNativeMRECAd(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/5.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/6.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
            options: CarouselOptions(
              enlargeCenterPage: true,
              height: MediaQuery.of(context).size.height * 0.25,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          )
        ],
      ),
    );
  }
}
