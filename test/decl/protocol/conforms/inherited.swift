// RUN: %swift -parse %s -verify

// Inheritable: method with 'Self' in its signature
protocol P1 {
  func f1(x: Self?) -> Bool
}

// Never inheritable: property with 'Self' in its signature.
protocol P2 {
  var prop2: Self { get }
}

// Never inheritable: subscript with 'Self' in its result type.
protocol P3 {
  subscript (i: Int) -> Self { get }
}

// Inheritable: subscript with 'Self' in its index type.
protocol P4 {
  subscript (s: Self) -> Int { get }
}

// Potentially inheritable: method returning Self
protocol P5 {
  func f5() -> Self
}

// Inheritable: method returning Self
protocol P6 {
  func f6() -> Self
}

// Inheritable: method involving associated type.
protocol P7 {
  typealias Assoc
  func f7() -> Assoc
}

// Inheritable: initializer requirement.
protocol P8 {
  init(int: Int)
}

// Inheritable: operator requirement.
protocol P9 {
  func ==(x: Self, y: Self) -> Bool 
}

// Never inheritable: method with 'Self' in a non-contravariant position.
protocol P10 {
  func f10(arr: [Self])
}

// Never inheritable: method with 'Self' in curried position.
protocol P11 {
  func f11()(x: Self) -> Int
}


// Class A conforms to everything.
class A : P1, P2, P3, P4, P5, P6, P7, P8, P9, P10 {
  // P1
  func f1(x: A?) -> Bool { return true }

  // P2
  var prop2: A {
    return self
  }

  // P3
  subscript (i: Int) -> A {
    get {
     return self
    }
  }

  // P4
  subscript (a: A) -> Int { 
    get {
      return 5
    }
  }

  // P5
  func f5() -> A { return self }

  // P6
  func f6() -> Self { return self }

  // P7
  func f7() -> Int { return 5 }

  // P8
  required init(int: Int) { }

  // P10
  func f10(arr: [A]) { }

  // P11
  func f11()(x: A) -> Int { return 5 }
}

// P9
func ==(x: A, y: A) -> Bool { return true }

// Class B inherits A; gets all of its inheritable conformances.
class B : A { 
  required init(int: Int) { }
}

func testB(b: B) {
  var p1: P1 = b // expected-error{{has Self or associated type requirements}}
  var p2: P2 = b // expected-error{{type 'B' does not conform to protocol 'P2'}} // expected-error{{has Self or associated type requirements}}
  var p3: P3 = b // expected-error{{type 'B' does not conform to protocol 'P3'}} // expected-error{{has Self or associated type requirements}}
  var p4: P4 = b // expected-error{{has Self or associated type requirements}}
  var p5: P5 = b // expected-error{{type 'B' does not conform to protocol 'P5'}}
  var p6: P6 = b
  var p7: P7 = b // expected-error{{has Self or associated type requirements}}
  var p8: P8 = b // okay
  var p9: P9 = b // expected-error{{has Self or associated type requirements}}
  var p10: P10 = b // expected-error{{type 'B' does not conform to protocol 'P10'}} // expected-error{{has Self or associated type requirements}}
  var p11: P11 = b // expected-error{{type 'B' does not conform to protocol 'P11'}}
}

// Class A5 conforms to P5 in an inheritable manner.
class A5 : P5 {
  // P5 
  func f5() -> Self { return self }
}

// Class B5 inherits A5; gets all of its inheritable conformances.
class B5 : A5 { }

func testB5(b5: B5) {
  var p5: P5 = b5 // okay
}

// Class A8 conforms to P8 in an inheritable manner.
class A8 : P8 {
  required init(int: Int) { }
}

class B8 : A8 {
  required init(int: Int) { }
}

func testB8(b8: B8) {
  var p8: P8 = b8 // okay
}
