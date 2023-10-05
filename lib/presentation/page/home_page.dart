import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/decorator.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/app_color.dart';
import 'package:getx_money_record_app/config/app_format.dart';
import 'package:getx_money_record_app/config/session.dart';
import 'package:getx_money_record_app/data/source/user_endpoint.dart';
import 'package:getx_money_record_app/presentation/controllers/c_home.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/page/auth/login_page.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:getx_money_record_app/presentation/page/history/add_history_page.dart';
import 'package:getx_money_record_app/presentation/page/history/detail_history_page.dart';
import 'package:getx_money_record_app/presentation/page/history/history_page.dart';
import 'package:getx_money_record_app/presentation/page/history/income_outcome_page.dart';
import 'package:getx_money_record_app/presentation/widgets/button.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/profile.png',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      cUser.data.name.toString().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      cUser.data.email.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        Get.to(() => AddHistoryPage())?.then(
                          (value) {
                            if (value ?? true) {
                              cHome.getAnalysis(cUser.data.idUser!);
                            }
                          },
                        );
                      },
                      leading: const Icon(
                        Icons.add,
                        color: AppColor.primary,
                      ),
                      title: const Text('Tambah Baru'),
                      horizontalTitleGap: -6,
                      trailing: const Icon(Icons.navigate_next_rounded),
                    ),
                    ListTile(
                      onTap: () => Get.to(
                        () => const IncomeOutcomePage(
                          type: 'Pemasukan',
                        ),
                      ),
                      leading: const Icon(
                        Icons.south_west,
                        color: Colors.green,
                      ),
                      title: const Text('Pemasukan'),
                      horizontalTitleGap: -6,
                      trailing: const Icon(Icons.navigate_next_rounded),
                    ),
                    ListTile(
                      onTap: () => Get.to(
                        () => const IncomeOutcomePage(
                          type: 'Pengeluaran',
                        ),
                      ),
                      leading: const Icon(
                        Icons.north_east,
                        color: Colors.red,
                      ),
                      title: const Text('Pengeluaran'),
                      horizontalTitleGap: -6,
                      trailing: const Icon(Icons.navigate_next_rounded),
                    ),
                    ListTile(
                      onTap: () => Get.to(
                        () => const HistoryPage(),
                      ),
                      leading: const Icon(
                        Icons.history,
                        color: Colors.blue,
                      ),
                      title: const Text('Riwayat'),
                      horizontalTitleGap: -6,
                      trailing: const Icon(Icons.navigate_next_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CustomButton(
                        onTap: () {
                          cUser.logout();
                        },
                        title: 'LOGOUT',
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/profile.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hi,',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.primary,
                          ),
                        ),
                        Text(
                          cUser.data.name.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(builder: (ctx) {
                    return Material(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColor.primary,
                      child: InkWell(
                        onTap: () {
                          Scaffold.of(ctx).openEndDrawer();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(9),
                          child: Icon(
                            Icons.menu,
                            color: AppColor.bg,
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    cHome.getAnalysis(cUser.data.idUser!);
                  },
                  child: ListView(
                    children: [
                      cardToday(),
                      const SizedBox(
                        height: 5,
                      ),
                      cardWeek(),
                      const SizedBox(
                        height: 20,
                      ),
                      cardMonth(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column cardMonth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perbandingan bulan ini',
          style: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Obx(() {
                      return DChartPieO(
                        data: [
                          OrdinalData(
                              domain: 'Pemasukan',
                              measure: cHome.monthIncome,
                              color: AppColor.primary),
                          OrdinalData(
                            domain: 'Pengeluaran',
                            measure: cHome.monthOutcome,
                            color: AppColor.chart,
                          ),
                          if (cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                            OrdinalData(
                              domain: '',
                              measure: 1,
                              color: AppColor.chart,
                            ),
                        ],
                        configRenderPie: ConfigRenderPie(
                          arcWidth: 30,
                          arcLabelDecorator: ArcLabelDecorator(
                            showLeaderLines: true,
                          ),
                        ),
                      );
                    }),
                    Center(
                      child: Obx(
                        () {
                          return Text(
                            '${cHome.percentIncome}%',
                            style: const TextStyle(
                              color: AppColor.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        color: AppColor.primary,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text('Pemasukan'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        color: AppColor.chart,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text('Pengeluaran'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Obx(() {
                    return Text(cHome.monthPercentage);
                  }),
                  const SizedBox(height: 10),
                  const Text(
                    'Atau setara :',
                  ),
                  Obx(() {
                    return Text(
                      AppFormat.currency(cHome.differentMonth.toString()),
                      style: const TextStyle(
                        color: AppColor.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Column cardWeek() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengeluaran minggu ini',
          style: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Obx(() {
            return DChartBarO(
              animate: true,
              groupList: [
                OrdinalGroup(
                  id: '1',
                  data: List.generate(
                    7,
                    (index) => OrdinalData(
                      domain: cHome.weektext()[index],
                      measure: cHome.week[index],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Column cardToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengeluaran hari ini',
          style: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                'assets/bg_card.jpg',
              ),
              fit: BoxFit.fitWidth,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 15,
                ),
                child: Obx(
                  () => Text(
                    AppFormat.currency(cHome.today.toString()),
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColor.bg),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  return Text(cHome.todayPercentage);
                }),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => DetailHistoryPage(
                      idUser: cUser.data.idUser!,
                      date: DateFormat('yyyy-MM-dd').format(
                        DateTime.now(),
                      ),
                      type: 'Pengeluaran',
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 20),
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 7,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColor.bg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'Selengkapnya',
                        style: TextStyle(color: AppColor.primary),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColor.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
