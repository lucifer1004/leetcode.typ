#import "helpers.typ": *

#align(center)[
  #box(baseline: 12pt)[#image("images/logo.png", height: 48pt)] 
  #h(12pt)
  #text(48pt)[*Leetcode.typ*]
]
#v(2em)
#outline()

#counter(page).update(0)
#set smartquote(enabled: false)
#set par(justify: true)
#set page(numbering: "1")
#set heading(numbering: (..nums) => {
  let chars = str(nums.pos().at(0)).clusters().rev()
  while chars.len() < 4 {
    chars.push("0")
  }
  chars.rev().join() + "."
})
#show heading: it => {
  if it.level == 1 {
    pagebreak(weak: true)
  }
  it
  v(1em)
}

#include "problems/p0001.typ"
#include "problems/p0002.typ"
#include "problems/p0003.typ"
#include "problems/p0004.typ"
#include "problems/p0005.typ"
#include "problems/p0006.typ"
#include "problems/p0007.typ"
#include "problems/p0008.typ"
#include "problems/p0009.typ"
#include "problems/p0010.typ"
#include "problems/p0011.typ"
#include "problems/p0012.typ"
#include "problems/p0013.typ"
#include "problems/p0014.typ"
#include "problems/p0015.typ"
#include "problems/p0016.typ"
#include "problems/p0017.typ"
#include "problems/p0018.typ"
