void main() {
    var a = PartitionManager();
    var p1 = a.addPartition(40);
    var p2 = a.addPartition(40);
    var p3 = a.addPartition(40);
    p1.alloc(10);
    p1.alloc(20);
    p1.alloc(30);//fail;
    print(p1);
    p1.remove(0);
    print(p1);
    p1.alloc(5);
    print(p1);
}
class Memory{
  int start;
  int size;
  Memory next;
  Memory(this.size,this.start);
  toString() => 'start:${this.start} size:${this.size}';
}

class Partition{
  List<Memory> list = [];
  int id;
  int size;
 
  Partition next;
  Partition(this.id,this.size);
  toString() => 'id:${this.id} size:${this.size} mem:${list}';
  sortList(){
    list.sort((m1,m2) =>
      m1.start > m2.start ? 1 : -1
    );
  }
  alloc(int mem){
    var start = getFirstFreeSpace(mem);
    if( start == -1) return false;
    list.add(Memory(mem,start));
    return true;
  }
  remove(int start){
    for(var item in list){
      if(item.start == start){
        return list.remove(item);
      }
    }
  }
  getFirstFreeSpace(int requireSpace){
    sortList();
    for (int i = 0;i < list.length; i++){
      var v = list[i];
      if(i == 0 && v.start != 0 && v.start >= requireSpace){
        return 0;
      }
      var tail = i+1 < list.length ? list[i+1].start:this.size;
      var freeSize = tail - (v.start + v.size);
      if(requireSpace <= freeSize) return v.start+v.size;
    }
    return list.isEmpty?0:-1;
  }
}

class PartitionManager{
  static int count = 0;
  Partition currentNode;
  Partition firstNode;
  addPartition(int){
    if(currentNode == null){
      currentNode ??= Partition(count++,int);
      firstNode = currentNode;
      return currentNode;
    }
    currentNode.next = Partition(count++,int);
    currentNode = currentNode.next;
    return currentNode;
  }
}