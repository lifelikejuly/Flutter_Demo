class AnimationDriver {
  double _from;
  bool _isInitReverseDriver = false;
  bool _isInitForwardDriver = false;

  Function reverseFunc;
  Function forwardFunc;
  Function resetFunc;

  double get from => _from;

  bool get isInitReverseDriver => _isInitReverseDriver;

  bool get isInitForwardDriver => _isInitForwardDriver;

  AnimationDriver();

  void init() {
    if (_isInitReverseDriver) {
      _isInitReverseDriver = false;
      if (reverseFunc != null) reverseFunc();
    } else if (_isInitForwardDriver) {
      _isInitForwardDriver = false;
      if (forwardFunc != null) forwardFunc();
    }
  }

  void reverse({double from = 1.0}) {
    this._from = from;
    if (reverseFunc != null) {
      reverseFunc();
    } else {
      _isInitReverseDriver = true;
    }
  }

  void forward({double from = 0.0}) {
    this._from = from;
    if (forwardFunc != null) {
      forwardFunc();
    } else {
      _isInitForwardDriver = true;
    }
  }

  void reset() {
    if (resetFunc != null) {
      resetFunc();
    }
  }
}
