#import "../helpers.typ": *

#let palindrome-number-ref(x) = {
  if x < 0 {
    return false
  }
  if x == 0 {
    return true
  }
  if calc.mod(x, 10) == 0 {
    return false
  }

  let rev = 0
  while x > rev {
    if rev > 214748364 or (rev == 214748364 and calc.mod(x, 10) > 7) {
      return false
    }
    rev = rev * 10 + calc.mod(x, 10)
    x = calc.floor(x / 10)
  }
  x == rev or x == calc.floor(rev / 10)
}
