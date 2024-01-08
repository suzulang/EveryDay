# JavaScript函数式编程大入门

函数式编程，这个思想太有意思了。

如果说java中最重要的是，万物皆对象。那么JavaScript中就是万物皆函数，don't repeat yourself

一个计算器，作为人的思考。就是计算数+被计算数=结果

如果不用函数式编程，感觉很傻，比如下面的这个代码

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Calculator</title>
</head>
<body>
    a : <input type="text" id="a" value=""><br>
    b : <input type="text" id="b" value=""><br>
    操作符 :
    <select id="op">
        <option value="sum">+</option>
        <option value="sub">-</option>
        <option value="div">/</option>
        <option value="multiply">*</option>
    </select>
    <br>
    <button onclick="performCalculation()">计算</button>
    <p>结果: <span id="result"></span></p>

<script>
    function performCalculation() {
        var a = parseFloat(document.getElementById('a').value);
        var b = parseFloat(document.getElementById('b').value);
        var op = document.getElementById('op').value;

        var result;
        switch (op) {
            case 'sum':
                result = sum(a, b);
                break;
            case 'sub':
                result = sub(a, b);
                break;
            case 'div':
                result = div(a, b);
                break;
            case 'multiply':
                result = multiply(a, b);
                break;
        }

        document.getElementById('result').textContent = result;
    }

    function sum(a, b) {
        return a + b;
    }
    function sub(a, b) {
        return a - b;
    }
    function div(a, b) {
        if (b === 0) {
            return '无法除以零';
        }
        return a / b;
    }
    function multiply(a, b) {
        return a * b;
    }
</script>
</body>
</html>

```

因为这太计算机思维了，就是一步一步来。

1. 定义a,b,op,result
2. 根据op的值，来操作a,b输出result

那么这个时候我如果说，需要写一个新的操作符，比如说 $，我定义它的作用是

a$b=a*b+10。

怎么写代码来实现呢？

1. 给选择框加一个选项
2. 在js代码里，给swtich加一条case
3. 编写new_op函数

下面是实现代码：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Calculator</title>
</head>
<body>
    a : <input type="text" id="a" value=""><br>
    b : <input type="text" id="b" value=""><br>
    操作符 :
    <select id="op">
        <option value="sum">+</option>
        <option value="sub">-</option>
        <option value="div">/</option>
        <option value="multiply">*</option>
      	<option value="new_op">$</option>
    </select>
    <br>
    <button onclick="performCalculation()">计算</button>
    <p>结果: <span id="result"></span></p>

<script>
    function performCalculation() {
        var a = parseFloat(document.getElementById('a').value);
        var b = parseFloat(document.getElementById('b').value);
        var op = document.getElementById('op').value;

        var result;
        switch (op) {
            case 'sum':
                result = sum(a, b);
                break;
            case 'sub':
                result = sub(a, b);
                break;
            case 'div':
                result = div(a, b);
                break;
            case 'multiply':
                result = multiply(a, b);
                break;
          	case 'new_op':
            		result = new_op(a, b);
            		break;
        }

        document.getElementById('result').textContent = result;
    }

    function sum(a, b) {
        return a + b;
    }
    function sub(a, b) {
        return a - b;
    }
    function div(a, b) {
        if (b === 0) {
            return '无法除以零';
        }
        return a / b;
    }
    function multiply(a, b) {
        return a * b;
    }
  	function new_op(a, b) {
      	return a * b + 10;
    }
</script>
</body>
</html>
```

`那么我现在来思考一下，这么写不就加了几行代码吗？为什么一定要用函数式编程？好的，现在我们以函数式编程的思维，来从头复盘一下这个过程。`

1. 用函数式编程先实现最基础的加减乘除

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <title>Document</title>
   </head>
   <body>
       a : <input type="text" id="a" value=""><br>
       b : <input type="text" id="b" value=""><br>
       操作符 : 
       <select id="op">
           <option value="sum">+</option>
           <option value="sub">-</option>
           <option value="div">/</option>
           <option value="multiply">*</option>
       </select>
       <br>
       <button onclick="calculate()">计算</button>
       <p>结果: <span id="result"></span></p>
   
   <script>
       function calculate() {
           const a = parseFloat(document.getElementById('a').value);
           const b = parseFloat(document.getElementById('b').value);
           const op = document.getElementById('op').value;
   
           let operation;
           switch (op) {
               case 'sum': operation = sum; break;
               case 'sub': operation = sub; break;
               case 'div': operation = div; break;
               case 'multiply': operation = multiply; break;
               default: operation = () => '无效操作';
           }
   
           const result = calculator(a, b, operation);
           document.getElementById('result').textContent = result;
       }
   
       function calculator(a, b, op) {
           return op(a, b);
       }    
       function sum(a, b) {
           return a + b;
       }
       function sub(a, b) {
           return a - b;
       }
       function div(a, b) {
           if (b === 0) return '无法除以零';
           return a / b;
       }
       function multiply(a, b) {
           return a * b;
       }
   </script>
   </body>
   </html>
   
   ```

   2. 在这个代码的基础上，添加一个操作符$实现a$b=a*b+10

      ```html
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Document</title>
      </head>
      <body>
          a : <input type="text" id="a" value=""><br>
          b : <input type="text" id="b" value=""><br>
          操作符 : 
          <select id="op">
              <option value="sum">+</option>
              <option value="sub">-</option>
              <option value="div">/</option>
              <option value="multiply">*</option>
              <option value="new_op">$</option>
      
          </select>
          <br>
          <button onclick="calculate()">计算</button>
          <p>结果: <span id="result"></span></p>
      
      <script>
          function calculate() {
              const a = parseFloat(document.getElementById('a').value);
              const b = parseFloat(document.getElementById('b').value);
              const op = document.getElementById('op').value;
      
              let operation;
              switch (op) {
                  case 'sum': operation = sum; break;
                  case 'sub': operation = sub; break;
                  case 'div': operation = div; break;
                  case 'multiply': operation = multiply; break;
                  case 'new_op': operation = new_op; break;
                  default: operation = () => '无效操作';
              }
      
              const result = calculator(a, b, operation);
              document.getElementById('result').textContent = result;
          }
      
          function calculator(a, b, op) {
              return op(a, b);
          }    
          function sum(a, b) {
              return a + b;
          }
          function sub(a, b) {
              return a - b;
          }
          function div(a, b) {
              if (b === 0) return '无法除以零';
              return a / b;
          }
          function multiply(a, b) {
              return a * b;
          }
          function new_op(a, b) {
              return a * b + 10;
          }
      </script>
      </body>
      </html>
      
      ```

      让我们来看看我做了什么

      1. 给选择框，添加一条选项，这里和上面没什么区别
      2. 添加一条匹配的case
      3. 编写函数new_op

   `乍一看，好像函数式编程也没解决什么问题吗，代码量还是一样的。但是重点是，函数式编程，不是规范，你不这么写编辑器就报错。或者说，某个功能，必须要用函数式编程才能解决。就如同设计模式一样，它不是规范，而是一种思想。`

   用函数式编程的思想来写代码，有一个最大的好处就是，它更符合人类变成的思维。我们来看这一句`        const result = calculator(a, b, operation);`

   如果说你不太懂JavaScript，你也可以猜一下这个代码的意思。第一反应可能是：有一个函数calculator，接受3个参数a,b,operation。然后第二个反应是a,b可能是变量,c可能是操作符。

   如果说用一般的传统思维进行编程，我们来看这个代码`        document.getElementById('result').textContent = result;`        

   不要想太多，抓住你的第一反应。你的第一反应可能是，给html中的result变量赋值为result。第二个反应是，我必须要去看一下代码，这个result是什么东西？

   所以这个时候对比一下，可以看出来差距，你脑海里根据不同的编程思想写出来的代码，给别人看的时候。

   函数式编程思想写出来的代码：我不看具体实现代码，也大概能猜出来关键语句代码的作用

   传统编程思想写出来的代码：我看到关键语句后，必须要去看具体代码的实现是怎么样的

   `结论`：所以说，为什么前段的开源社区更活跃，我觉得是因为这是底层的思维就决定了，必然会发生这种结果。看别人的JavaScript的代码，我看关键语句，能猜出来个大概的意思。但是如果是看Java的代码，或者类似不用函数式编程写出来的代码，我必须要深入到源码里面去仔细的看细节。
