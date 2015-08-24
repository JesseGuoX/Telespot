#Telespot
![License](https://img.shields.io/cocoapods/l/TWPhotoPicker.svg)
![Platform](https://img.shields.io/cocoapods/p/TWPhotoPicker.svg)

[App Store](https://appsto.re/us/Ek5t8.i)
##截图
![ScreenShot](https://github.com/JGINGIT/Telespot/blob/master/ScreenShot/Preview.png)

## 1. Telespot是什么？
Telespot是一款滑板地形查找应用，帮助滑手查找全世界的滑板地形。
主要功能有：
	- 查找正在滑板的板友；
    - 查找全世界的滑板店、滑板场和滑板地形；
    - 幽灵模式，不用注册也能使用；
    - 人人都能上传喜爱的滑板场或者滑板地形，吸引更多滑手加入；


## 2. 我认为滑手们需要一个什么样的App

市面上有很多类似的App，国外制作的有：[SkateSpots](https://itunes.apple.com/us/app/skatespots/id438292992?mt=8)、[RIDERS](http://riders.co/)、[NikeSB](http://www.nike.com/us/en_us/c/skateboarding/sb-app)、[goFlow](https://goflow.me/)（goFlow主要是为冲浪爱好者打造的，且有商业公司运作，也有滑板爱好者部分功能）；国内制作的有：[滑板圈](https://itunes.apple.com/cn/app/hua-ban-quan/id870059892?mt=8)、[TicTac](http://m.zuikuapp.com/a/52410_115751)、[滑板人](https://itunes.apple.com/cn/app/hua-ban-ren/id984339660?mt=8) 等。主要功能无非就是分享适合滑板的新地形、分享滑板的短视频和图片、板友之间的社交活动之类；但是各类App功能重复、更新周期缓慢。

我觉得滑手们需要一个**轻社交，重功能**的App，目前社交类App（Weibo、Twitter、Instagram、Facebook、WeChat）已经为我们做了社交类功能（视频、图片分享，交流等），鉴于全球滑手数量不是很高，我们不需要再有一个专门为滑手做的社交类 App，不仅用户得到的内容单一（全是滑板类图片和视频），而且技术上开发和维护也相当耗费时间和金钱。如 Nike SB 的 App，太注重社交功能了，但是没什么人用，有些职业滑手的内容都是一年前发的。

最终需求只有两条：
- 能知道哪个地方有好的滑板地形；
- 能知道目前哪些地方有人在滑板。所以我们需要的其实只是工具类 App－发现滑板的好地形和发现目前周围滑板的人数。Telespot 也是照此功能打造的。

## 3. 为什么开源？
开发并维护一个软件并非易事，重复开发类似功能的 App 既解决不了实际存在的问题，也造成开发人员的时间浪费。本人从事嵌入式开发工作，Telespot 是下班周末业余时间学习 iOS 开发知识，边学边开发完成的，投入相当多的精力，移动应用开发需要花费相当多的时间学习并紧跟操作系统的技术更新，做好一个 App 也需要对此技术钻研较深，本人没有太多时间和精力继续投入到 Telespot 的功能更新上去，只能做好目前的维护工作。所以开源 Telepost 的所有代码，以便移动开发领域的滑板爱好者在此基础上继续开发或者衍生出更优秀的作品。

---------------

##使用方法 Usage
Telespot 使用 CocoaPod 管理第三方库，所以编译应用前需要先使用 ```pod install```安装第三方库。
Telespot 使用 [Parse](http://Parse.com) 作为后台服务，所以应用中需要填写相应的应用ID才能完整编译。相关宏定义在 ```SMConstants.h``` 文件中。


##Requirements
iOS 8 or higher

##Author
- JG

##License
Telespot is released under the MIT license. See the LICENSE file for more info.
