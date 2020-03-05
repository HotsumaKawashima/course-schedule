class Solution {
    func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
        if prerequisites.count == 0 { return true }
        var (degrees, edges) = topological(numCourses, prerequisites)
        
        return solve(&degrees, edges)
    }
}

func solve(_ degrees: inout [Int], _ edges: [[Int]]) -> Bool {
    var q = [Int](repeating: -1, count: degrees.count)
    var h = 0
    var n = 0
    var seen = [Bool](repeating: true, count: degrees.count)
    
    for i in 0..<degrees.count {
        if degrees[i] == 0 {
            enqueue(&q, &h, &n, i)
        } else if degrees[i] < 0 {
            seen[i] = true
        } else {
            seen[i] = false
        }
    }
    
    print(seen)
    
    var c = dequeue(&q, &h, &n)
    
    if c < 0 { return false }

    while c >= 0 {
        seen[c] = true
        var es = edges[c]
        for e in es {
            degrees[e] -= 1
            if degrees[e] == 0 {
                enqueue(&q, &h, &n, e)
            }
        }
        c = dequeue(&q, &h, &n)
    }
    
    for s in seen {
        if !s {
            return false
        }
    }
    
    return true
}

func enqueue(_ array: inout [Int],_ head: inout Int, _ num: inout Int, _ obj:Int) {
    if num < array.count {
        array[(head + num) % array.count] = obj
        num = num + 1
    }
}

func dequeue(_ array: inout [Int],_ head: inout Int, _ num: inout Int) -> Int {
    if num > 0 {
        let obj = array[head]
        array[head] = -1
        num = num - 1
        head = (head + 1) % array.count;
        return obj
    }
    return -1
}


func topological(_ n: Int, _ pairs: [[Int]]) -> (degrees: [Int], edges: [[Int]]) {
    var degrees = [Int](repeating: -1, count: n)
    var edges = [[Int]](repeating: [Int](), count: n)
    
    for p in pairs {
        var a = p[0]
        var b = p[1]
        
        if degrees[a] < 0 { degrees[a] = 0 }
        if degrees[b] < 0 {
            degrees[b] = 1
        } else {
            degrees[b] += 1
        }
        
        edges[a].append(b)
    }
        
    return (degrees, edges)
}
