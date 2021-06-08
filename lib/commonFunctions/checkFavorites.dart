

bool checkIsNewsFavorited(List favouritedList, String newsId) {
    bool _isFavorited = false;

    List _valueRealTime = [];
    favouritedList.asMap().forEach((index, data) => _valueRealTime.add({"key": index, ...data}));

      _valueRealTime.asMap().forEach((index, value) {
        if(value['id'] == newsId) {
          _isFavorited = true;        
        } 
      });

    return _isFavorited ;
  }