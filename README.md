# Emergency
自学swift，写的一款项目。
这篇文章是自己学习Swift的笔记与深化。希望这篇文章能够帮助已经有Objective-C经验的开发者更快地学习Swift。同时也品味到Swift的精妙之处。
结论放在开头:
我认为Swift比Objective-C更优雅,更安全同时也更现代,更性感。
文章组织脉络：
从Objective-C到Swift的语法差异。我们熟悉的Objective-C特性在Swift中如何展现。
从Objective-C到Swift的进步改进。研究对比Swift在安全性,易用性上的提升,给我们带来的新编程范式。

目录：
1.属性(property)和实例变量(instance variable)
2.控制流
3.函数
4.类与初始化(Initializers)
5.枚举与结构体
6.协议(Protocols)
7.Swift与Cocoa
8.总结

1.属性(property)和实例变量(instance variable)
Objective-C property in Swift world
在Cocoa世界开发的过程中,我们最常打交道的是property.
典型的声明为:

@property (strong,nonatomic) NSString *string;
而在Swift当中,摆脱了C的包袱后,变得更为精炼,我们只需直接在类中声明即可

class Shape { var name = "shape"}
注意到这里,我们不再需要@property
指令,而在Objective-C中,我们可以指定property的attribute,例如strong,weak,readonly等。
而在Swift的世界中,我们通过其他方式来声明这些property的性质。
需要注意的几点:
strong
: 在Swift中是默认的
weak
: 通过weak关键词申明

weak var delegate: UITextFieldDelegate?
readonly ,readwrie
直接通过声明常量let
,声明变量var
的方式来指明

copy
通过@NSCopying
指令声明。
值得注意的是String,Array和Dictionary在Swift是以值类型(value type)而不是引用类型(reference type)出现,因此它们在赋值,初始化,参数传递中都是以拷贝的方式进行（简单来说,String,Array,Dictionary在Swift中是通过struct
实现的）
延伸阅读：Value and Reference Types

nonatomic
,atomic
所有的Swift properties 都是nonatomic。但是我们在线程安全上已经有许多机制,例如NSLock,GCD相关API等。个人推测原因是苹果想把这一个本来就用的很少的特性去掉,线程安全方面交给平时我们用的更多的机制去处理。

然后值得注意的是,在Objective-C中,我们可以跨过property直接与instance variable打交道,而在Swift是不可以的。
例如：我们可以不需要将someString声明为property,直接使用即可。即使我们将otherString声明为property,我们也可以直接用_otherString来使用property背后的实例变量。

@interface SomeClass : NSObject { NSString *someString;}@property(nonatomic, copy) NSString* otherString;
而在Swift中,我们不能直接与instance variable打交道。也就是我们声明的方式简化为简单的一种,简单来说在Swift中,我们只与property打交道。
A Swift property does not have a corresponding instance variable, and the backing store for a property is not accessed directly


小结
因此之前使用OC导致的像巧哥指出的开发争议就不再需要争执了,在Swift的世界里,我们只与property打交道。

并且我们在OC中init
和dealloc
不能使用属性self.property = XXX
来进行设置的情况得以解决和统一。

(不知道这一条规定,在init直接用self.property = value 的同学请自觉阅读iOS夯实：内存管理)
：）
个人觉得这看似小小一点变动使Swift开发变得更加安全以及在代码的风格更为统一与稳定。

Swift property延伸：
Stored Properties
和Computed properties

在Swift中,property被分为两类：Stored Properties
和Computed properties
简单来说,就是stored properties 能够保存值,而computed properties只提供getter与setter,利用stored properties来生成自己的值。个人感觉Computed properties更像方法,而不是传统意义的属性。但是这样一个特性存在,使得我们更容易组织我们的代码。
延伸阅读：computed property vs function
Type Properties

Swift提供了语言级别定义类变量的方法。
In C and Objective-C, you define static constants and variables associated with a type as global static variables.In Swift, however, type properties are written as part of the type’s definition, within the type’s outer curly braces, and each type property is explicitly scoped to the type it supports.

在Objective-C中,我们只能通过单例,或者static变量加类方法来自己构造类变量：

@interface Model
+ (int) value;
+ (void) setValue:(int)val;
@end
@implementation Modelstatic 
int value;
+ (int) value{ 
@synchronized(self) 
{ 
return value; 
} 
}
+ (void) setValue:(int)val{ 
@synchronized(self) { 
value = val; 
} 
}
@end
// Foo.h@interface Foo {}
+(NSDictionary*) dictionary;
// Foo.m
+(NSDictionary*) dictionary{ 
static NSDictionary* fooDict = nil; 
static dispatch_once_t oncePredicate; 
dispatch_once(&oncePredicate, ^{ 
// create dict 
}); 
return fooDict;
}
而在Swift中我们通过清晰的语法便能定义类变量：
通过static定义的类变量无法在子类重写,通过class定义的类变量则可在子类重写。

struct SomeStructure { 
static var storedTypeProperty = "Some value." 
static var computedTypeProperty: Int { 
return 1 
} 
class var overrideableComputedTypeProperty: Int { 
return 107 
}
}
同时利用类变量我们也有了更优雅的单例模式实现：

class singletonClass { 
static let sharedInstance = singletonClass() 
private init() {}
// 这就阻止其他对象使用这个类的默认的'()'初始化方法}

Swift单例模式探索：The Right Way to Write a Singleton
延伸：

目前Swift支持的type propertis中的Stored Properties
类型不是传统意义上的类变量(class variable)，暂时不能通过class 关键词定义,通过static定义的类变量类似java中的类变量,是无法被继承的,父类与子类的类变量指向的都是同一个静态变量。
延伸阅读： Class variables not yet supported

class SomeStructure { 
class var storedTypeProperty = "Some value."
}
//Swift 2.0 Error: Class stored properties not yet supported in classes
通过编译器抛出的错误信息,相信在未来的版本中会完善Type properties
。

2.控制流
Swift与Objective-C在控制流的语法上关键词基本是一致的,但是扩展性和安全性得到了很大的提升。
主要有三种类型的语句
if,switch和新增的guard
for,while
break,continue

主要差异有：

关于if
语句里的条件不再需要使用()
包裹了。

let number = 23if number < 10 { print("The number is small")}
但是后面判断执行的的代码必须使用{}
包裹住。
为什么呢,在C,C++等语言中,如果后面执行的语句只有语句,我们可以写成:

int number = 23 if (number < 10) NSLog("The number is small")
但是如果有时要在后面添加新的语句,忘记添加{}
,灾难就很可能发送。
：） 像苹果公司自己就犯过这样的错误。下面这段代码就是著名的goto fail错误,导致了严重的安全性问题。

if ((err = SSLHashSHA1.update(&hashCtx, &signedParams)) != 0) goto fail; goto fail; // :)注意 这不是Python的缩减 ... other checks ... fail: ... buffer frees (cleanups) ... return err;

：）
最终在Swift,苹果终于在根源上消除了可能导致这种错误的可能性。
if 后面的条件必须为Boolean表达式
也就是不会隐式地与0进行比较,下面这种写法是错误的,因为number并不是一个boolean表达式,number != 0才是。
int number = 0if number{}


关于for
for循环在Swift中变得更方便,更强大。
得益于Swift新添加的范围操作符...
与...<

我们能够将之前繁琐的for循环：

for (int i = 1; i <= 5; i++){ 
NSLog(@"%d", i);
}
改写为：

for index in 1...5 { 
print(index)
}
当然,熟悉Python的亲们知道Python的range函数很方便,我们还能自由选择步长。像这样：

range(1,5) #代表从1到5(不包含5)[1, 2, 3, 4]>>> range(1,5,2) #代表从1到5，间隔2(不包含5)[1, 3]
虽然在《The Swift Programming Language》里面没有提到类似的用法,但是在Swift中我们也有优雅的方法办到。

for index in stride(from: 1, through: 5, by: 2) { print(index)}
// through是包括5

然后对字典的遍历也增强了.在Objective-c的快速枚举中我们只能对字典的键进行枚举。

NSString *key;for (key in someDictionary){ 
NSLog(@"Key: %@, Value %@", key, [someDictionary objectForKey: key]);
}
而在Swift中,通过tuple我们可以同时枚举key与value:

let dictionary = ["firstName":"Mango","lastName":"Fang"]for (key,value) in dictionary{ print(key+" "+value)}
`

关于Switch
Swich在Swift中也得到了功能的增强与安全性的提高。
不需要Break来终止往下一个Case执行
也就是下面这两种写法是等价的。

let character = "a"
switch character{ 
case "a": print("A") 
break 
case "b": print("B") 
break
default: print("character")
let character = "a"
switch character{ 
case "a": print("A") 
case "b": print("B")
default: print("character")
这种改进避免了忘记写break造成的错误,自己深有体会,曾经就是因为漏写了break而花了一段时间去debug。
如果我们想不同值统一处理,使用逗号将值隔开即可。
switch some value to consider {case value 1,value 2: statements}

Switch支持的类型
在OC中,Swtich只支持int类型,char类型作为匹配。
而在Swift中,Switch支持的类型大大的拓宽了。实际上,苹果是这么说的。
A switch statement supports any kind of data

这意味在开发中我们能够能够对字符串,浮点数等进行匹配了。
之前在OC繁琐的写法就可以进行改进了:

if ([cardName isEqualToString:@"Six"]) { 
[self setValue:6];} 
else if ([cardName isEqualToString:@"Seven"]) { 
[self setValue:7];} 
else if ([cardName isEqualToString:@"Eight"]) { 
[self setValue:8];} 
else if ([cardName isEqualToString:@"Nine"]) { 
[self setValue:9];}
switch carName{ 
case "Six": self.vaule = 6 
case "Seven": self.vaule = 7 
case "Eight": self.vaule = 8 
case "Night": self.vaule = 9 
}

3.函数
对于在OC中,方法有两种类型,类方法与实例方法。方法的组成由方法名,参数,返回值组成。
在Swift中函数的定义基本与OC一样。
主要区别为：
通过func
关键词定义函数
返回值在->
关键词后标注

各举一个类方法与实例方法例子。

+ (UIColor*)blackColor- (void)addSubview:(UIView *)view
对应的swift版本

class func blackColor() -> UIColor //类方法,
通过 class func 关键词声明

func addSubview(view: UIView) //实例方法

改进：
在Swift中,函数的最重要的改进就是函数作为一等公民(first-class),和对象一样可以作为参数进行传递,可以作为返回值,函数式编程也成为了Swift支持的编程范式。

In computer science, a programming language is said to have first-class functions if it treats functions as first-class citizens. Specifically, this means the language supports passing functions as arguments to other functions, returning them as the values from other functions, and assigning them to variables or storing them in data structures

让我们初略感受一下函数式编程的魅力:
举一个例子,我们要筛选出一个数组里大于4的数字。
在OC中我们可能会用快速枚举来进行筛选。

NSArray *oldArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10]; 
NSMutableArray *newArray; 
for (NSNumber* number in oldArray) { 
if ([number compare:@4] == NSOrderedDescending ) { 
[newArray addObject:number]; 
} 
}
而在Swift中,我们用两行代码解决这个问题：

let oldArray = [1,2,3,4,5,6,7,8,9,10]
let newArray = oldArray.filter({$0 > 4})
进一步了解Swift的函数式编程可以通过这篇优秀的博客Functional Reactive Programming in Swift
个人觉得另外一个很棒的改进是：Default parameter values

在我们的项目中,经常会不断进行功能的增添。为了新增特性,许多方法在开发的过程中不断变动。举一个例子：我们开始有一个tableViewCell,它的设置方法一开始简单地需要一个Model参数：

func configureCellWithModel(Model: model)
不久之后,我们想对部分Cell增添一个设置背景颜色的功能。方法需要再接收多一个参数：

func configureCellWithModel(Model: model,color:UIColor)
这个时候方法改变,所以涉及到这些方法的地方都需要修改。给我们造成的困扰一是：需要做许多重复修改的工作。二是：无法做得很好的扩展和定制,有些地方的cell需要设置颜色,有些不需要。但是在OC里,我们只能对所有的cell都赋值。你可能觉得我们可以写两个方法,一个接收颜色参数,一个不接受。但是我们知道这不是一个很好的解决方法,会造成冗余的代码,维护起来也不方便。
而在Swift中,default parameter values
的引入让我们能够这样修改我们的代码：

func configureCellWithModel(Model: model,color:UIColor = UIColor.whiteColor())
这样的改进能让我们写出的代码更具向后兼容性,减少了我们的重复工作量,减少了犯错误的可能性。


4.类与初始化（Initializers）
文件结构与访问控制

在swift中,一个类不再分为interface
（.h）与implementation
(.m)两个文件实现,直接在一个.swift文件里进行处理。好处就是我们只需管理一份文件,以往两头奔波修改的情况就得到解放了,也减少了头文件与实现文件不同步导致的错误。
这时我们会想到,那么我们如何来定义私有方法与属性呢,在OC中我们通过在class extension
中定义私有属性,在.m文件定义私有方法。
而在Swift中,我们通过Access Control
来进行控制。
properties, types, functions等能够进行版本控制的统称为实体。
Public：可以访问自己模块或应用中源文件里的任何实体，别人也可以访问引入该模块中源文件里的所有实体。通常情况下，某个接口或Framework是可以被任何人使用时，你可以将其设置为public级别。
Internal：可以访问自己模块或应用中源文件里的任何实体，但是别人不能访问该模块中源文件里的实体。通常情况下，某个接口或Framework作为内部结构使用时，你可以将其设置为internal级别。
Private：只能在当前源文件中使用的实体，称为私有实体。使用private级别，可以用作隐藏某些功能的实现细节

一个小技巧,如果我们有一系列的私有方法,我们可以把它们组织起来,放进一个extension里,这样就不需要每个方法都标记private,同时也便于管理组织代码：

// MARK: Privateprivate extension ViewController { func privateFunction() { }}
创建对象与alloc
和init

关于初始化,在Swift中创建一个对象的语法很简洁：只需在类名后加一对圆括号即可。

var shape = Shape()
而在Swift中,initializer
也与OC有所区别,Swift的初始化方法不返回数据。而在OC中我们通常返回一个self指针。
Unlike Objective-C initializers, Swift initializers do not return a value. Their primary role is to ensure that new instances of a type are correctly initialized before they are used for the first time.

Swift的初始化方法让我们只关注对象的初始化。之前在OC世界中为什么要self = [super init]？。这种问题得以避免。Swift帮助我们处理了alloc的过程。也让我们的代码更简洁明确。
而在Swift中,init
也有了更严格的规则。
对于所有Stored Properties
,都必须在对象被创建出来前设置好。也就是我们必须在init方法中赋好值,或是直接给属性提供一个默认值。
如果有property可以被允许在初始出来时没有值,也就是需要在创建出来后再赋值,或是在程序运行过程都可能不会被赋值。那么这个property必须被声明为optional
类型。该类型的属性会在init的时候初始化为nil.

initializer严格分为Designated Initializer
和Convenience Initializer
并且有语法定义。
而在Objective-C中没有明确语法标记哪个初始化方式是convenience方法。关于Designated Initializer
可参阅之前的:Objective-C 拾遗：designated initializer

init(parameters) { statements}
convenience init(parameters) { statements}

5.枚举与结构体
枚举
在Swift中,枚举是一等公民。(first-class)。能够拥有方法,computed properties等以往只有类支持的特性。
在C中,枚举为每个成员指定一个整型值。而在Swift中,枚举更强大和灵活。我们不必给枚举成员提供一个值。如果我们想要为枚举成员提供一个值(raw value),我们可以用字符串,字符,整型或浮点数类型。

enum CompassPoint {
case Northcase Southcase Eastcase West 
} 
var directionToHead = CompassPoint.West
结构体
Struct在Swift中和类有许多相同的地方,可以定义属性,方法,初始化方法,可通过extension扩展等。
不同的地方在于struct是值类型.在传递的过程中都是通过拷贝进行。
在这里要提到在前面第一节处提到了String
,Array
和Dictionary
在Swift是以值类型出现的。这背后的原因就是String
,Array
,Dictionary
在Swift中是通过Struct
实现的。而之前在Objective-C它们都是通过class实现的。
Swift中强大的Struct使得我们能够更多与值类型打交道。Swift的值类型增强了不可变性(Immutabiliity)
。而不可变性提升了我们代码的稳定性,多线程并发的安全性。
在WWDC2014《Advanced iOS Application Architecture and Patterns》中就有一节的标题是Simplify with immutability。
延伸阅读：WWDC心得：Advanced iOS Application Architecture and Patterns


6.协议（Protocols）
语法:
在Objective-C中我们这么声明Protocol:

@protocol SampleProtocol <NSObject>- (void)someMethod;@end
而在Swift中：

protocol SampleProtocol { func someMethod()}
在Swift遵循协议:

class AnotherClass: SomeSuperClass, SampleProtocol{ func someMethod() {}}
那么之前Objective-C的protocol中,我们可以标志optional。那在Swift中呢？
遗憾的是,目前纯Swift的protocol还不支持optional。但根据苹果官方论坛的一位员工的回答,未来Swift是会支持的。
Optional methods in protocols are limited to @objc protocols only because we haven't implemented them in native protocols yet. This is something we plan to support. We've gotten a number of requests for abstract/pure virtual classes and methods too.
— Joe Groff
Source: https://devforums.apple.com/message/1051431#1051431

protocol
和delegate
是紧密联系的。那么我们在Swift中如何定义Delegate呢？

protocol MyDelegate : class {}class MyClass { weak var delegate : MyDelegate?}
注意到上面的protocol定义后面跟着的class。这意味着该protocol只能被class类型所遵守。
并且只有遵守了class protocol的delegate才能定义为weak。这是因为在Swift中,除了class能够遵守协议,枚举和结构同样能够遵守协议。而枚举和结构是值类型,不存在内存管理的问题。因此只需要class类型的变量声明为weak即可。
利用Swift的optional chaining,我们能够很方便的检查delegate是否为Nil,是否有实现某个方法:
以前我们要在Objective-C这样检查：

if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleForSegmentAtIndex:)]) { 
thisSegmentTitle = [self.dataSource titleForSegmentAtIndex:index]; 
}
在Swift中,非常的优雅简洁。

if let thisSementTitle = dataSource?.titleFroSegmentAtIndex?(index){}
新特性:
在Swift中,protocol变得更加强大,灵活：
class
,enum
,structure
都可以遵守协议。

Extension
也能遵守协议。利用它,我们不需要继承,也能够让系统的类也遵循我们的协议。
例如：

protocol myProtocol { 
func hello() -> String
}
extension String:myProtocol{ 
func hello() -> String { 
return "hello world!" 
}
}
我们还能够用这个特性来组织我们的代码结构,如下面的代码所示,将UITableViewDataSource的实现移到了Extension。使代码更清晰。

// MARK: - UITableViewDataSourceextension 
MyViewcontroller: UITableViewDataSource {// table view data source methods}
Protocol Oriented Programming

随着Swift2.0的发布,面向协议编程正式也加入到了Swift的编程范式。Cool.
这种编程方式通过怎样的语法特性支撑的呢？
那就是我们能够对协议进行扩展,也就是我们能够提供协议的默认实现,能够为协议添加新的方法与实现。
用前面的myProtocol为例子,我们在Swift里这样为它提供默认实现。
extension myProtocol{ func hello() -> String { return "hello world!" }}

我们还能对系统原有的protocol进行扩展,大大增强了我们的想象空间。Swift2.0的实现也有很多地方用extension protocol的形式进行了重构。
面向协议编程能够展开说很多,在这里这简单地介绍了语法。有兴趣的朋友可以参考下面的资料：
Session 408: Protocol-Oriented Programming in Swift
IF YOU'RE SUBCLASSING, YOU'RE DOING IT WRONG.


7.Swift与Cocoa
一门语言的的强大与否,除了自身优秀的特性外,很大一点还得依靠背后的框架。Swift直接采用苹果公司经营了很久的Cocoa框架。现在我们来看看使用Swift和Cocoa交互一些需要注意的地方。
id
与AnyObject

在Swift中,没有id
类型,Swift用一个名字叫AnyObject
的protocol来代表任意类型的对象。

id myObject = [[UITableViewCell alloc]init];
var myObject: AnyObject = UITableViewCell()
我们知道id的类型直到运行时才能被确定,如果我们向一个对象发送一条不能响应的消息,就会导致crash。
我们可以利用Swift的语法特性来防止这样的错误:

myObject.method?()
如果myObject没有这个方法,就不会执行,类似检查delegate是否有实现代理方法。
在Swift中,在AnyObject
上获取的property都是optional
的。

闭包
OC中的block
在Swift中无缝地转换为闭包。函数实际上也是一种特殊的闭包。

错误处理
之前OC典型的错误处理步骤:

NSFileManager *fileManager = [NSFileManager defaultManager];
NSURL *URL = [NSURL fileURLWithPath:@"/path/to/file"];
NSError *error = nil;
BOOL success = [fileManager removeItemAtURL:URL error:&error];
if (!success) { 
NSLog(@"Error: %@", error.domain);
}
在Swift中：

let fileManager = NSFileManager.defaultManager()
let URL = NSURL.fileURLWithPath("/path/to/file")do { try fileManager.removeItemAtURL(URL)} catch let error as NSError { print("Error: \(error.domain)")}
KVO。
Swift支持KVO。但是KVO在Swift,个人觉得是不够优雅的,KVO在Swift只限支持继承NSObject的类,有其局限性,在这里就不介绍如何使用了。
网上也出现了一些开源库来解决这样的问题。有兴趣可以参考一下:
Observable-Swift
KVO 在OS X中有Binding的能力,也就是我们能够将两个属性绑定在一起,一个属性变化,另外一个属性也会变化。对与UI和数据的同步更新很有帮助,也是MVVM架构的需求之一。之前已经眼馋这个特性很久了,虽然Swift没有原生带来支持,Swift支持的泛型编程给开源界带来许多新的想法。下面这个库就是实现binding的效果。
Bond


8.总结
到这里就基本介绍完Swift当中最基本的语法和与Objective-C的对比和改进。
事实上Swift的世界相比OC的世界还有很多新鲜的东西等待我们去发现和总结,Swift带来的多范式编程也将给我们编程的架构和代码的组织带来更来的思考。而Swift也是一个不断变化,不断革新的语言。相信未来的发展和稳定性会更让我们惊喜。这篇文章也将随着Swift的更新而不断更新,同时限制篇幅,突出重点。
希望这篇文章能够给各位同行的小伙伴们快速了解和学习Swift提供一点帮助。有疏漏错误的地方欢迎直接提出。感谢。

