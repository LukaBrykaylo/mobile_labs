import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_labs/cubit/profile/profile_cubit.dart';
import 'package:mobile_labs/cubit/profile/profile_state.dart';
import 'package:mobile_labs/elements/widget/settings_popup.dart';
import 'package:mobile_labs/service/auth_service.dart';
import 'package:mobile_labs/service/network_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        authService: context.read<IAuthService>(),
        networkService: context.read<NetworkService>(),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'lib/elements/photos/background_small.jpg',
                fit: BoxFit.cover,
              ),
            ),
            BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (!state.isLoading &&
                    state.error == null &&
                    state.name != null &&
                    state.email != null) {
                  final networkService = context.read<NetworkService>();
                  if (!networkService.hasConnection) {
                    Fluttertoast.showToast(
                      msg: 'Logged in offline mode',
                      toastLength: Toast.LENGTH_LONG,
                    );
                  }
                }

                if (state.loggedOut) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }

                if (state.error != null) {
                  Fluttertoast.showToast(
                    msg: state.error!,
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () => showDialog<void>(
                                context: context,
                                barrierColor: Colors.transparent,
                                builder: (_) => const SettingsPopup(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () =>
                                  context.read<ProfileCubit>().logOut(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildInfoSection(
                                  'Name:', state.name ?? 'Unknown',),
                              const SizedBox(height: 16),
                              _buildInfoSection(
                                  'Email:', state.email ?? 'Unknown',),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 18)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
