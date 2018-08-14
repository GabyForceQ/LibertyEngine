module liberty.core.algorithm.sort;

import std.parallelism : task, taskPool;
import std.algorithm.sorting : partition;
import std.algorithm.mutation : swap;
import std.algorithm : sort;

/**
 *
**/
void parallelSort(T)(ref T[] data) {
    if (data.length < 100) {
        sort(data);
        return;
    }

    swap(data[$ / 2], data[$ - 1]);
    auto pivot = data[$ - 1];
    bool lessThanPivot(T elem) { return elem < pivot; }

    auto greaterEqual = partition!lessThanPivot(data[0..$ - 1]);
    swap(data[$ - greaterEqual.length - 1], data[$ - 1]);

    auto less = data[0..$ - greaterEqual.length - 1];
    greaterEqual = data[$ - greaterEqual.length..$];

    auto recurseTask = task!parallelSort(greaterEqual);
    taskPool.put(recurseTask);
    parallelSort(less);
    recurseTask.yieldForce;
}

/**
 *
**/
unittest {
    auto buf = [
        10, 4, 2, 9, 7, 7, 4, 32, -1, 0, 12, -1, 9, -2, 6, 4, 8, 9, 100, -34,
        10, 4, 2, 9, 7, 7, 4, 32, -1, 0, 12, -1, 9, -2, 6, 4, 8, 9, 100, -34,
        10, 4, 2, 9, 7, 7, 4, 32, -1, 0, 12, -1, 9, -2, 6, 4, 8, 9, 100, -34,
        10, 4, 2, 9, 7, 7, 4, 32, -1, 0, 12, -1, 9, -2, 6, 4, 8, 9, 100, -34,
        10, 4, 2, 9, 7, 7, 4, 32, -1, 0, 12, -1, 9, -2, 6, 4, 8, 9, 100, -34,
        10, 4, 2, 9, 7, 7, 4, 32, -1, 0, 12, -1, 9, -2, 6, 4, 8, 9, 100, -34,
        10, 4, 2, 9, 7, 7, 4, 32, -1, 0, 12, -1, 9, -2, 6, 4, 8, 9, 100, -34,
        10, 4, 2, 9, 7, 7, 4, 32, -1, 0, 12, -1, 9, -2, 6, 4, 8, 9, 100, -34
    ];
    buf.parallelSort();
    assert(buf == [
        -34, -34, -34, -34, -34, -34, -34, -34, -2, -2, -2, -2, -2, -2, -2, -2, 
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, 
        0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 
        4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 
        7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 
        9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 
        10, 10, 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 32, 32, 32, 32, 32, 
        32, 32, 32, 100, 100, 100, 100, 100, 100, 100, 100
    ], "Not sorted correctly");
}