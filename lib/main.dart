import 'package:flutter/material.dart';
import 'package:instagrocers/Auth/Views/signin.dart';
import 'package:instagrocers/Gen/Otpfield.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
  
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SigninScreen()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Column(
            children: <Widget>[
      
      //               SizedBox(height: 10,),
          
      //               ContainerTextFormField(
      //                 hintText: "Enter Email", 
      //                 controller: email,
      //                 isPassword: true,
      //                 ),
      
      //                 SizedBox(height: 10,),
          
      //               CustomButton(
      //                 isBorderBtn: false,
      //                 color: Colors.orange,
      //                 text: "Macs",
      //               onPressed: (){}
      //               ),
      
      
      //  Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //    children: [
      //      ProductCard(
      //       avatarUrl: "https://img.freepik.com/premium-vector/cartoon-illustration-soap-bar-with-words-soap-it_871209-41.jpg?w=360",
      //       imageUrl: "https://img.freepik.com/premium-vector/cartoon-illustration-soap-bar-with-words-soap-it_871209-41.jpg?w=360",
      //       title: "Soaps",
      //       rating: 4.8,
      //       reviews: 287,
      //       price: 3.99,
      //       onAddToCart: () {
      //         print("Added to cart!");
      //       },
      //      ),
      
      //      ProductCard(
      //       avatarUrl: "https://img.freepik.com/premium-vector/cartoon-illustration-soap-bar-with-words-soap-it_871209-41.jpg?w=360",
      //       imageUrl: "https://img.freepik.com/premium-vector/cartoon-illustration-soap-bar-with-words-soap-it_871209-41.jpg?w=360",
      //       title: "Soaps",
      //       rating: 4.8,
      //       reviews: 287,
      //       price: 3.99,
      //       onAddToCart: () {
      //         print("Added to cart!");
      //       },
      //      ),
      //    ],
      //  ),
      
      // StoreCard(
      //   onFavoriteTap: (){},
      //   storeLogoUrl: "https://cached.imagescaler.hbpl.co.uk/resize/scaleWidth/952/cached.offlinehbpl.hbpl.co.uk/news/OMC/AsdaResized-20150223115224441.jpg",
      //   storeName: "ASDA Superstore",
      //   deliveryFee: "£0.89",
      //   deliveryTime: "20 min",
      //   productCount: "20,000",
      //   productImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVBznR6zUP22wMtBvfYr_XEF-FV4-1Si5x2-e-JnFpdV6chTeO4bUsjddFhYULFH2K8_0&usqp=CAU",
      //   onTap: () {
      //     print("Store tapped!");
      //   },
      // )
      
      
      Expanded(
        child: OtpVerificationWidget(
          phoneNumber: "+44 123 456 7890",
          onResend: () {
            // Handle Resend OTP
          },
          onChangeNumber: () {
            // Handle Change Number
          },
          onVerify: () {
            // Handle OTP Verification
          },
          otpController: TextEditingController(),
        ),
      )
      
      
          
            ],
          ),
        ),
      ),
 

     
    );
  }
}
