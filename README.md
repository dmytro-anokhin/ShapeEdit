# ShapeEdit

ShapeEdit is a showcase for [Advanced ScrollView](https://github.com/dmytro-anokhin/advanced-scrollview), inspired by WWDC sample with the same name. ShapeEdit is build in SwiftUI, with exception of the scroll view, that is `UIScrollView` or `NSScrollView` under the hood.

ShapeEdit contains some shapes that can be interacted with on a fixed size canvas. You can:
- Drag shapes around;
- Resize shapes;
- Create new shapes;
- Change fill and stroke color;
- On macOS scroll view will autoscroll to follow the coursor;
- Zoom in/out;
- Delete elements from a context menu.

Note: this is just a prototype, it's not optimized for performance in any way and should be considered as a case study if you want to build something similar. You need Xcode 13 to run it. I developed it mainly for macOS, some features not working on iOS yet.

![ShapeEdit](https://user-images.githubusercontent.com/5136301/128566281-360b1e10-2ff0-42f0-b879-03e60b01997a.png)

