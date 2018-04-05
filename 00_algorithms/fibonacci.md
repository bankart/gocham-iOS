피보나치 수열
==========
n = n - 1 + n -2 를 만족하는 수열

0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, .....

[위키피디아 링크](https://en.wikipedia.org/wiki/Fibonacci_number)



``` swift
// >> 수열 구하기 >>

// time: O(n), space: O(n)
func fib(_ n: Int) -> [Int] {
    var numbers = [Int]()
    for i in 0..<n {
        if i <= 1 {
            numbers.append(i)
        }
        numbers.append(numbers[n-2] + numbers[n-1])
    }
    return numbers
}

// time: O(n), space: O(n)
func anotherFib(numSteps: Int) -> [Int] {
    var sequence = [0, 1]
    if numSteps <= 1 {
        return sequence
    }
    // 이미 sequence 에 0, 1 을 추가해 두었기 때문에 numSteps - 2 까지 loop
    for _ in 0...numSteps - 2 {
        let first = sequence[sequence.count - 1]
        let second = sequence.last!
        sequence.append(first + second)
    }
    return sequence
}
// << 수열 구하기 <<


// >> 수열의 합 구하기 >>

// time: O(nlogn)
// n = 5 인 경우, 총 15 회의 함수 호출이 발생 (대략 5 * log(5))
// sumOfFib(0) = 3회, sumOfFib(1) = 5회, sumOfFib(2) = 3회, sumOfFib(3) = 2회, sumOfFib(4) = 1회, sumOfFib(5) = 1회
func sumOfFib(_ n: Int) -> Int {
    if n <= 1 { return n}
    return fib2(n-2) + fib(n-1)
}

// memoization 사용하여 복잡도를 완화시킴
// time: O(n), space: O(n)
// memo 변수에 동일한 n 값에 대해 값을 저장함. 그럼 중복 되는 n 에 대한 함수 호출시 연산을 수행하지 않고 memo 에서 값을 꺼내 바로 반환함
func fibWithMemo(_ n: Int, memo: inout [Int: Int]) -> Int {
    if n <= 1 { return n}
    if let exist = memo[n] { return exist }
    memo[n] = fibWithMemo(n-2, memo: &memo) + fibWithMemo(n-1, memo: &memo)
    return memo[n]!
}
// << 수열의 합 구하기 <<
```

