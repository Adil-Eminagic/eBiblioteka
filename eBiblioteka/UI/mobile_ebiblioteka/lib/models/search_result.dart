class SearchResult<T> {
  //int count=0;
  int pageNumber = 0;
  int pageSize = 0;
  int pageCount = 0;
  int totalCount = 0;
  bool hasPreviousPage = false;
  bool hasNextPage = false;
  bool isFirstPage = false;
  bool isLastPage = false;
  List<T> items = [];
}
