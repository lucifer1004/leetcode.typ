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
