

import '../models/quote.dart';
import '../providers/base_provider.dart';

class QuoteProvider extends BaseProvider<Quote>{
  QuoteProvider():super('Quotes');

@override
  Quote fromJson(data) {
    return Quote.fromJson(data);
  }

}