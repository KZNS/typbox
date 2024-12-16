// transform
#let transform-childs(rest, func) = {
  import "../lib.typ": *

  if is-sequence(rest) {
    for item in rest.children {
      func(item)
    }
  } else if is-styled(rest) {
    let child = func(rest.child)
    reconstruct-styled(rest, child)
  } else if rest.func() == link {
    link(rest.dest, func(rest.body))
  } else if rest.has("body") {
    let fields = rest.fields()
    let body = func(fields.remove("body"))
    if rest.has("label") {
      let labe = fields.remove("label")
      [#rest.func()(body, ..fields)#labe]
    } else {
      rest.func()(body, ..fields)
    }
  } else if rest.has("children") {
    let fields = rest.fields()
    let children = fields.remove("children").map(i => func(i))
    rest.func()(..children, ..fields)
  } else {
    rest
  }
}