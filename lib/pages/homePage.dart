import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConcentrationSection(context),
          const SizedBox(height: 24),
          _buildChartSection(),
          const SizedBox(height: 24),
          _buildRecordsSection(),
        ],
      ),
    );
  }

  /// 当前估算血药浓度
  Widget _buildConcentrationSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.opacity, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  '当前估算血药浓度',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: '125.4',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        TextSpan(
                          text: ' pmol/L',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '最后更新: 2026-03-19 12:00',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatusButton(
                  context,
                  icon: Icons.check_circle_outline,
                  label: '处于标准范围内',
                  color: Colors.green,
                  onTap: () => _showRangeDialog(context),
                ),
                _buildStatusButton(
                  context,
                  icon: Icons.info_outline,
                  label: '数据可能不准确',
                  color: Colors.orange,
                  onTap: () => _showAccuracyTip(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 辅助构建状态标签按钮
  Widget _buildStatusButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  void _showRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('标准范围说明'),
        content: const Text(
            '当前标准血药浓度范围建议为：100.0 - 200.0 pmol/L。\n\n您的当前估算值为 125.4 pmol/L，处于正常参考区间内。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('确定')),
        ],
      ),
    );
  }

  void _showAccuracyTip(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('准确性提示'),
        content: const Text(
            '该数值是根据您的给药记录通过算法估算所得，并非实际血液检测结果。由于个体代谢差异，估算值可能与实际浓度存在偏差，仅供参考。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('了解')),
        ]
        )
    );
  }

  /// 血药浓度图表
  Widget _buildChartSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.show_chart, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  '血药浓度图表',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(
                child: Text(
                  '此处展示浓度变化趋势图表',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 已增加的记录（按周分组展示）
  Widget _buildRecordsSection() {
    // 模拟按周分组的数据
    final List<Map<String, dynamic>> weeklyGroups = [
      {
        'weekRange': '本周 (03-16 至 03-22)',
        'records': [
          {'id': 5, 'time': '2026-03-19 10:00', 'dose': '2.0 mg'},
          {'id': 4, 'time': '2026-03-17 09:30', 'dose': '2.0 mg'},
        ]
      },
      {
        'weekRange': '上周 (03-09 至 03-15)',
        'records': [
          {'id': 3, 'time': '2026-03-14 10:00', 'dose': '2.0 mg'},
          {'id': 2, 'time': '2026-03-11 10:00', 'dose': '1.5 mg'},
          {'id': 1, 'time': '2026-03-09 10:00', 'dose': '1.5 mg'},
        ]
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.list_alt, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                '已增加的记录',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ...weeklyGroups.map((group) => _buildWeeklyCard(group)),
      ],
    );
  }

  /// 构建单周记录卡片
  Widget _buildWeeklyCard(Map<String, dynamic> group) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 周标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group['weekRange'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  '共 ${group['records'].length} 条',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // 该周的记录列表
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group['records'].length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final record = group['records'][index];
              return ListTile(
                dense: true,
                leading: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.medication, color: Colors.white, size: 14),
                ),
                title: Text('第 ${record['id']} 次给药'),
                subtitle: Text(record['time']),
                trailing: Text(
                  record['dose'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}