## Classes and Objects

### Exercises:

``` ruby
class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{self.first_name} #{self.last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def to_s
    name
  end

  private

  def parse_full_name(full_name)
    parts = full_name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

andrew = Person.new("Andrew Crotwell")
p andrew.first_name
p andrew.last_name
puts "The person'a name is #{andrew}"
```
