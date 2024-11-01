import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<T, U>(
  items: T[],
  predicate: (item: T) => boolean,
  consumer: (item: T) => U
): U | undefined {
  const foundItem = items.find(predicate)
  if (foundItem !== undefined) {
    return consumer(foundItem)
  }
  return undefined
}

export function* powersGenerator(base: bigint): Generator<bigint> {
  for (let power = 1n; ; power *= base) {
    yield power
  }
}

export async function meaningfulLineCount(filename: string): Promise<number> {
  try {
    const fileHandle = await open(filename, "r")
    const data = await fileHandle.readFile("utf8")
    await fileHandle.close()

    const lines = data.split("\n")
    const validLines = lines.filter(
      (line) => line.trim() !== "" && !line.trim().startsWith("#")
    )

    return validLines.length
  } catch (error) {
    if (error instanceof Error) {
      throw new Error(`Error reading file: ${error.message}`)
    } else {
      throw new Error("Unknown error occurred while reading the file")
    }
  }
}

interface Sphere {
  kind: "Sphere"
  radius: number
}

interface Box {
  kind: "Box"
  width: number
  length: number
  depth: number
}

export type Shape = Sphere | Box

export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return 4 * Math.PI * shape.radius ** 2
    case "Box":
      return (
        2 *
        (shape.width * shape.length +
          shape.length * shape.depth +
          shape.depth * shape.width)
      )
  }
}

export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return (4 / 3) * Math.PI * shape.radius ** 3
    case "Box":
      return shape.width * shape.length * shape.depth
  }
}

export interface BinarySearchTree<T> {
  size(): number
  insert(value: T): BinarySearchTree<T>
  contains(value: T): boolean
  inorder(): Iterable<T>
  toString(): string
}

export class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0
  }

  insert(value: T): BinarySearchTree<T> {
    return new Node(value, new Empty(), new Empty())
  }

  contains(value: T): boolean {
    return false
  }

  inorder(): Iterable<T> {
    return []
  }

  toString(): string {
    return "()"
  }
}

export class Node<T> implements BinarySearchTree<T> {
  constructor(
    private value: T,
    private left: BinarySearchTree<T>,
    private right: BinarySearchTree<T>
  ) {}

  size(): number {
    return 1 + this.left.size() + this.right.size()
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      return new Node(this.value, this.left.insert(value), this.right)
    } else if (value > this.value) {
      return new Node(this.value, this.left, this.right.insert(value))
    }
    return this
  }

  contains(value: T): boolean {
    if (value === this.value) {
      return true
    } else if (value < this.value) {
      return this.left.contains(value)
    } else {
      return this.right.contains(value)
    }
  }

  inorder(): Iterable<T> {
    function* inorderTraversal(node: BinarySearchTree<T>): IterableIterator<T> {
      if (node instanceof Node) {
        yield* inorderTraversal(node.left)
        yield node.value
        yield* inorderTraversal(node.right)
      }
    }
    return inorderTraversal(this)
  }

  toString(): string {
    const leftStr = this.left instanceof Empty ? "" : `${this.left}`
    const rightStr = this.right instanceof Empty ? "" : `${this.right}`
    return `(${leftStr}${this.value}${rightStr})`
  }
}