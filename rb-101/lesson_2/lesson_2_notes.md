## Pass By Reference Vs. Pass By Value


### Definitions

"Pass by Value": The method has a *copy* of the original object. Operations performed on the object within the method have no effect on the original object outside the method.

"Pass by Reference": The method receives a reference (address in stack) to the original object. Operations within the method can affect the original object.


### Variables as Pointers

*Recall*: Variables are pointers to physical space in memory. Objects each get their own space in memory. See examples below:

Below, `a` and `b` initially point at the same location in memory. However, `a` is assigned to a new String object, so in the end `a` and `b` point to different locations in memory.

``` ruby
a = "hi there"
b = a
a = "not here"
# => a = "not here"
# => b = "hi there"
```

Below, `a` and `b` point at the same location in memory. The object in that location is then mutated to add ", Puppi".

```ruby
a = "hi there"
b = a
a << ", Puppi"
# => a = "hi there, Puppi"
# => b = "hi there, Puppi"
```


**Additional note supplements from Medium posts**

### Variable References and Mutability of Ruby Objects



### Mutating and Non-Mutating Methods in Ruby

### Object Passing in Ruby - Pass by Reference of Pass by Value?
