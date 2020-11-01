---
layout: post
title:  "Go Fibonacci Go"
date:   2020-10-30 9:33:52 +0200
categories: articles
---

Happy all saints eve everybody. Having had the time to delve into topics not related to the Ruby ecosystem I decided to give Golang a Go.

One of the first problems to tackle was the famous recurrence example known to every person that has ever had the pleasure of somebody introducing recurrence to them.

## Implementation

Below is a simple implementation of Fibonacci's sequence in Go using recurrence. The implementation tackles the problem explicitly and invokes itself with different parameters to obtain all of its predecessing elements. Each invocation with param `x` greater than 2 causes additional two methods to be pushed onto the execution stack one level deeper.

```go
func fibo(x int) int {
	switch {
	case x < 0:
		log.Fatal("Fibonacci can be called only for positive integers")
		return 0
	case x == 0:
		return 0
	case x == 1:
		return 1
	default:
		return fibo(x-1) + fibo(x-2)
	}
}
```
_In Go the switch can be invoked with multiple logical conditions instead of plain values which simplifies the code_

The number of the invoked methods for the value of `x` could be mapped as follows and described as a rule N(x) = N(x-1) + N(x-2) + 1. 

N(0) = 1
N(1) = 1
N(2) = 3
N(3) = 5
N(4) = 9

This impliies that the depth of the stack would grow one level with a single increase of x. This would result in execution stack overflow in languages such as Python. In language such as Go there is no such limit in place, however if the program requires a deeper execution stack it just requests more memory and processing power to handle it. This would have catastrophic consequences to the programs memory and processing power usage should the recurrence be abused.

There are however solutions to the Fibonacci sequence that do not require recurrence.

## Alternative approaches

### Plain linear solution

Plain linear solution starts at the beginning of the sequence and plainly adds its way into the requested position of the Fibbonaci sequence. Its computational complexity is linear

```go
func fibo2(x int) int {
	a := 0
	b := 1
	switch {
	case x < 0:
		log.Fatal("Fibonacci can be called only for positive integers")
		return 0
	case x == 0:
		return a
	case x == 1:
		return b
	default:
		for i := 2; i < x+1; i++ {
			b = a + b
			a = b - a
		}
		return b
	}
}
```


### Numerical solution

There is also a method for determining the number at Nth position of the Fibonacci sequence developed originally by French mathematician Jacques Philippe Marie Binet. 

The details for derivation and proof of the formula can be found [here](https://artofproblemsolving.com/wiki/index.php/Binet%27s_Formula)

The computational complexity of the formula is as good as the one of the pow function.


```go
func fibo3(x int) int {
	if x < 0 {
		log.Fatal("Fibonacci can be called only for positive integers")
	}
	sqrt := math.Sqrt(5)
	p := (1 + sqrt) / 2.0

	return int(math.RoundToEven((math.Pow(p, float64(x))) / sqrt))
}
```

*The followning gist contains the full code used for this example:*<br />
[Gist](https://gist.github.com/TarasJan/283818d40922df9ae350cf4bb858b81c)

I have decied to measure the timing of each calculation with a separate goroutine to keep the calculations separated. In the example I have decided to limit the calculations to the 44th element in the Fibonacci series. The results of the calculations have been dumped throught the common channel to an JSON file and then to matplotlib.

The resulting graph of time for computation of `x` for separate methods looks as follows:
<img src="/jantar-theme/assets/img/computation.png" alt="Post Image">

The CPU and thread number utilized corresponds to the time based results:
<img src="/jantar-theme/assets/img/proc_usage_fibonacci.png" alt="Post Image">

As it can be derived from the graphs, the usage of recurrence may seem as harmless up to a certain point - however once the execution stack reaches certain depth and width the additional resources it requires put a drastic strain on the whole system. I would advise to be wary of overrelying on the recurrence based solutions especially when the performance is the key concern, and always double chcecking the common approaches you are presented with for tackling a given problems.

If you have any better solutions for the problem above or would like to point out a better way to implement an existing one please let me know.

Many Thanks for reading.





