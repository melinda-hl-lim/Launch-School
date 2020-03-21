# Lesson 1 Walkthroughs

# Build a `#times` method
def times(num)
  counter = 0

  while counter < num
    yield(counter)
    counter += 1
  end

  num
end

# Build an `#each` method
def each(array)
  for elem in array do
    yield(elem)
  end

  array
end

# Build an `#select` method
def select(array)
  final_selections = []

  for elem in array do
    result = yield(elem)
    final_selections << elem if result
  end
  
  final_selections
end

# Build an `#reduce` method (for an array of numbers)
def reduce(array, initial_acc=0)
  accumulator = initial_acc

  for elem in array do
    accumulator = yield(accumulator, elem)
  end

  accumulator
end

# Assignment: TodoList

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def done?
    @todos.all? { |todo| todo.done? }
  end

  def <<(todo)
    raise TypeError, 'can only add Todo objects' unless todo.instance_of? Todo

    @todos << todo
  end
  alias_method :add, :<<

  def item_at(idx)
    @todos.fetch(idx)
  end

  def mark_done_at(idx)
    item_at(idx).done!
  end

  def mark_undone_at(idx)
    item_at(idx).undone!
  end

  def done!
    @todos.each_index do |idx|
      mark_done_at(idx)
    end
  end

  def remove_at(idx)
    @todos.delete(item_at(idx))
  end

  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  def to_a
    @todos.clone
  end

  # Assignment: TodoList#each
  def each
    @todos.each { |todo| yield(todo) }
    self
  end

  # Assignment: TodoList#select
  def select
    results = TodoList.new(title)

    each do |todo|
      results << todo if yield(todo)
    end

    results
  end

# Assignment: TodoList methods
  def find_by_title(str)
    select { |todo| todo.title == str }.first
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_not_done
    select { |todo| !(todo.done?) }
  end

  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end

  def mark_all_done
    each { |todo| todo.done! }
  end

  def mark_all_undone
    each { |todo| todo.undone! }
  end
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")

list = TodoList.new("Today's Todos")

list.add(todo1)          
list.add(todo2)
list.add(todo3)

