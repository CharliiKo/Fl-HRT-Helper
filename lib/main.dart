import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      home: MyHomePage(title: appTitle)
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0; // 当前选中的菜单索引： 0 - 首页，1 - 校准，2 - 我的
  final List<int> _History = []; // 历史记录

  void _changePage(int index, {bool isBack = false}){
    if (_selectedIndex == index) return;

    setState(() {
      if(!isBack) {
        // 不是返回操作，记录当前页面到历史记录
        _History.add(_selectedIndex);
      }
      _selectedIndex = index;
    });
  }

  void _showMyBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    // 允许弹窗背景透明，以便看到我们自定义的圆角容器
    backgroundColor: Colors.transparent, 
    // 允许拖动关闭
    isScrollControlled: true, 
    builder: (BuildContext context) {
      return Container(
        // 设置高度，或者让它根据内容自适应
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 让弹窗高度根据内容自适应
          children: [
            // 顶部的“小横条”，提示用户可以下滑关闭
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            
            // 根据当前选中的页面，显示不同的弹窗标题和内容
            Text(
              _selectedIndex == 0 ? "新增首页数据" : "开始设备校准",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            
            // 弹窗内的模拟列表或按钮
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("手动输入"),
              onTap: () => Navigator.pop(context), // 关闭弹窗
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text("扫码添加"),
              onTap: () => Navigator.pop(context),
            ),
            
            // 底部留一点间距，防止被手机底部横条遮挡
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: _History.isEmpty, // 如果历史为空，允许退出 App；否则拦截
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      if (_History.isNotEmpty) {
        final previousIndex = _History.removeLast();
        _changePage(previousIndex, isBack: true);
      }
    },
    child: Scaffold(
        extendBody: true,// 让 body 延伸 到底部，底部导航栏会悬浮在上面
        appBar: AppBar(
          // 智能返回按钮
          leading: _History.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // 取出历史记录中的最后一个
                  final previousIndex = _History.removeLast();
                  _changePage(previousIndex, isBack: true);
                },
              )
            : null, // 如果没有历史记录，则不显示返回键
        ),
        body: switch (_selectedIndex) {
          0 => const HomePage(),
          1 => const CalibrationPage(),
          2 => const PersonPage(),
          _ => const HomePage(), // '_' 相当于 default，处理所有其他情况
        },
        floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
            ? FloatingActionButton.extended(
                onPressed: () {
                  _showMyBottomSheet(context);
                },
                icon: const Icon(Icons.add),
                label: Text((_selectedIndex == 0 ? "新增记录" : "新增校准")),
              )
            : null,
        bottomNavigationBar: BottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _changePage(index), // 传递回调函数给 BottomBar
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildPillButton(
                index: 0,
                icon: Icons.home,
                label: "首页",
                activeColor: Colors.blue.shade600,
                inactiveColor: Colors.blue.shade50,
                onTap: () => onTap(0), // 调用父组件传入的回调
              ),
              const SizedBox(width: 12),
              _buildPillButton(
                index: 1,
                icon: Icons.tune,
                label: "校准",
                activeColor: Colors.green.shade600,
                inactiveColor: Colors.green.shade50,
                onTap: () => onTap(1), // 调用父组件传入的回调
              ),
              const SizedBox(width: 12),
              _buildPillButton(
                index: 2,
                icon: Icons.person,
                label: "我的",
                activeColor: Colors.orange.shade600,
                inactiveColor: Colors.orange.shade50,
                onTap: () => onTap(2), // 调用父组件传入的回调
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton({
    required int index,
    required IconData icon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    // 使用传入的 currentIndex 判断是否选中
    bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : activeColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : activeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("这是首页"));
  }
}

class CalibrationPage extends StatelessWidget {
  const CalibrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("这是校准页"));
  }
}

class PersonPage extends StatelessWidget {
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("这是我的页"));
  }
}

