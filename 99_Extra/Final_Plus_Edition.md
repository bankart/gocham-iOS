## utf-8, 16 차이
- 문자 하나를 표현할 때 사용할 최소 byte 에서 차이가 발생
- utf-8 은 문자 하나당 1 ~ 4bytes 필요
- utf-16 은 문자 하나당 2bytes, 4bytes 필요
- 즉 표현 문자 하나당 8bit 가 필요한지 16bit 가 필요한지의 차이이다.
- 저장/통신시 소모되는 용량을 아껴야 하는 상황이라면 선택해야할 필요가 있다.




## OSI 7 Layers
- 7 ~ 1 layer 순
- Application(DHCP, DNS, FTP, HTTP: 서비스 제공) -> Presentation(JPEG, MPEG, SMB, AFP: 이해할 수 있는 포맷 변환) -> Session(SSH, TLS: application 간 질서 제어) -> Transport(TCP, UDP, ARP: 게이트웨이 사용) -> Network(IP, ICMP, IGMP: 라우터 사용) -> DataLink(MAC, PPP: 브리지, 스위치 등 사용) -> Physical(Ethernet_RS-232C: 허브, 리피터 등 사용)




## TCP/UDP
- IP
    - Internet(inter-network 줄임말) Protocol
    - 서로 다른 네트워크이기 때문에 독립된 관리자가 존재하며 이는 '반드시 통신이 가능하다'는 것을 보장하지 못함
    - 그렇기 때문에 IP 를 설명하는 중요한 특성으로 best effort(최대한 노력함) 라는 표현을 씀
- TCP
    - Transmission Control Protocol: 전송 제어 프로토콜. 안정적으로 패킷이 가지 못하는 경우 이걸 캐치해서 안정적으로 갈 수 있게 전송을 제어하는 역할을 하는 프로토콜.
    - ACK, 타임아웃, 재전송 을 통해 이를 가능하게 함
        - ACK: Ackknowledgement 의 앞글자. TCP 는 패킷을 받을 때마다 ACK 를 만들어 '잘 받았음. 다음 받아야할 패킷은 몇 번 패킷?' 이라고 알려줌. 그럼 보낸 쪽에서 이걸 이용해 잘 전송되고 있는지 판단할 수 있음.
        - 이렇게 ACK 를 이용해 전송 상태를 확인하는데, 일정시간동안 ACK 가 오지 않으면 해당 패킷을 다시 전송함. 그래서 전송 속도가 느림.
- UDP
    - VoIP 처럼 안정성 보다는 속도가 우선인 경우 UDP 를 사용하는데, UDP 가 빠른 이유는 TCP 와 구색을 맞추기 위해 만들어진 별 기능이 없는 껍데기에 불과하기 때문. IP 와 마찬가지로 불안정한 best effort 에 그냥 전송함.
- 위의 특성때문에 TCP 가 자신의 속도를 줄여서 전체 버퍼를 줄이면 UDP 가 그 버퍼를 다 사용해 버리는 문제가 있음. 그래서 통신사에서는 VoIP 서비스를 좋아하지 않는 듯.. 




## get/post 차이
- get
    - url 뒤에 ? 로 연결되어 key=value 형식으로 전달
    - url 뒤에 붙기 때문에 길이 제한이 있어서 많은 양의 데이터를 전송하기 어려움
    - ex) http://url/bbslist.html?id=5&pagenum=2
    - select 의 성격을 가지고 있어서 서버로부터 데이터를 가져와 보여주는 용도. 게사판의 리스트나 글 보기 기능 등
- post
    - http body 안에 숨겨서 전달
    - 용량제한이 없는 것은 아니지만 비교적 대용량의 데이터를 전송할 수 있음(multipart/form-data)
    - 서버의 값이나 상태를 바꾸기 위해 사용. 글쓰기를 하면 글의 내용이 DB 에 저장되고, 수정하면 DB 값이 수정되는 등
- client 에서 server 로 데이터를 전송하려면 일반적으로 get/post 를 사용





## types
- Value / Reference
   - value: structs(Int, Bool, String, Tuple, Array...), enums
   - referenece: classes, closures
- Named / Compounded
    - named: classes, enums, protocols, structures
    - compounded: functions, tuples





## Queue/Stack/Array 차이
- Queue
    - FIFO(Fisrt In Fisrt Out)
    - 자료구조로 LinkedList 또는 Array 를 사용
    - LinkedList 라면 head 영역에 enqueue 하고, tail 영역에서 dequeue 하므로 O(1) 로 성능이 좋음
    - 하지만 다른 요소에 대한 접근 속도는 느림
    - Array 라면 inasert(at:0) 하면서 기존 요소들을 한 칸씩 뒤로 밀어야 하므로 성능이 좋지 않음.(고정 사이즈가 아닌 동적 사이즈의 배열이라면 capcity 에 도달하여 기존의 2배로 capacity 가 늘어나는 순간은 기존 요소 copy 에 O(n) + 추가되는 요소 O(1) 의 시간복잡도를 나타냄. 하지만 2배로 증가되는 상황이 자주 발생하는 게 아니기 때문에 amortized O(1) 로 표현함.) removeLast()/pop() 은 동일 성능 O(1)
- Stack
    - LIFO(Last In First Out)
    - 성능및 자료구조에 대한 것은 Queue 와 동일
- Array
    - index 를 알고 있는 경우 해당 데이터에 신속히 접근할 수 있고, 새로운 요소도 매우 빠르게 삽입할 수 있음
    - 삭제 및 검색은 느림
    - 동적 사이즈의 배열은 위에 설명한 것과 같은 성능
    - Value, Referenece type 에 따라 성능이 다름(Array/ContiguousArray - value type 이 요소인 경우 인접한 메모리 영역에 저장되어 성능이 좋음. reference type 인 경우 내부적으로 NSArray 로 bridging 됨
    ArraySlice 는 인접한 메모리 영역에 차례로 할당되어 성능이 좋으나 원본 Array/ContiguousArray 과 메모리를 공유하므로 closure 에서 암묵적으로 참조하여 life cycle 을 늘려서 성능을 저하시키지 않도록 주의해야 함)



## Asymptotic Notation
- 데이터의 개수 n -> inf 일 때, 수행시간이 증가하는 growth rate 로 시간복잡도를 표현하는 기법
- Big-O(최악), Theta(최악, 최선의 평균. 하지만 로직이 조금만 복잡해져도 도출해내기 어렵다. 그렇기 때문에 Big-O 를 사용하게 됨), Omega(최선), Amortized(분할상환) 등을 사용
- 최고차항의 차수만으로 표시
- 따라서 **가장 자주 실행되는 연산 혹은 문장**의 실행횟수를 고려하는 것으로 충분


### 상수(constant) 시간복잡도
``` swift
func sample(input: [Int], n: Int) -> Int {
  let k = n / 2		// 1회 실행
  return input[k]		// 1회 실행
}
```
입력받은 데이터와 무관하게 1회 실행. 결국 n 에 관계없이 상수 시간이 소요된다. 이 경우 시간복잡도는 O(1) 이다.


### 선형(linear, 1차 함수) 시간복잡도
#### sample0
``` swift
func sum(input: [Int], n: Int) -> Int {
  var sum = 0
  for i in 0 ..< n {
    sum += input[i]		
    // 가장 자주 실행되는 문장. 실행 횟수는 항상 n 번. 모든 문장의 실행 횟수의 합은 n 에  선형적으로 비례하며, 
    // 모든 연산(for loop 에서 i 의 증가 같은..)들의 실행횟수의 합도 역시 n 에 선형적으로 비례한다.
  }
  return sum
}
```
이와 같은 경우 선형 시간복잡도를 가진다고 말하고, 최선/최악/평균을 정의할 수 없고 O(n) 이라고 표기한다.

#### sample1
순차탐색(Sequencial Search)
``` swift
func search(n: Int, input: [Int], target: Int) -> Int? {
  for i in 0 ..< n {
    if input[i] == target {		// 가장 자주 실행되는 문장 ( if 및 == 연산  )
    	return i
    }
  }
  return nil
}
```
주어진 데이터의 정렬 상태에 따라 달라지므로 최악의 경우 O(n) 이다.


### Quadratic(2차 함수) 시간복잡도
``` swift
func isDistinct(n: Int, input: [Int]) -> Bool {
  for i in 0 ..< n {
    for j in stride(from: i + 1, to: n-1, by: 1) {
      if input[i] == input[j] { // 가장 자주 실행되는 문장. 최악의 경우 n    n-1)/2 회 실행
        return false
      }
    }
  }
  return true
}
```
최악의 경우 배열에 저장된 모든 원소 쌍을 비교하므로 비교 연산의 횟수는 n(n-1)/2 이다. 
n(n-1)/2 = n^2/2 - n/2 >> 상수항 제거 >> n^2 - n >> 가장 큰 차수만 남김 >> n^2
최악의 시간복잡도는 O(n^2) 으로 나타낸다.


### Amortized Time Complexity
- 동적 배열 스택같은 구조에 대해 시간 복잡도를 체크할 때 사용. 
- 용량이 부족한 경우에만 size 가 2배로 증가하고, 요소들을 복사하는 연산이 발생함. 
- size 가 2배가 되는 경우를 기준으로 시간복잡도를 계산하면 실제 성능과 너무 큰 차이가 발생.
- 그러므로 전체 연산을 기준으로 분할한 값을 시간복잡도로 산정함.





## quick/merge sort

``` swift
func testSortAlogorithm() {
    print("\n\(#function)")
    let source = [10, 2, 5, 12, 7, 25, 6]
    func quicksort() {
        print("\n\n\(#function)")
        enum SortMethod {
            case lomuto, hoare, hoareImproved
        }
        
        func quickSort<T: Comparable>(method: SortMethod, input: inout [T], low: Int, high: Int) {
            guard low < high else { return }
            let pivot: Int
            switch method {
            case .lomuto:
                pivot = partitionLomuto(input: &input, low: low, high: high)
                quickSort(method: method, input: &input, low: low, high: pivot - 1)
                quickSort(method: method, input: &input, low: pivot + 1, high: high)
                
            case .hoare:
                pivot = partitionHoare(input: &input, low: low, high: high)
                quickSort(method: method, input: &input, low: low, high: pivot)
                quickSort(method: method, input: &input, low: pivot + 1, high: high)
                
            case .hoareImproved:
                let median = findMedian(input: &input, low: low, high: high)
                pivot = partitionHoareImporved(input: &input, low: low, high: high, median: median)
                quickSort(method: method, input: &input, low: low, high: pivot)
                quickSort(method: method, input: &input, low: pivot + 1, high: high)
            }
        }
        
        func partitionLomuto<T: Comparable>(input: inout [T], low: Int, high: Int) -> Int {
            let pivot = input[high]
            var i = low
            for j in low..<high {
                if input[j] < pivot {
                    input.swapAt(i, j)
                    i += 1
                }
            }
            input.swapAt(i, high)
            return i
        }
        
        func partitionHoare<T: Comparable>(input: inout [T], low: Int, high: Int) -> Int {
            let pivot = input[low]
            var i = low - 1
            var j = high + 1
            while true {
                i += 1
                while input[i] < pivot { i += 1 }
                j -= 1
                while input[j] > pivot { j -= 1 }
                if i >= j { return j }
                input.swapAt(i, j)
            }
        }
        
        func partitionHoareImporved<T: Comparable>(input: inout [T], low: Int, high: Int, median: T) -> Int {
            var i = low - 1
            var j = high + 1
            while true {
                i += 1
                while input[i] < median { i += 1 }
                j -= 1
                while input[j] > median { j -= 1 }
                if i >= j { return j }
                input.swapAt(i, j)
            }
        }
        
        func findMedian<T: Comparable>(input: inout [T], low: Int, high: Int) -> T {
            let center = low + (high - low) / 2
            if input[low] > input[center] {
                input.swapAt(low, center)
            }
            if input[low] > input[high] {
                input.swapAt(low, high)
            }
            if input[center] > input[high] {
                input.swapAt(center, high)
            }
            input.swapAt(center, high)
            return input[high]
        }
        
        var temp = source
        print("= lomuto =\n\(temp)")
        quickSort(method: .lomuto, input: &temp, low: 0, high: temp.count - 1)
        print(temp)
        print()
        temp = source
        print("= hoare =\n\(temp)")
        quickSort(method: .hoare, input: &temp, low: 0, high: temp.count - 1)
        print(temp)
        print()
        temp = source
        print("= hoare improved =\n\(temp)")
        quickSort(method: .hoareImproved, input: &temp, low: 0, high: temp.count - 1)
        print(temp)
        
    }
    quicksort()
    
    
    func mergeSort() {
        print("\n\n\(#function)")
        func mergeSort<T: Comparable>(input: [T]) -> [T] {
            guard input.count > 1 else { return input }
            let center = input.count / 2
            return merge(leftPile: mergeSort(input: Array(input[..<center])), rightPile: mergeSort(input: Array(input[center...])))
        }
        
        func merge<T: Comparable>(leftPile: [T], rightPile: [T]) -> [T] {
            var i = 0, j = 0
            var merged = [T]()
            while i < leftPile.count && j < rightPile.count {
                if leftPile[i] < rightPile[j] {
                    merged.append(leftPile[i])
                    i += 1
                } else if leftPile[i] > rightPile[j] {
                    merged.append(rightPile[j])
                    j += 1
                } else {
                    merged.append(leftPile[i])
                    i += 1
                    merged.append(rightPile[j])
                    j += 1
                }
            }
            
            merged += Array(leftPile[i...])
            merged += Array(rightPile[j...])
            
            return merged
        }
        
        print("= merge =\n\(source)")
        let result = mergeSort(input: source)
        print("result: \(result)")
    }
    mergeSort()
    print()
    print()
}
```




## LRUCache
``` swift
final class DoublelyLinkedListNode<T> {
    var payload: T
    var next: DoublelyLinkedListNode?
    var previous: DoublelyLinkedListNode?
    init(_ payload: T) {
        self.payload = payload
    }
}

extension DoublelyLinkedListNode: CustomStringConvertible {
    var description: String {
        return "\(payload)"
    }
}


/*
 LRU 최근에 사용되지 않은 캐시를 삭제하려면..
 새로 추가되는 데이터는 addHead 함수를 이용해 head 를 update
 이미 저장된 데이터에 접근시 moveToHead 함수를 이용해 해당 node 를 head 로 이동
 buffer 가 가득 찬 경우 removeLast 함수를 이용해 tail 부터 삭제
 count 가 1인 경우 함수에서 head/tail 관리를 잘 해줘야 함
 */
final class DoublelyLinkedList<T> {
    typealias Node = DoublelyLinkedListNode<T>
    private var head: Node?
    private var tail: Node?
    private(set) var count: Int = 0
    
    func addHead(_ value: T) -> Node? {
        var node = Node(value)
        defer {
            head = node
            count += 1
        }
        
        guard let head = head else {
            tail = node
            return node
        }
        
        head.previous = node
        node.next = head
        node.previous = nil
        
        return node
    }
    
    func moveToHead(_ node: Node) {
        guard node !== head else { return }
        
        let prev = node.previous
        let next = node.next
        
        prev?.next = next
        next?.previous = prev
        
        node.next = head
        node.previous = nil
        
        if node === tail {
            tail = prev
        }
        
        self.head = node
    }
    
    func removeLast() -> Node? {
        guard let tail = tail else { return nil }
        
        let prev = tail.previous
        prev?.next = nil
        self.tail = prev
        
        if count == 1 {
            head = nil
        }
        
        count -= 1
        
        return tail
    }
}

extension DoublelyLinkedList: CustomStringConvertible {
    var description: String {
        var current = head
        var desc = current!.description
        while current != nil {
            current = current!.next
            if current != nil {
                desc += ", " + current!.description
            }
        }
        desc += ", count: \(count)"
        return desc
    }
}


final class LRUCache<Key: Hashable, Value> {
    // LinkedList 에 저장될 타입
    private struct CachePayload: CustomStringConvertible {
        let key: Key
        let value: Value
        
        var description: String {
            return "\(String(describing: key)), \(String(describing: value))"
        }
    }
    
    // 우선 순위를 조절하는 LinkedList
    private var list = DoublelyLinkedList<CachePayload>()
    // 데이터를 저장하는 딕셔너리
    private var nodeDic = [Key: DoublelyLinkedListNode<CachePayload>]()
    // buffer capacity
    let capacity: Int
    
    init(capacity: Int) {
        self.capacity = max(0, capacity)
        nodeDic.reserveCapacity(capacity)
    }
    
    func set(_ value: Value, for key: Key) {
        let payload = CachePayload(key: key, value: value)
        if let node = nodeDic[key] {
            node.payload = payload
            list.moveToHead(node)
        } else {
            let node = list.addHead(payload)
            nodeDic[key] = node
        }
        
        if list.count > capacity {
            let node = list.removeLast()
            if let key = node?.payload.key {
                nodeDic[key] = nil
            }
        }
    }
    
    func get(for key: Key) -> Value? {
        guard let node = nodeDic[key] else { return nil }
        list.moveToHead(node)
        return node.payload.value
    }
    
}
```




## HashTable
``` swift
/*
 해쉬 충돌이 결국 발생할 수 밖에 없다면 빈도수를 최소화할 수 있도록 구현해야 함
 1. 체이닝: 충돌이 발생한 해쉬에 대해 포인터를 연결하여 값을 추가하는 방식(LinkedList, Array..)
 2. 적재율 제어: 전체 목록의 수에서 저장된 key 의 수를 나눈 값으로 적재율을 낮게 유지함(공간 낭비가 심함)
 3. 해쉬함수 설계: 0~(n-1) 까지 고르게 나타나야 하며, 해쉬 값들이 서로 연관되지 않고 독립적으로 나타나야 특정 패턴으로 해쉬가 나타나지 않고 충돌을 방지할 수 있음
 4. modular method: hash % m(목록.count) 으로 index 를 계산. 적재율이 30% 이하로 유지되면 충돌가능성이 거의 없다고 함. m 이 목록.count * 3 이고, 2 의 지수승에 가까운 소수인경우 성능이 가장 좋다고 함
 
 5. open address probing: h(k) -> hash = k % 목록.count 로 추출한 해쉬가 충돌할 경우 memeber 로 가지는 변수 i 따위로 hash = hash + i; i += 1; 형식으로 충돌 이후 다음 위치로 이동시키며 충돌하지 않는 위치에 값을 저장. 하지만 primary clustering 문제 발생. 특정 위치에 값이 몰리는 현상
 6. quadratic probing: h(k) -> (k + i^2) % m 으로 추출한 해쉬 사용. 하지만 이 경우에도 secondary clustering 문제 발생. 첫 번째 해쉬가 충돌하는 경우 그 이후는 계속 충돌 발생
 7. double hashing: h(k) -> (h1(k) + (i * h2(k))) % m
    h1(k) -> k % m, h2(k) -> k % m2    m2 는 m 보다 작은 적당한 수
 */

struct HashTable<Key: Hashable, Value> {
    private let defaultSize: Float = 5//128
    // resizing 시 불필요한 공간 낭비를 막고 충돌을 최소화될만한 사이즈 계산을 위한 변수
    private let threshold: Float = 0.75
    private var maxCount: Int
    
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    private var capacity: Int
    private(set) var count: Int = 0
    var isEmpty: Bool {
        return count == 0
    }
    
    init(capacity: Int) {
        self.capacity = capacity
        buckets = [Bucket](repeating: [], count: capacity)
        maxCount = Int(defaultSize / threshold)
    }
    
    // hash function
    private func index(forKey key: Key) -> Int {
        return abs(key.hashValue) % buckets.count
    }
    
    mutating private func resize() {
        print("\n\(#function)")
        print("buckets: \(buckets)")
        let oldCapacity = capacity
        capacity = Int(Float(buckets.count * 2) * threshold)
        maxCount = Int(Float(count * 2) * threshold)
        var temp = [Bucket](repeating: [], count: capacity)
        for index in 0..<oldCapacity {
            for (_, element) in buckets[index].enumerated() {
                let newIndex = element.key.hashValue % capacity//self.index(forKey: element.key)
                temp[newIndex].append(element)
            }
        }
        buckets = temp
        print("newBuckets: \(buckets)")
    }
    
    // 있으면 update & return old value, 없으면 append new element & return nil
    @discardableResult
    mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                let oldValue = element.value
                buckets[index][i].value = value
                return oldValue
            }
        }
        
        buckets[index].append(Element(key: key, value: value))
        count += 1
        print("\n\(#function)")
        print("buckets: \(buckets)")
        
        if count > maxCount {
            resize()
        }
        
        return nil
    }
    
    @discardableResult
    mutating func removeValue(forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                let oldValue = element.value
                buckets[index].remove(at: i)
                count -= 1
                return oldValue
            }
        }
        return nil
    }
}
```


