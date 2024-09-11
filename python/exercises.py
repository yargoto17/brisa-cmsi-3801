from dataclasses import dataclass
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


# Write your first then lower case function here
def first_then_lower_case(list, predicate):
    for element in list:
        if predicate(element):
            return element.lower()
    return None

# Write your powers generator here
def powers_generator(*, base, limit):
    power = 0
    while base ** power <= limit:
        yield base ** power
        power += 1

# Write your say function here
def say(word=None):
    if not hasattr(say, "words"):
        say.words = []
    
    if word is not None:
        say.words.append(word)
        return say  # Return the function itself to allow chaining
    else:
        #return the collected words
        result = " ".join(say.words)
        say.words = []  # Reset
        return result

# Write your line count function here
def meaningful_line_count(filename):
    # Open the file in read mode
    with open(filename, 'r') as file:
        # Read all lines
        lines = file.readlines()

    valid_lines = 0

    for line in lines:
        # Strip leading/trailing whitespaces
        stripped_line = line.strip()

        # Check if the line is not empty, not made up of whitespaces, and does not start with '#'
        if stripped_line and not stripped_line.startswith('#'):
            valid_lines += 1

    return valid_lines

# Write your Quaternion class here
@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    def __add__(self, other):
        return Quaternion(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)

    def __mul__(self, other):
        return Quaternion(
            self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d,
            self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c,
            self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b,
            self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
        )

    def __eq__(self, other):
        return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d

    @property
    def coefficients(self):
        return self.a, self.b, self.c, self.d

    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __str__(self):
        components = []
        if self.a != 0:
            components.append(f"{self.a}")
        if self.b != 0:
            components.append(f"{'+' if self.b > 0 else ''}{self.b if abs(self.b) != 1 else '-' if self.b == -1 else ''}i")
        if self.c != 0:
            components.append(f"{'+' if self.c > 0 else ''}{self.c if abs(self.c) != 1 else '-' if self.c == -1 else ''}j")
        if self.d != 0:
            components.append(f"{'+' if self.d > 0 else ''}{self.d if abs(self.d) != 1 else '-' if self.d == -1 else ''}k")

        result = ''.join(components)

        if result.startswith('+'):
            result = result[1:]
        return result if result else '0'