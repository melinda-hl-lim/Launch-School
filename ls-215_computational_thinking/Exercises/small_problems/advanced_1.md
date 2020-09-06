## 6. Merge Sort

*Merge sort* is a recursive sorting algorithm that works by breaking down an array's elements into nested subarrays, then combining those nested subarrays back together in sorted order. 

It is best explained with an example. Given the array `[9, 5, 7, 1]`, let's walk through the process of sorting it with merge sort. We'll start off by breaking the array down into nested subarrays:
```
[9, 5, 7, 1] -->
[[9, 5], [7, 1]] -->
[[[9], [5]], [[7], [1]]]
```
We then work our way back to a flat array by merging each pair of nested subarrays back together in the proper order:
```
[[[9], [5]], [[7], [1]]] -->
[[5, 9], [1, 7]] -->
[1, 5, 7, 9]
```
Write a function that takes an array, and returns a new array that contains the values from the input array in sorted order. The function should sort the array using the merge sort algorithm as described above. You may assume that every element of the array will be of the same data type -- either all numbers or all strings.

Feel free to use the `merge` function you wrote in the previous exercise.

*Melinda work*

Input: an array with elements
Output: a sorted array with elements

Algorithm:

1. Break array into nested subarrays
- base case: inner-most array contains a single element
  - stop breaking array and return when array length is 1
- split elements into two arrays, each roughly containing half the elements 
  - halfway = array.length / 2
  - create two subarrays by slicing to halfway index

2. Merge nested subarrays using the sorted `merge` method from last problem

``` js
function mergeSort(array) {
  if (array.length === 1) { return array; }

  let subArray1 = array.slice(0, array.length / 2);
  let subArray2 = array.slice(array.length / 2);

  subArray1 = mergeSort(subArray1);
  subArray2 = mergeSort(subArray2);

  return merge(subArray1, subArray2);
}
```

