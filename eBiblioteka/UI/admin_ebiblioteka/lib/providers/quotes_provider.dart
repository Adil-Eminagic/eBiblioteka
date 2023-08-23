

import 'package:admin_ebiblioteka/models/quote.dart';
import 'package:admin_ebiblioteka/providers/base_provider.dart';

class QuoteProvider extends BaseProvider<Quote>{
  QuoteProvider():super('Quotes');

@override
  Quote fromJson(data) {
    return Quote.fromJson(data);
  }

}