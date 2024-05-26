// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

struct IndexValue {
  uint256 keyIndex;
  uint256 value;
}
struct KeyFlag {
  uint256 key;
  bool deleted;
}

struct itmap {
  mapping(uint256 => IndexValue) data;
  KeyFlag[] keys;
  uint256 size;
}

type Iterator is uint256;

library IterableMapping {
  function insert(
    itmap storage self,
    uint256 key,
    uint256 value
  ) internal returns (bool replaced) {
    uint256 keyIndex = self.data[key].keyIndex;
    self.data[key].value = value;
    if (keyIndex > 0) return true;
    else {
      keyIndex = self.keys.length;
      self.keys.push();
      self.data[key].keyIndex = keyIndex + 1;
      self.keys[keyIndex].key = key;
      self.size++;
      return false;
    }
  }

  function remove(itmap storage self, uint256 key)
    internal
    returns (bool success)
  {
    uint256 keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0) return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size--;
  }

  function reset(itmap storage self) internal {
    for (uint256 i = 0; i < self.keys.length; i++) {
      delete self.data[self.keys[i].key];
    }
    delete self.keys;
    delete self.size;
  }

  function contains(itmap storage self, uint256 key)
    internal
    view
    returns (bool)
  {
    return self.data[key].keyIndex > 0;
  }

  function get(itmap storage self, uint256 key)
    internal
    view
    returns (uint256)
  {
    return self.data[key].value;
  }

  function iterateStart(itmap storage self) internal view returns (Iterator) {
    return iteratorSkipDeleted(self, 0);
  }

  function iterateValid(itmap storage self, Iterator iterator)
    internal
    view
    returns (bool)
  {
    return Iterator.unwrap(iterator) < self.keys.length;
  }

  function iterateNext(itmap storage self, Iterator iterator)
    internal
    view
    returns (Iterator)
  {
    return iteratorSkipDeleted(self, Iterator.unwrap(iterator) + 1);
  }

  function iterateGet(itmap storage self, Iterator iterator)
    internal
    view
    returns (uint256 key, uint256 value)
  {
    uint256 keyIndex = Iterator.unwrap(iterator);
    key = self.keys[keyIndex].key;
    value = self.data[key].value;
  }

  function iteratorSkipDeleted(itmap storage self, uint256 keyIndex)
    private
    view
    returns (Iterator)
  {
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return Iterator.wrap(keyIndex);
  }
}
