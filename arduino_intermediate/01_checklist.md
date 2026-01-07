# What we will create with code

We will use Arduino "sketches" to program the Uno R4 Minima board.
The sketch API relies on two entrypoints, `setup` and `loop`.

1. The `setup` function is called first when the program is executed.
2. _After_ `setup` is called, the `loop` function is called repeatedly.

[docs.arduino.cc](https://docs.arduino.cc/language-reference/#structure) has more information about both functions.

Therefore, the two code examples below are the same.


<table>
<tr>
<td> Arduino Sketch </td> <td> Typical C program </td>
</tr>
<tr>
<td>

```c
int main()
{
  setup();
  while (1) {
    loop();
  }
}
```

</td>
<td>

```c
void setup()
{

}

void loop()
{

}
```

</td>
</tr>
</table>

