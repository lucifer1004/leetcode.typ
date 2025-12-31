#import "../../helpers.typ": *

#let solution-ref(lists) = {
  let heads = lists.map(list => list)
  let heap = ()
  for (idx, head) in heads.enumerate() {
    if head.val != none {
      heap.push((head.val, idx))
    }
  }
  heap = heap.sorted()
  let ans = ()
  while heap.len() > 0 {
    let (val, idx) = heap.at(0)
    ans.push(val)

    // --- sift-down (standard method) ---
    heap.at(0) = heap.at(-1)
    let _ = heap.pop()
    let curr = 0
    while true {
      let left = 2 * curr + 1
      let right = 2 * curr + 2
      let smallest = curr
      if left < heap.len() and heap.at(left) < heap.at(smallest) {
        smallest = left
      }
      if right < heap.len() and heap.at(right) < heap.at(smallest) {
        smallest = right
      }
      if smallest != curr {
        let tmp = heap.at(curr)
        heap.at(curr) = heap.at(smallest)
        heap.at(smallest) = tmp
        curr = smallest
      } else {
        break
      }
    }
    // --- end sift-down ---

    if heads.at(idx).next != none {
      heads.at(idx) = heads.at(idx).next
      let val = heads.at(idx).val
      if val != none {
        heap.push((val, idx))
        let curr = heap.len() - 1
        while curr > 0 {
          let parent = calc.floor((curr - 1) / 2)
          if heap.at(parent) > heap.at(curr) {
            let tmp = heap.at(curr)
            heap.at(curr) = heap.at(parent)
            heap.at(parent) = tmp
            curr = parent
          } else {
            break
          }
        }
      }
    }
  }
  linkedlist(ans)
}

// Use hold method for sift-down
#let solution-extra(lists) = {
  let heads = lists.map(list => list)
  let heap = ()
  for (idx, head) in heads.enumerate() {
    if head.val != none {
      heap.push((head.val, idx))
    }
  }
  heap = heap.sorted()
  let ans = ()
  while heap.len() > 0 {
    let (val, idx) = heap.at(0)
    ans.push(val)

    // --- sift-down (hole method) ---
    // Save the last element, then remove it.
    let last = heap.at(-1)
    let _ = heap.pop()

    // If heap is not empty after pop, fill the hole at root with `last`
    // and push the hole down until `last` fits.
    if heap.len() > 0 {
      let curr = 0
      while true {
        let left = 2 * curr + 1
        if left >= heap.len() {
          break
        }
        let right = left + 1

        // pick smaller child
        let child = left
        if right < heap.len() and heap.at(right) < heap.at(left) {
          child = right
        }

        // if `last` belongs here, stop
        if last <= heap.at(child) {
          break
        }

        // move child up, hole goes down
        heap.at(curr) = heap.at(child)
        curr = child
      }
      heap.at(curr) = last
    }
    // --- end sift-down ---

    if heads.at(idx).next != none {
      heads.at(idx) = heads.at(idx).next
      let val = heads.at(idx).val
      if val != none {
        heap.push((val, idx))
        let curr = heap.len() - 1
        while curr > 0 {
          let parent = calc.floor((curr - 1) / 2)
          if heap.at(parent) > heap.at(curr) {
            let tmp = heap.at(curr)
            heap.at(curr) = heap.at(parent)
            heap.at(parent) = tmp
            curr = parent
          } else {
            break
          }
        }
      }
    }
  }
  linkedlist(ans)
}
