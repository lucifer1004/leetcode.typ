#import "../../helpers.typ": *

#let solution(nums) = {
  // Use iterative approach with fold to collect results
  let permute(remaining) = {
    if remaining.len() == 0 {
      return ((),)
    }
    if remaining.len() == 1 {
      return (remaining,)
    }

    let result = ()
    for (i, num) in remaining.enumerate() {
      let rest = remaining.slice(0, i) + remaining.slice(i + 1)
      let sub-perms = permute(rest)
      for perm in sub-perms {
        result.push((num,) + perm)
      }
    }
    result
  }

  permute(nums)
}
