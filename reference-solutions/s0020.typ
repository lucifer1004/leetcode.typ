#import "../helpers.typ": *

#let valid-parentheses-ref(s) = {
  // Performance Note: Use dict instead of array for stack
  // 
  // Why dict? Array's slice(0, -1) is O(n) per pop → O(n²) total.
  // Dict + pointer avoids copies: insert O(1), decrement O(1).
  // 
  // Stack pattern: dict + top pointer
  //   - push: stack.insert(str(top), val); top += 1
  //   - pop:  top -= 1
  //   - peek: stack.at(str(top - 1))
  //   - empty: top == 0  
  let stack = (:)
  let top = 0
  let pairs = (
    ")": "(",
    "]": "[",
    "}": "{",
  )
  
  for char in s {
    if char in ("(", "[", "{") {
      stack.insert(str(top), char)
      top += 1
    } else if char in pairs {
      if top == 0 or stack.at(str(top - 1)) != pairs.at(char) {
        return false
      }
      top -= 1
    }
  }
  
  top == 0
}
