## 2. Child Nodes

Main problem was counting number of children

Further exploration: 

Write a function `childNodes(node)` that returns an array with: 
- the number of direct children nodes, 
- the number of indirect children nodes (child of child)

``` js
function countChildren(node) {
  return node.children.length;
}

function walk(node, callback) {
  let count = callback(node);
  for (let index = 0; index < node.children.length; index += 1) {
    count += walk(node.children[index], callback);
  }
  return count;
}

function childNodes(node) {
  const directCount = countChildren(node);
  const allCount = walk(node, countChildren);

  return [directCount, allCount];
}
```


## 3. Tracing the DOM Tree

Write a JS function that: 
- takes an element's `id`
- returns the DOM tree of the element in a 2D array. 
  - The first subarray contains the element and its siblings, 
  - the second contains the parent of the element and its siblings, so on and so forth, all the way up to the "grandest" parent. 

Assume that the grandest parent is the element with an `id` of `"1"`. Use the given HTML and test cases to test your code.

*Melinda work*

Input: a dom element's id
Output: a 2D array of the DOM tree
  - first subarray: arg element and its siblings
  - second subarray: parent and siblings up to root of tree 

Rules:
- root of tree has id = 1
- each subarray is one layer of the tree
- reading subarrays in order effectively goes up the tree layer by layer (i.e. subarrays are ordered leaf to root) 

Algorithm:
- base case: if id === 1, then we're at the root of the tree. 
  - return: `[[rootTagName/NodeName]]`

- retrieve current node with given id
  - `document.getElementById(id)` returns a reference to the node itself
  - to get the name, we want `node.tagName`
- retrieve current node's siblings
  - while previous/next sibling isn't null, fetch previous/next sibling and add to array
- assemble first subarray of current node and siblings

- make recursive call with current node's parent as the argument
  - expect to get `[[parentLayer], [grandparentLayer], ... , [rootLayer]]`

- concat currentNodeSiblings array with results of recursive call
- return concated array

``` js
function domTreeTracer(id) {
  const currentNode = document.getElementById(id);
  const parent = currentNode.parentNode;

  if (parent.tagName === 'BODY') {
    return [[currentNode.tagName]];
  }

  let { children } = parent;
  children = [].slice.call(children);
  const currentLayer = children.map(({ tagName }) => tagName);

  const parentLayers = domTreeTracer(parent.id);
  parentLayers.unshift(currentLayer);

  return parentLayers;
}
```

Launch School's Solution:
``` js
function domTreeTracer(id) {
  let currentElement = document.getElementById(id);
  let parentElement;
  const domTree = [];

  do {
    parentElement = currentElement.parentNode;
    let children = getTagNames(parentElement.children);
    domTree.push(children);

    currentElement = parentElement;
  } while (parentElement.tagName !== 'BODY');

  return domTree;
}

function getTagNames(htmlCollection) {
  const elementsArray = Array.prototype.slice.call(htmlCollection);
  return elementsArray.map(({tagName}) => tagName);
}
```


## 4. Tree Slicing

Implement a function, `sliceTree`, that is "similar" to the `Array.prototype.slice()` method, but this time for a DOM tree. The `sliceTree` function takes two arguments: 
- the start index, which is the parent node's `id` attribute, 
- and the end index, which is the innermost child node's `id` attribute.
The function returns an array of `tagNames`. 

Note the following when implementing the `sliceTree` function:
- This function is inclusive of the right hand side
- Only consider element nodes
- Only elements that have `body` as an ancestor are sliceable
- If the `id` attribute of the start or end index is not in the DOM, return `undefined`
- If the slice is not feasible -- i.e. there's no path between the start and end element -- return `undefined`

*Melinda work*

Assume:
- element ids are in numeric order

Algorithm:
- initialize results array
- intialize current node to the end node

- while current node's parent isn't body
  - prepend end node tag name to results array
  - set currentnode to parent

- if currentnode is the start node, prepend start node tagname and return

- otherwise we don't have a path and return undefined

``` js
function sliceTree(start, end) {
  const path = [];
  let currentNode = document.getElementById(String(end));

  if (!currentNode) { return undefined; }

  while (currentNode.parentNode.tagName !== 'BODY') {
    path.unshift(currentNode.tagName);
    if (currentNode.id === String(start)) { break; }
    currentNode = currentNode.parentNode;
  }

  if (currentNode.id === String(start)) {
    path.unshift(currentNode.tagName);
    return path;
  }

  return undefined;
}
```

TODO: functions, but needs some refactoring
- What happens if I have the `while` condition after the loop?


## 5. Coloring

Write a function that colors a specific generation of the DOM tree. 

A generation is a set of elements that are on the same level of indentation. 

We'll be using a "styled" HTML for this exercise to better visualize the generations. You may use the `.generation-color` class to color the specific generation. 

You can assume that only non-negative integers will be provided as arguments. 

``` js
function nodesInGenNum(node, selfGenNum, targetGenNum) {
    if (selfGenNum === targetGenNum) {
      return [node];
    }

    let { children } = node;
    children = [].slice.call(children);

    children = children.map((childNode) => nodesInGenNum(childNode, selfGenNum + 1, targetGenNum));

    return children.flat();
  }

  function color(genNum) {
    const rootNode = document.querySelector('body');
    const nodes = nodesInGenNum(rootNode, 0, genNum);

    nodes.forEach((node) => {
      node.classList.add('generation-color');
    });
  }

  color(0);
});
```


## 6. Node Swap

Write a function that takes two element `id`s as arguments and swaps the positions of the elements represented by the `id`s. The function returns `true` for valid swaps and `undefined` for invalid. 

You can assume that nodes will have a value for the `id` attribute and two arguments will always be provided. 

WIP
``` js
document.addEventListener('DOMContentLoaded', () => {
  function isChildOf(parent, child) {
    const children = [].slice.call(parent.children);

    return children.includes(child);
  }

  function nodeSwap(id1, id2) {
    const node1 = document.getElementById(id1);
    const node2 = document.getElementById(id2);

    if (!node1 || !node2) { return undefined; }
    if (isChildOf(node1, node2) || isChildOf(node2, node1)) {
      return undefined;
    }

    return 'failed this test :(';
  }

  // Non-existant node
  console.log(nodeSwap(1, 20));
  // One node is child to another
  console.log(nodeSwap(1, 4));
  console.log(nodeSwap(9, 3));
  // Should work
  console.log(nodeSwap(1, 2));
});

```

## 7. Nodes to Array

Implement a function that converts the DOM, starting from the `body`, to nested arrays. 

Each element in the DOM is represented as `["PARENT_TAG_NAME", [children]]` where children are elements as well and as such follow the same format. 

When an element has no children, it's represented as `["PARENT_TAG_NAME", []]`. 

``` js
function nodesToArrayWithArg(node) {
    if (node.children.length === 0) {
      return [node.tagName, []];
    }

    const children = [].slice
      .call(node.children)
      .map((child) => nodesToArrayWithArg(child));

    return [node.tagName, children];
  }

  function nodesToArray() {
    const rootNode = document.querySelector('body');
    return nodesToArrayWithArg(rootNode);
  }
```

## 8. Array to Nodes



## 9. Work Back

## 10. HTML Imaging
