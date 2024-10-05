import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import kotlin.math.abs


fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

fun firstThenLowerCase(strings: List<String>, predicate: (String) -> Boolean): String? {
    return strings.firstOrNull(predicate)?.lowercase()
}

data class Say(val phrase: String) {
    fun and(nextPhrase: String): Say {
        return Say("$phrase $nextPhrase")
    }
}
fun say(phrase: String = ""): Say {
    return Say(phrase)
}

@Throws(IOException::class)
fun meaningfulLineCount(filename: String): Long {
    BufferedReader(FileReader(filename)).use { reader ->
        return reader.lineSequence()
            .map { it.trim() }
            .filter { it.isNotEmpty() && it[0] != '#' }
            .count().toLong()
    }
}

data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {

    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }
    
    operator fun plus(other: Quaternion) = Quaternion(a + other.a, b + other.b, c + other.c, d + other.d)

    operator fun times(other: Quaternion) = Quaternion(
        a * other.a - b * other.b - c * other.c - d * other.d,
        a * other.b + b * other.a + c * other.d - d * other.c,
        a * other.c - b * other.d + c * other.a + d * other.b,
        a * other.d + b * other.c - c * other.b + d * other.a
    )

    fun coefficients(): List<Double> = listOf(a, b, c, d)

    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)


    override fun toString(): String {
        val parts = listOfNotNull(
            if (a != 0.0) "$a" else null,
            if (b != 0.0) "${if (a != 0.0 && b > 0) "+" else if (b < 0) "-" else ""}${if (abs(b) != 1.0) abs(b) else ""}i" else null,
            if (c != 0.0) "${if ((a != 0.0 || b != 0.0) && c > 0) "+" else if (c < 0) "-" else ""}${if (abs(c) != 1.0) abs(c) else ""}j" else null,
            if (d != 0.0) "${if ((a != 0.0 || b != 0.0 || c != 0.0) && d > 0) "+" else if (d < 0) "-" else ""}${if (abs(d) != 1.0) abs(d) else ""}k" else null
        )
    
        return if (parts.isEmpty()) "0" else parts.joinToString("")
    }
}

sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(value: String): Boolean
    fun insert(value: String): BinarySearchTree

    object Empty : BinarySearchTree {
        override fun size(): Int = 0
        override fun insert(value: String): BinarySearchTree = Node(value)
        override fun contains(value: String): Boolean = false
        override fun toString(): String = "()"
    }

    data class Node(
        private val value: String,
        private val left: BinarySearchTree = Empty,
        private val right: BinarySearchTree = Empty
    ) : BinarySearchTree {
        override fun size(): Int = 1 + left.size() + right.size()
        override fun insert(value: String): BinarySearchTree = when {
            value < this.value -> this.copy(left = left.insert(value))
            value > this.value -> this.copy(right = right.insert(value))
            else -> this
        }
        override fun contains(value: String): Boolean = when {
            value < this.value -> left.contains(value)
            value > this.value -> right.contains(value)
            else -> true
        }
        override fun toString(): String {
            val leftStr = if (left is Node) left.toString() else ""
            val rightStr = if (right is Node) right.toString() else ""
            return "($leftStr$value$rightStr)"
        }
    }
}
