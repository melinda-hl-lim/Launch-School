# RB-130 More Ruby Foundations

## Blocks

### [ ] Closures and scope

**Def'n Closure.** A general programing *concept* (i.e. idea) that allows programmers to save a "chunk of code" and execute it at a latter time. 

**Scope:** Closures **bind** to its surrounding artifacts -- variables methods, objects -- and build *enclosures* around everything so they can be referenced when the closure is later executed.

In Ruby, closures are implemented throughthree main ways: `Proc` objects, lambdas, or blocks.
- blocks are a form of `Proc`s

### [ ] How blocks work, and when we want to use them.

**HOW BLOCKS WORK**

*When to use blocks in our methods*
Two main cases where using blocks in our methods is useful:
1. Defer some code implementation to the method invoker
2. Sandwich code: methods that perform some "before" and "after" actions

### [ ] Blocks and variable scope

At the core of variable scoping in Ruby: "inner scopes can access outer scopes". (Ruby implements closures at the core of how variable scope works.)

**Def'n Binding.** The surrounding environment/context (relative to a piece of code).
Blocks and `Proc`s keep track of its binding and can reference  

### [ ] Write methods that use blocks and procs

To invoke a block passed in as an argument, we use the `yield` keyword. However, if a block isn't a guaranteed argument, we want to use the `Kernel#block_given?` method to avoid getting a `LocalJumpError` (because `yield` expects a block).

If the block requires an argument, we pass in the argument to the `yield` keyword like: `yield(arg)`.

### [ ] Methods with an explicit block parameter

The explicit block parameter is defined by prefixing `&` in the method definition.
Ex: `def test(&block) ... `

The `&block` is a special parameter that converts the block argument into a *"simple" `Proc`* object or block.

### [ ] Arguments and return values with blocks

**Def'n Arity.** The rules regarding the number of *arguments* you can pass to a closure.
- Ruby has lenient arity rules -- you can pass in a different number of arguments than expected by the block, no `ArgumentError` is raised. 

To pass in an argument to a block, we pass the argument to the `yield` keyword like: `yield(arg)`.

The *return value* of a block is determined by the last expression in the block.

### [ ] When can you pass a block to a method

Every method written in Ruby can already take a block as an implicit argument. 

However, to pass a block into *another* method during a method invocation, the block must be an explicitly defined parameter.
``` ruby
def test(&block) # Explicitly define block as a parameter
  test_2(block) # we can now pass it to another method invocation
end

def test_2(block)
  block.call # Calls the block (converted into a Proc object) that was passed in during `test` method invocation
end
```

### [ ] &:symbol

The `&:method_name` format allows us to pass in methods that take no arguments into methods that take blocks as an argument. 

``` ruby
[1, 2, 3, 4, 5].map(&:to_s) 
```

In the example above, `map` iterates through every element in the array and calls `to_s` on it, and returns a new array with each `Integer` as a `String`. 

To convert `:to_s` into a `to_s` method invocation on each element, a couple things happen:
1. Ruby checks whether the object after `&` is a `Proc`. 
2. If the object is not a `Proc`, it will try call `#to_proc` on the object. 

Method `Symbol#to_proc` returns a `Proc` object which will execute the ethod based on the name of the symbol. 


### Methods we implemented for practice
- times
- each
- select
- reduce

--- 

## Testing With Minitest

### [ ] Testing terminology
### [ ] Minitest vs. RSpec
### [ ] SEAT approach
### [ ] Assertions

--- 

## Core Tools/Packaging Code

## [ ] Purpose of core tools
## [ ] Gemfiles

---

## Regular Expressions