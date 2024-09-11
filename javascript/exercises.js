import { open } from "node:fs/promises"
import fs from 'fs/promises';


export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

// Write your first then lower case function here
export function firstThenLowerCase(arr, predicate) {
  const found = arr.find(predicate);
  return found?.toLowerCase();
}

// Write your powers generator here
export function* powersGenerator({ ofBase, upTo }) {
  let power = 0;
  while (ofBase ** power <= upTo) { 
    yield ofBase ** power;
    power++;
  }
}

// Write your say function here
export function say(...words) {
  // return empty if no arguments
  if (words.length === 0) {
    return "";
  }

  // chaining
  const inner = (...moreWords) => {
    if (moreWords.length === 0) {
      return words.join(" ");
    }
    return say(...words, ...moreWords);
  };

  return inner;
}

// Write your line count function here
export async function meaningfulLineCount(filename) {
  try {
    // Read file
    const data = await fs.readFile(filename, 'utf8');
    
    // Split content
    const lines = data.split('\n');
    
    // Count lines that are not empty, not made up of whitespace, and do not start with '#'
    const validLines = lines.filter(line => line.trim() !== '' && !line.trim().startsWith('#'));
    
    return validLines.length;
  } catch (error) {
    throw new Error(`Error reading file: ${error.message}`);
  }
}

// Write your Quaternion class here
export class Quaternion {
  constructor(a, b, c, d) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    Object.freeze(this);
  }

  plus(other) {
    return new Quaternion(
      this.a + other.a,
      this.b + other.b,
      this.c + other.c,
      this.d + other.d
    );
  }

  times(other) {
    return new Quaternion(
      this.a * other.a - this.b * other.b - this.c * other.c - this.d * other.d,
      this.a * other.b + this.b * other.a + this.c * other.d - this.d * other.c,
      this.a * other.c - this.b * other.d + this.c * other.a + this.d * other.b,
      this.a * other.d + this.b * other.c - this.c * other.b + this.d * other.a
    );
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d];
  }

  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  equals(other) {
    return this.a === other.a && this.b === other.b && this.c === other.c && this.d === other.d;
  }

  toString() {
    const terms = [];

    if (this.a !== 0 || (this.b === 0 && this.c === 0 && this.d === 0)) {
      terms.push(this.a.toString());
    }

    if (this.b !== 0) {
      terms.push((this.b === 1 ? '' : this.b === -1 ? '-' : this.b) + 'i');
    }

    if (this.c !== 0) {
      terms.push((terms.length > 0 ? (this.c > 0 ? '+' : '') : '') + (this.c === 1 ? '' : this.c === -1 ? '-' : this.c) + 'j');
    }

    if (this.d !== 0) {
      terms.push((terms.length > 0 ? (this.d > 0 ? '+' : '') : '') + (this.d === 1 ? '' : this.d === -1 ? '-' : this.d) + 'k');
    }

    return terms.join('');
  }
}

