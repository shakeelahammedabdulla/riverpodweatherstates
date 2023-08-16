import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

enum City {
  stockholm,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
      const Duration(seconds: 1),
      () => {
            City.stockholm: '❄️',
            City.paris: '🌧️',
            City.tokyo: '💨',
          }[city]!);
}

// UI which writes to and reads from this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '🌈';

// the ui which reads this
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeatherEmoji;
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      weatherProvider,
    );

   return Scaffold(
  appBar: AppBar(
    title: const Text('Weather'),
  ),
  body: Column(
    children: [
      Expanded(
        child: ListView.builder(
          itemCount: City.values.length,
          itemBuilder: (context, index) {
            final city = City.values[index];
            final isSelected = city == ref.watch(currentCityProvider).state,
            return ListTile(
              title: Text(city.toString()),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(
                  currentCityProvider
                  )
                  .state = city,
              },
            );
          },
        ),
      ),
    ],
  ),
);

  }
}
