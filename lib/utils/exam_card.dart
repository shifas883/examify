import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String decription;
  final String time;
  final String question;
  final String leval;
  const ExamCard({super.key, required this.onTap, required this.title, required this.leval, required this.decription, required this.time, required this.question});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 15, vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border:
            Border.all(color: Colors.grey, width: 0.2)),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                        decription),
                    SizedBox(height: 20,),
                    Text(
                        'Time: $time',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                    ),),
                    Text(
                        'Questions: $question',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      ),),
                  ],
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                        BorderRadius.circular(5)),
                    child: Text(
                      "Start Test",
                      style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w500),
                    )),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(10),
                      color: leval=="Beginner"?
                      Colors.green.withOpacity(0.2):
                      Colors.orangeAccent.withOpacity(0.2)
                  ),
                  child: Text(
                    '${leval}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: leval=="Beginner"?Colors.green:Colors.orangeAccent),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
