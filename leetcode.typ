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

#include "user-solutions/u0001.typ"
#include "user-solutions/u0002.typ"
#include "user-solutions/u0003.typ"
#include "user-solutions/u0004.typ"
#include "user-solutions/u0005.typ"
#include "user-solutions/u0006.typ"
#include "user-solutions/u0007.typ"
#include "user-solutions/u0008.typ"
#include "user-solutions/u0009.typ"
#include "user-solutions/u0010.typ"
#include "user-solutions/u0011.typ"
#include "user-solutions/u0012.typ"
#include "user-solutions/u0013.typ"
#include "user-solutions/u0014.typ"
#include "user-solutions/u0015.typ"
#include "user-solutions/u0016.typ"
#include "user-solutions/u0017.typ"
#include "user-solutions/u0018.typ"
#include "user-solutions/u0019.typ"
