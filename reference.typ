#import "helpers.typ": *

#let two-sum-ref(arr, target) = {
  let d = (:)
  let ans = (-1, -1)
  for (i, num) in arr.enumerate() {
    if str(target - num) in d {
      ans = (d.at(str(target - num)), i)
      break
    } else {
      d.insert(str(num), i)
    }
  }
  
  ans
}

#let add-two-numbers-ref(l1, l2) = {
  let p = ()
  let carry = 0
  while l1.val != none or l2.val != none {
    let x = if l1.val != none { l1.val } else { 0 }
    let y = if l2.val != none { l2.val } else { 0 }
    let sum = x + y + carry
    carry = calc.floor(sum / 10)
    p.push(calc.mod(sum, 10))
    if l1.next != none {
      l1 = l1.next
    }
    if l2.next != none {
      l2 = l2.next
    }
  }
  if carry > 0 {
    p.push(carry)
  }
  linkedlist(p)
}

#let longest-substring-without-repeating-charaters-ref(s) = {
  let s = s.split("")
  let s = s.slice(1, s.len() - 1)
  let n = s.len()
  let ans = 1
  let l = 0
  let d = (:)
  for r in range(n) {
    let c = s.at(r)
    while c in d {
      let cl = s.at(l)
      let _ = d.remove(cl)
      l += 1
    }
    d.insert(c, 1)
    ans = calc.max(ans, r - l + 1)
  }
  ans
}

#let median-of-two-sorted-arrays-ref(nums1, nums2) = {
  if nums1.len() > nums2.len() {
    return median-of-two-sorted-arrays-ref(nums2, nums1)
  }

  let imax = 4000000000
  let imin = -4000000000

  let m = nums1.len()
  let n = nums2.len()
  let left = 0
  let right = m
  let med1 = 0
  let med2 = 0

  while left <= right {
    let i = calc.floor((left + right) / 2)
    let j = calc.floor((m + n + 1) / 2) - i

    let nums_im1 = if i == 0 { imin } else { nums1.at(i - 1) }
    let nums_i = if i == m { imax } else { nums1.at(i) }
    let nums_jm1 = if j == 0 { imin } else { nums2.at(j - 1) }
    let nums_j = if j == n { imax } else { nums2.at(j) }

    if nums_im1 <= nums_j {
      med1 = calc.max(nums_im1, nums_jm1)
      med2 = calc.min(nums_i, nums_j)
      left = i + 1
    } else {
      right = i - 1
    }
  }

  if calc.mod(m + n, 2) == 0 {
    (med1 + med2) / 2
  } else {
    med1
  }
}

#let longest-palindromic-substring-ref(s) = {
  let s = s.split("")
  let s = s.slice(1, s.len() - 1)
  let t = ()
  for c in s {
    t.push("$")
    t.push(c)
  }
  t.push("$")
  let n = t.len()
  let a = fill(0, n)
  let l = 0
  let r = -1
  for i in range(n) {
    let j = if i > r { 1 } else { calc.min(a.at(l + r - i), r - i + 1) }
    while i >= j and i + j < n and t.at(i - j) == t.at(i + j) {
      j = j + 1
    }
    a.at(i) = j
    j = j - 1
    if i + j > r {
      l = i - j
      r = i + j
    }
  }

  let ans = 0
  let hi = 0
  for i in range(n) {
    if a.at(i) > hi {
      ans = i
      hi = a.at(i)
    }
  }

  let ret = ()
  for i in range(ans - hi + 1, ans + hi) {
    if t.at(i) != "$" {
      ret.push(t.at(i))
    }
  }

  ret.join()
}

#let zigzag-conversion-ref(s, numRows) = {
  if numRows == 1 {
    return s
  }

  let s = s.split("")
  let s = s.slice(1, s.len() - 1)
  let n = s.len()
  let ret = ()
  let cycleLen = 2 * numRows - 2

  for i in range(numRows) {
    for j in range(0, n - i, step: cycleLen) {
      ret.push(s.at(j + i))
      if i != 0 and i != numRows - 1 and j + cycleLen - i < n {
        ret.push(s.at(j + cycleLen - i))
      }
    }
  }

  ret.join()
}

#let reverse-integer-ref(x) = {
  let ans = 0
  let sign = if x >= 0 { 0 } else { -1 }
  if x == -2147483648 {
    return 0
  }

  x = calc.abs(x)
  while x != 0 {
    let pop = calc.mod(x, 10)
    x = calc.floor(x / 10)
    if ans > 214748364 or (ans == 214748364 and pop - sign > 7) {
      return 0
    }
    ans = ans * 10 + pop
  }
  ans * (2 * sign + 1)
}

#let string-to-integer-ref(s) = {
  let numerics = "0123456789"
  let d = ("0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9)
  let s = s.split("")
  let s = s.slice(1, s.len() - 1)
  let n = s.len()
  let i = 0
  let sign = 1
  let ans = 0
  while i < n and s.at(i) == " " {
    i += 1
  }
  if i < n and s.at(i) == "-" {
    sign = -1
    i += 1
  } else if i < n and s.at(i) == "+" {
    i += 1
  }
  while i < n and s.at(i) in numerics {
    if ans > 214748364 or (ans == 214748364 and d.at(s.at(i)) > 7) {
      if sign == 1 {
        return 2147483647
      } else {
        return -2147483648
      }
    }
    ans = ans * 10 + d.at(s.at(i))
    i += 1
  }
  ans * sign 
}

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

#let regular-expression-matching-ref(s, p) = {
  let s = s.split("")
  let s = s.slice(1, s.len() - 1)
  let p = p.split("")
  let p = p.slice(1, p.len() - 1)
  let m = s.len()
  let n = p.len()
  let dp = fill(fill(false, n + 1), m + 1)
  dp.at(0).at(0) = true
  for i in range(0, m + 1) {
    for j in range(1, n + 1) {
      if p.at(j - 1) != "*" {
        if i > 0 and (p.at(j - 1) == "." or p.at(j - 1) == s.at(i - 1)) {
          dp.at(i).at(j) = dp.at(i - 1).at(j - 1)
        }
      } else {
        if j >= 2 {
          dp.at(i).at(j) = dp.at(i).at(j) or dp.at(i).at(j - 2)
        }
        if i >= 1 and j >= 2 and (p.at(j - 2) == "." or p.at(j - 2) == s.at(i - 1)) {
          dp.at(i).at(j) = dp.at(i).at(j) or dp.at(i - 1).at(j)
        }
      }
    }
  }
  dp.at(m).at(n)
}
