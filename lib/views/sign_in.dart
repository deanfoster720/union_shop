import 'package:flutter/material.dart';
import 'package:union_shop/widgets/base_scaffold.dart';
import 'package:union_shop/widgets/header.dart';
import 'package:union_shop/widgets/footer.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      header: Header(
        onLogoTap: () => navigateToHome(context),
        onPlaceholderPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Sign In'),
                Tab(text: 'Sign Up'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  // Placeholder content for now
                  Center(child: Text('Sign In tab')),
                  Center(child: Text('Sign Up tab')),
                ],
              ),
            ),
          ],
        ),
      ),
      footer: const Footer(),
    );
  }
}
