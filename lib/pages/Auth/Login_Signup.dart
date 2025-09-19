// import 'package:flutter/material.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final _loginFormKey = GlobalKey<FormState>();
//   final _signupFormKey = GlobalKey<FormState>();

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   bool _isLogin = true;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _rememberMe = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _nameController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _toggleAuthMode() {
//     setState(() {
//       _isLogin = !_isLogin;
//     });
//   }

//   void _handleLogin() {
//     if (_loginFormKey.currentState?.validate() ?? false) {
//       // Implement your login logic
//       debugPrint('Login with email: ${_emailController.text}');
//     }
//   }

//   void _handleSignup() {
//     if (_signupFormKey.currentState?.validate() ?? false) {
//       // Implement your signup logic
//       debugPrint('Signup with email: ${_emailController.text}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final isWideScreen = constraints.maxWidth >= 900;

//           return Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   colorScheme.primary.withOpacity(0.05),
//                   colorScheme.primary.withOpacity(0.02),
//                   Colors.transparent,
//                 ],
//               ),
//             ),
//             child: Center(
//               child: Container(
//                 constraints: BoxConstraints(
//                   maxWidth: isWideScreen ? 1100 : 600,
//                   maxHeight: 700,
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 child: Card(
//                   elevation: 10,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: isWideScreen
//                       ? _buildWideLayout(context, colorScheme)
//                       : _buildNarrowLayout(context, colorScheme),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildWideLayout(BuildContext context, ColorScheme colorScheme) {
//     return Row(
//       children: [
//         // Illustration section
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(40),
//             decoration: BoxDecoration(
//               color: colorScheme.primary,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.lock,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'GreenPortal',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 const Text(
//                   'Welcome to\nGreenPortal',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     height: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Secure, fast and modern authentication experience for your digital life.',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Wrap(
//                   spacing: 12,
//                   runSpacing: 12,
//                   children: [
//                     _FeatureChip(icon: Icons.security, label: 'Secure'),
//                     _FeatureChip(icon: Icons.rocket_launch, label: 'Fast'),
//                     _FeatureChip(icon: Icons.devices, label: 'Responsive'),
//                   ],
//                 ),
//                 const Spacer(),
//                 Text(
//                   '© ${DateTime.now().year} GreenPortal Inc.',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.7),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Form section
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(40),
//             child: _AuthForm(
//               isLogin: _isLogin,
//               onToggleAuthMode: _toggleAuthMode,
//               loginFormKey: _loginFormKey,
//               signupFormKey: _signupFormKey,
//               emailController: _emailController,
//               passwordController: _passwordController,
//               nameController: _nameController,
//               confirmPasswordController: _confirmPasswordController,
//               obscurePassword: _obscurePassword,
//               onToggleObscurePassword: () =>
//                   setState(() => _obscurePassword = !_obscurePassword),
//               obscureConfirmPassword: _obscureConfirmPassword,
//               onToggleObscureConfirmPassword: () => setState(
//                 () => _obscureConfirmPassword = !_obscureConfirmPassword,
//               ),
//               rememberMe: _rememberMe,
//               onToggleRememberMe: (value) =>
//                   setState(() => _rememberMe = value ?? false),
//               onLogin: _handleLogin,
//               onSignup: _handleSignup,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildNarrowLayout(BuildContext context, ColorScheme colorScheme) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Header section
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: colorScheme.primary,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.lock,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'GreenPortal',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Welcome to GreenPortal',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Secure authentication experience',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.9),
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),

//           // Form section
//           Padding(
//             padding: const EdgeInsets.all(24),
//             child: _AuthForm(
//               isLogin: _isLogin,
//               onToggleAuthMode: _toggleAuthMode,
//               loginFormKey: _loginFormKey,
//               signupFormKey: _signupFormKey,
//               emailController: _emailController,
//               passwordController: _passwordController,
//               nameController: _nameController,
//               confirmPasswordController: _confirmPasswordController,
//               obscurePassword: _obscurePassword,
//               onToggleObscurePassword: () =>
//                   setState(() => _obscurePassword = !_obscurePassword),
//               obscureConfirmPassword: _obscureConfirmPassword,
//               onToggleObscureConfirmPassword: () => setState(
//                 () => _obscureConfirmPassword = !_obscureConfirmPassword,
//               ),
//               rememberMe: _rememberMe,
//               onToggleRememberMe: (value) =>
//                   setState(() => _rememberMe = value ?? false),
//               onLogin: _handleLogin,
//               onSignup: _handleSignup,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AuthForm extends StatelessWidget {
//   final bool isLogin;
//   final VoidCallback onToggleAuthMode;
//   final GlobalKey<FormState> loginFormKey;
//   final GlobalKey<FormState> signupFormKey;
//   final TextEditingController emailController;
//   final TextEditingController passwordController;
//   final TextEditingController nameController;
//   final TextEditingController confirmPasswordController;
//   final bool obscurePassword;
//   final VoidCallback onToggleObscurePassword;
//   final bool obscureConfirmPassword;
//   final VoidCallback onToggleObscureConfirmPassword;
//   final bool rememberMe;
//   final ValueChanged<bool?> onToggleRememberMe;
//   final VoidCallback onLogin;
//   final VoidCallback onSignup;

//   const _AuthForm({
//     required this.isLogin,
//     required this.onToggleAuthMode,
//     required this.loginFormKey,
//     required this.signupFormKey,
//     required this.emailController,
//     required this.passwordController,
//     required this.nameController,
//     required this.confirmPasswordController,
//     required this.obscurePassword,
//     required this.onToggleObscurePassword,
//     required this.obscureConfirmPassword,
//     required this.onToggleObscureConfirmPassword,
//     required this.rememberMe,
//     required this.onToggleRememberMe,
//     required this.onLogin,
//     required this.onSignup,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           isLogin ? 'Sign In' : 'Create Account',
//           style: theme.textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           isLogin
//               ? 'Welcome back! Please enter your details.'
//               : 'Join us today! Create your account to get started.',
//           style: theme.textTheme.bodyMedium?.copyWith(
//             color: Colors.grey.shade600,
//           ),
//         ),
//         const SizedBox(height: 24),

//         if (isLogin)
//           _buildLoginForm(context, theme, colorScheme)
//         else
//           _buildSignupForm(context, theme, colorScheme),

//         const SizedBox(height: 24),
//         _buildAuthToggle(context),

//         const SizedBox(height: 24),

//         const SizedBox(height: 16),
//         Text(
//           'By continuing, you agree to our Terms of Service and Privacy Policy.',
//           style: theme.textTheme.bodySmall?.copyWith(
//             color: Colors.grey.shade600,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildLoginForm(
//     BuildContext context,
//     ThemeData theme,
//     ColorScheme colorScheme,
//   ) {
//     return Form(
//       key: loginFormKey,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: emailController,
//             decoration: const InputDecoration(
//               labelText: 'Email',
//               prefixIcon: Icon(Icons.email_outlined),
//             ),
//             keyboardType: TextInputType.emailAddress,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your email';
//               }
//               if (!RegExp(
//                 r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//               ).hasMatch(value)) {
//                 return 'Please enter a valid email';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: passwordController,
//             decoration: InputDecoration(
//               labelText: 'Password',
//               prefixIcon: const Icon(Icons.lock_outline),
//               suffixIcon: IconButton(
//                 onPressed: onToggleObscurePassword,
//                 icon: Icon(
//                   obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 ),
//               ),
//             ),
//             obscureText: obscurePassword,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your password';
//               }
//               if (value.length < 6) {
//                 return 'Password must be at least 6 characters';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Checkbox(
//                 value: rememberMe,
//                 onChanged: onToggleRememberMe,
//                 activeColor: colorScheme.primary,
//               ),
//               const Text('Remember me'),
//               const Spacer(),
//               TextButton(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         'Password reset functionality would be implemented here',
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text('Forgot Password?'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: onLogin,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text('Sign In'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSignupForm(
//     BuildContext context,
//     ThemeData theme,
//     ColorScheme colorScheme,
//   ) {
//     return Form(
//       key: signupFormKey,
//       child: Column(
//         children: [
//           TextFormField(
//             controller: nameController,
//             decoration: const InputDecoration(
//               labelText: 'Full Name',
//               prefixIcon: Icon(Icons.person_outline),
//             ),
//             textCapitalization: TextCapitalization.words,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your name';
//               }
//               if (value.length < 2) {
//                 return 'Name must be at least 2 characters';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: emailController,
//             decoration: const InputDecoration(
//               labelText: 'Email',
//               prefixIcon: Icon(Icons.email_outlined),
//             ),
//             keyboardType: TextInputType.emailAddress,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your email';
//               }
//               if (!RegExp(
//                 r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//               ).hasMatch(value)) {
//                 return 'Please enter a valid email';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: passwordController,
//             decoration: InputDecoration(
//               labelText: 'Password',
//               prefixIcon: const Icon(Icons.lock_outline),
//               suffixIcon: IconButton(
//                 onPressed: onToggleObscurePassword,
//                 icon: Icon(
//                   obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 ),
//               ),
//             ),
//             obscureText: obscurePassword,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter a password';
//               }
//               if (value.length < 6) {
//                 return 'Password must be at least 6 characters';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: confirmPasswordController,
//             decoration: InputDecoration(
//               labelText: 'Confirm Password',
//               prefixIcon: const Icon(Icons.lock_outline),
//               suffixIcon: IconButton(
//                 onPressed: onToggleObscureConfirmPassword,
//                 icon: Icon(
//                   obscureConfirmPassword
//                       ? Icons.visibility_off
//                       : Icons.visibility,
//                 ),
//               ),
//             ),
//             obscureText: obscureConfirmPassword,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please confirm your password';
//               }
//               if (value != passwordController.text) {
//                 return 'Passwords do not match';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: onSignup,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text('Create Account'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAuthToggle(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           isLogin ? "Don't have an account?" : "Already have an account?",
//           style: TextStyle(color: Colors.grey.shade600),
//         ),
//         const SizedBox(width: 4),
//         TextButton(
//           onPressed: onToggleAuthMode,
//           child: Text(
//             isLogin ? 'Sign Up' : 'Sign In',
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.primary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _FeatureChip extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   const _FeatureChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: Colors.white, size: 16),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login API integration
  Future<void> _handleLogin() async {
    if (_loginFormKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        print(_emailController.text);
        print(_passwordController.text);
        // Replace with your actual API endpoint
        final response = await http.post(
          Uri.parse(
            'http://ec2-13-43-4-220.eu-west-2.compute.amazonaws.com:3031/api/v1/sessions',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          // Successful login
          final responseData = jsonDecode(response.body);
          debugPrint('Login successful: $responseData');

          // You might want to save the token or user data here
          // await storage.write(key: 'token', value: responseData['token']);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful!')));

          // Navigate to the next screen
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          // Handle error
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${errorData['message']}')),
          );
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 900;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withOpacity(0.05),
                  colorScheme.primary.withOpacity(0.02),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen ? 1100 : 600,
                  maxHeight: 700,
                ),
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isWideScreen
                      ? _buildWideLayout(context, colorScheme)
                      : _buildNarrowLayout(context, colorScheme),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        // Illustration section
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'GreenPortal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Welcome to\nGreenPortal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Secure, fast and modern authentication experience for your digital life.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _FeatureChip(icon: Icons.security, label: 'Secure'),
                    _FeatureChip(icon: Icons.rocket_launch, label: 'Fast'),
                    _FeatureChip(icon: Icons.devices, label: 'Responsive'),
                  ],
                ),
                const Spacer(),
                Text(
                  '© ${DateTime.now().year} GreenPortal Inc.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Form section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: _AuthForm(
              loginFormKey: _loginFormKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscurePassword: _obscurePassword,
              onToggleObscurePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              rememberMe: _rememberMe,
              onToggleRememberMe: (value) =>
                  setState(() => _rememberMe = value ?? false),
              onLogin: _handleLogin,
              isLoading: _isLoading,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'GreenPortal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to GreenPortal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Secure authentication experience',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Form section
          Padding(
            padding: const EdgeInsets.all(24),
            child: _AuthForm(
              loginFormKey: _loginFormKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscurePassword: _obscurePassword,
              onToggleObscurePassword: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              rememberMe: _rememberMe,
              onToggleRememberMe: (value) =>
                  setState(() => _rememberMe = value ?? false),
              onLogin: _handleLogin,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final GlobalKey<FormState> loginFormKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscurePassword;
  final bool rememberMe;
  final ValueChanged<bool?> onToggleRememberMe;
  final VoidCallback onLogin;
  final bool isLoading;

  const _AuthForm({
    required this.loginFormKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscurePassword,
    required this.rememberMe,
    required this.onToggleRememberMe,
    required this.onLogin,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign In',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back! Please enter your details.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),

        _buildLoginForm(context, theme, colorScheme),

        const SizedBox(height: 16),
        Text(
          'By continuing, you agree to our Terms of Service and Privacy Policy.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: onToggleObscurePassword,
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            obscureText: obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: onToggleRememberMe,
                activeColor: colorScheme.primary,
              ),
              const Text('Remember me'),
              const Spacer(),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password reset functionality would be implemented here',
                      ),
                    ),
                  );
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
