# 16-bit Unsigned Non-Restoring Division

This branch contains an implementation of a **16-bit unsigned non-restoring division algorithm** written for **ARM cortex-M4 assembly** microcontrollers.

The routine performs division using the classical **non-restoring algorithm** with a fixed **16-iteration** loop.
It returns both **quotient** and **remainder** without using hardware division instructions.

## Algorithm Summary

The non-restoring division algorithm operates by:

1. Maintaining an **accumulator A**.
2. Repeating **16 left-shift iteration cycles**.
3. Conditionally adding or subtracting the divisor based on the sign of `A`.
4. Setting quotient bits during each iteration.
5. Applying a final correction if the accumulator is negative.

This method avoids restoring previous states, improving performance in hardware-limited environments.

## Function Prototype

```
udiv16_nonrestoring
```

### **Input**

| Register | Meaning      | Range     |
| -------- | ------------ | --------- |
| `R0`     | Dividend (Q) | 0 … 65535 |
| `R1`     | Divisor (M)  | 0 … 65535 |

### **Output**

| Register | Meaning            |
| -------- | ------------------ |
| `R0`     | Quotient (16-bit)  |
| `R1`     | Remainder (16-bit) |

## Division by Zero Handling

If `R1 = 0`:

* Quotient = `0xFFFF`
* Remainder = original dividend

## 📂 Code Overview

### Key Registers Used

| Register | Purpose                      |
| -------- | ---------------------------- |
| `R2`     | Accumulator (A), signed      |
| `R3`     | Loop counter (16 iterations) |
| `R4`     | Temporary for MSB extraction |

### Main Steps in Code

* Shift accumulator left
* Bring in MSB of dividend into accumulator
* Shift dividend (quotient register) left
* Add or subtract divisor based on accumulator sign
* Set or skip setting LSB of quotient
* Correct remainder if accumulator is negative

## Example Usage

```asm
        LDR     R0, =17   ; dividend
        LDR     R1, =3    ; divisor
        BL      udiv16_nonrestoring

        ; R0 = quotient = 5
        ; R1 = remainder = 2
```