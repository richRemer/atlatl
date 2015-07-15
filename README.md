@lang Programming Language
==========================
This is all just spewed ideas and nonsense.  I have since decided on a
bottom-up approach, so much of this is poorly organized notes on old ideas.

Work is now progressing on a minimal compiler written in AMD64 assembly.  To
build, `cd` into the `atlatl` directory and run `make`.  This will create a
binary called `atlatl` in the same directory.

**Example**
```sh
git clone git@github.com:richRemer/atlatl.git
cd atlatl/atlatl
make
./atlatl
```

Unit tests can be run from the test directory.

**Running tests**
```sh
cd atlatl/test
./test.sh
```

**"Compiling" with atlatl**

Using the word "compile" when referring to the current development version is
mildly ridiculous.  But when the day comes when the word "compile" applies to
what this thing does, it will be used like so:

```sh
atlatl foo.atl
nasm -f elf64 foo.S
ld foo.o -o foo
./foo
```

Source Files
------------
Source filenames should be lowercase and use the **.atl** extension, and the
files must be UTF-8 encoded.  Each source file defines a module.

Modules
-------
Each source file defines a module.  Each module has its own scope.  Within the
module, symbols can be defined, including constants, variables, functions, and
types.  Modules have no direct access to symbols defined within the scopes of
other modules, but can provide access using **@-variables**, which are special
variables which each have their own rules about the scope within which they
apply.

**module.atl**
```
sym:pi = 3.14159        -- constant
num:radius: 5           -- number variable

-- distance function
fn:distance((num,num):p1, (num,num):p2 ; num):
    ret: ((p1.0-p2.0)^2 + (p1.1-p2.1)^2) ^(1/2)

-- Point data type
typ:Point:
    -- Point properties
    num: x, y
    
    -- Point.distance method
    fn:distance(Point:p ; num):
        ret: distance((@me.x, @me.y), (p.x, p.y))

-- export symbols from this module so other modules can see them
@export.pi = pi
@export.Point = Point
```

Scopes
------
The @lang language uses lexical scoping.  Each module has a root scope.  Each
block (type block, function block, etc.), defines a new scope, which has access
to its parent scope, and its parent scopes, and so on until reaching the root
module scope.  Symbols re-defined within a block shadow identically named
symbols defined in parent scopes.

**module.atl**
```
-- module scope
int:foo = 45
int:bar = 13

fn:find_things(int:foo ; str):
    -- function scope
    -- function argument "foo" hides parent scope "foo"
    
    -- function variable "bar" hides parent scope "bar"
    str:bar = "things"
    
    -- found things
    ret: bar

typ:Foo:    -- symbols are case sensitive, so Foo is OK here
    -- type scope
    num:foo     -- type property "foo" hides parent scope "foo"
    
    fn:handle_foo(num:foo ;):
        -- function argument "foo" hides type scope "foo"
        -- type scope "foo" is available with @me
        foo: @me.foo
```

Symbols
-------
Symbols are organized hierarchically within scopes.  With the exception of bare
symbols, all symbols have a value.  This value can be a simple scalar, a type, a
function, or even a bare symbol.

### Bare Symbols
Bare symbols are just a name with no value.  Another way to look at it is the
symbol has exactly one value, which is the symbol itself.  This symbol will
fail all tests and comparison, with the exception of testing equality against
itself.  Several language "keywords" are predefined bare symbols, including
`nil`, `true`, and `false`.

**bare-symbols.atl**
```
-- declare a bare symbol named "foo"
sym:foo
```

### Aliases
Aliases can be made to other symbols.  If an alias is made to a bare symbol,
there is no way to distinguish between the bare symbol and the alias.  The alias
if effectively also a bare symbol, which has an alias in the original symbol.
Aliases can be made to variables and the alias value will change when the
value of the variable changes.

Aliases are a type of **constant** (*q.v.*, below), but they act like whatever
they are aliasing, which may or may not be a constant.  All the rules of
constants still apply to aliases, but in code, the rules which apply to the
alias are actually applied by the aliased symbol and not the alias itself.

**aliases.atl**
```
-- alias yes/no to true/false
sym:yes = true
sym:no = false

num:variable: 0.0
sym:alias = variable    -- "alias" symbol refers to "variable" symbol

variable: 13.0          -- update "variable" to 13.0
alias: 42.0             -- update "variable" to 42.0
                        -- "alias" refers to "variable", which is 42.0
```

### Constants
Constants are symbols with a constant type and value defined at declaration.
Aliases are one kind of constant, whose type is alias and whose value is the
aliased symbol.  Constants are often set to the values of literal expressions or
expressions containing literals and other constants.  In these cases, the
constant will have an inferred type based on the type of expression.  When set
to objects, the constant will take the type of the object.

**constants.atl**
```
sym:pi = 3.14159        -- number constant
sym:SUCCESS = 0         -- integer constant
sym:name = "AppName"    -- string constant
sym:origin = Point(0,0) -- object constant

-- can also explicitly set constant type
num:value = 1           -- not integer 1, but number 1.0
```

### Variables
Variables are symbols with type and value.  The type cannot change, but the
value may.  All types have a default value which will be used to initialize the
variable if no value is provided at declaration.

**variables.atl**
```
num:length              -- number variable, initialized to 0.0
int:max_length: 10      -- integer variable, initialized to 10
str:name: "Étienne"     -- string variable, initialized to "Étienne"

(int,int):point         -- variable structure containing two integers

(int;str):callback      -- variable function with an integer argument
                        -- and a string result
```

### Functions
Functions are variable or constant symbols whose value is executable code.

```
-- function with no arguments and no return value
fn:noop(;):
    -- do nothing

-- same function as above, but without the syntactic sugar of the "fn" keyword
(;): noop:

-- function with no arguments and a string return value
fn:get_name(;str):
    ret: "Horatio"

-- function with integer argument and string return value
fn:generate_name(int:id ; str):
    ret: "Generated for" id

-- function with integer argument and two return values
fn:map_external(int:id ; str, int):
    sym:mapped_to = lookup(id)
    ret: mapped_to.code, mapped_to.id

-- function with any number of arguments (even 0) and no return value
fn:log(...;):
    write_log(@args)
```

### Custom Types
Custom types are classifications of data structures and associated behavior.

**point.atl**
```
typ:Point:
    sym:x(num)
    sym:y(num)

    fn:distance(Point:p;num):
        ret: ((@me.x-p.x)^2+(@me.y-p.y)^2)^(1/2)

@export.Point = Point
```

**circle.atl**
```
sym:Point = @import.point.Point

typ:Circle:
    sym:center(Point)
    sym:radius(num)
    
    fn:contains(Point p;flg):
        ret: @me.center.distance(p) <= @me.radius

@export.Circle = Circle
```

### Scalar Types
Scalar types hold a single value of known length.

#### Flag
```
flg:completed = false
flg:public = true
```

#### Integer
```
int:max = 100
int:min = -100
```

#### Number
```
num:pi = 3.14159
num:avogadro = 6.022e+23
```

#### Character
```
chr:newline = 10    -- Unicode code point for Line Feed
```

#### String
```
str:name = "Muhammad Li"
str:alternate = 'Alternate "quotes" can be nested'
str:escaped = "Quotes can be ""escaped"" by doubling them"
str:non_latin = "平仮名"
```

##### String Concatenation
The `@join` operator can be used to concatenate strings.  The *join* operator is
unique in that it is implicit when two values have no operator between them.

```
str:foo = "foo"
str:bar = "bar"
str:foo_bar = foo bar   -- "foobar"
str:line = "This ends with a newline" 10
```

### @-variables
The `@-variables` are read-only compiler variables which are available within
your code within the appropriate scope.

#### @add
The add operator.  Can be redefined on a custom type.

```
typ:Point(int:x, int:y):
    fn:@add(Point:p;Point):
        ret:Point(@me.x + p.x, @me.y + p.y)
```

#### @asm
Provides architecture dependent access to registers, *et al*; `@asm` is
available in all scopes.

##### @asm.REG
Refers to a platform dependent CPU register.  The acceptable values of REG which
are available vary for each platform.  A few examples from the x86_64 platform
include `@asm.rax`, `@asm.bx`, and `@asm.xmm0`, which correspond to the RAX, BX,
and XMM0 registers, respectively.

*Example*
```
-- imperative definition for close system call using Linux 64-bit ABI
fn:close(int:fd; int):
    -- ABI says call number in RAX, arg in RDI, return in RAX
    @asm.rax: 3     -- close
    @asm.rdi: fd    -- file descriptor to close
    asm:syscall     -- execute syscall instruction
    ret: @asm.rax   -- return value in RAX register
```

##### @asm.in.REG
Like `@asm.REG`, this refers to a platform register.  This is meant
to be used as a pre-condition for an `asm` block.

*Example*
```
-- declarative definition for close system call using Linux 64-bit ABI
fn:close(int:fd; int):
    -- ABI says call number in RAX, arg in RDI, return in RAX
    @asm.in.rax = 3     -- close
    @asm.in.rdi = fd    -- file descriptor to close
    asm:syscall
    ret: @asm.rax
```

 * **@export** - module exports; only available in top-level module scope
 * **@import** - filesystem module import; only available in top-level module
    scope
 * **@package** - package information; available in all scopes

Calling Convention
------------------
For this early stage, the calling convention is as follows:
 * no more than 14 arguments
 * no more than 14 return values
 * arguments in RAX, RBX, RCX, RDX, RSI, RDI, R8-R15
 * return values in RAX, RBX, RCX, RDX, RSI, RDI, R8-R15
 * preserve registers not mentioned in formal params
 * RSP preserved for call/ret use
 * RBP preserved for future use
   * number of args
   * error status

Language Organization
---------------------
 * system primitives
   * bit
   * byte
   * dbyte
   * qbyte
   * obyte
   * hbyte
 * simple types
   * number
   * integer
   * character
   * flag
   * ref
 * vector types
   * stream
   * array (known size)

 * string[3]
   * string.bytes.0 tells us length of first character (say 2)
   * string.bytes.2 tells us length of second character (say 3)
   * string.bytes.5 tells us length of third character (say 1)
   * string.bytes.6 tells us length of string[3] and result
   * cached structure
     * every 4096 characters, cache a byte marker

Open Questions
--------------
#### Functions vs. Procedures
**function**
```
fn:square(int:n): n*n

fn:format_flag(flg:x):
    ret: "yes" ? x
    ret: "no"

fn:fib(0): 0
fn:fib(1): 1
fn:fib(int:n|n>1): fib(n-1) + fib(n-2)
```

**procedure**
```
proc:

-- download files and upload them to client servers

```

#### String literals
**strings**
```
str:double_quoted = "string value"
str:single_quoted = 'string value'
str:alternate_quote = 'string "value"'  -- use alternate quotes to avoid escape

-- escape quotes using second quote character
str:double_escaped = "string ""value"""  -- string "value"
str:single_escaped = 'it is Mike''s problem now'

-- other characters can be joined using Unicode code points
str:null_terminated = "C-style string" 0
str:windows_endln = "text line" 13 10
str:unix_endln = "text line" 10
```

#### Number literals
**numbers**
```
int:a = 13          -- integer literal
int:b = -13         -- negative integer literal

num:c = 1.0         -- number literal
num:d = 1.7e15      -- scientific notation (large numbers)
num:e = 2.3e-6      -- scientific notation (small numbers)


sym:foo = 13        -- implicitly assigned integer type
sym:foo = 13.0      -- 
```

#### Conditionals?
**conditional statement**
```
do_stuff() ? condition      -- only do stuff if condition is true
```

#### Short-circuit expressions?
```
-- foo if foo is not false; if true, bar if bar is not false; if true, baz
ret: foo | bar | baz

-- distinct from type union
int|str: flexible_value
```

#### How are functions defined/called/passed?
**define a function**
```
-- calculate the nth fibonacci number
fn:fib: 0 ; 0
fn:fib: 1 ; 1
fn:fib: int:n|n>1 ; int:
    -- call fib recursively
    fib n-2 + fib n-1
```

```
-- calculate the nth fibonacci number
fn:fib(0) => 0
fn:fib(1) => 1
fn:fib(int:n ; int):
    fib(n-2) + fib(n-1)
```

#### How are anonymous functions expressed?
**example anonymous function**
```
on("foo", fn(int;int))


```

#### Are pure functions defined any differently?

#### What exactly is "@" for?
**inline package imports**
```
-- calculate the sin of pi
num: pi = @math.pi
num: sin_pi = @math.sin (pi)
```

### What operators are available?
**arithmetic operators**
```
2 + 3 = 5   -- addition
5 - 2 = 3   -- subtraction
2 * 3 = 6   -- multiplication
6 / 2 = 3   -- division
2 ^ 3 = 8   -- exponentiation
```

**list/set/array/whatever operators**
```
int[]: nums: [1,2,3,4,5]

-- display numbers in no particular order
print: nums@
```
