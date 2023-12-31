import 'package:flutter/material.dart';
import 'package:shiv/models/FAQs_model.dart';
import 'package:shiv/providers/faqs_provider.dart';


class FAQPage extends StatelessWidget {
  final FAQProvider faqProvider = FAQProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: StreamBuilder<List<QuestionAnswer>>(
        stream: faqProvider.getFAQs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No FAQs available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Text(snapshot.data![index].question),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(snapshot.data![index].answer),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
