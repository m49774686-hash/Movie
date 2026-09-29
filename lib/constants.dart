import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences? sp;
// const int kSmMovieItemWidth;
// const int kSmMovieItemHeight;

const Color kDeskBackgroundColor = Color.fromARGB(255, 20, 20, 20);

const double kLgScreenWidth = 750; // > 750
const double kMdLgScreenWidth = 900; // 750 < 900
const double kXLgScreenWidth = 1100; // > 900
const double kFullScreenBillBoard = 600;

const double kDLgMovieItemHeight = 164; //265 x 149
const double kDLgMovieItemWidth = 291.92;

const double kDMdMovieItemHeight = 120;
const double kDMdMovieItemWidth = 213; // 189 x 106.5

const double kDSmMovieItemHeight = 103;
const double kDSmMovieItemWidth = 183.34;

const double kMbMovieItemHeight = 170;
const double kMbMovieItemWidth = 120;

const movieZoneBackendUrl = String.fromEnvironment(
  'MOVIEZONE_BACKEND_URL',
  defaultValue: 'https://moviezone-backend-1r89.onrender.com',
);

const apiUrl = movieZoneBackendUrl;
const newApiUrl = movieZoneBackendUrl;
const addUrl = movieZoneBackendUrl;

// Legacy downloader compatibility constants. Normal MovieZone playback never uses these.
final audioM3u8Exp = RegExp(r'https://(?<prefix>[\w\.-]+)\.top/files/(?<id>[\w]+)/a/(?<index>\d+)/\d+\.m3u8');
const key = '';

const headers = {
  'Origin': apiUrl,
  'Referer': '$apiUrl/',
  'Sec-Fetch-Mode': 'cors',
  'User-Agent':
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36',
  'Accept': '*/*',
  'cookie': 'hd=on',
  'Accept-Language': 'en-GB,en-US;q=0.9,en;q=0.8',
  // 'Cache-Control': 'no-cache',
  // 'Connection': 'keep-alive',
  // 'Pragma': 'no-cache',
  // 'Sec-Fetch-Dest': 'empty',
  // 'Sec-Fetch-Site': 'cross-site',
  // 'sec-ch-ua':
  //     '"Not)A;Brand";v="99", "Google Chrome";v="127", "Chromium";v="127"',
  // 'sec-ch-ua-mobile': '?0',
  // 'sec-ch-ua-platform': '"Linux"',
};

final headers2 = [
  'Origin: $apiUrl',
  'Referer: $apiUrl/',
  'Sec-Fetch-Mode: cors',
  'Accept: */*',
  'Accept-Language: *',
  // 'Accept-Language: q=0.9,en;q=0.8',
  // 'Accept-Language: de-DE\,de;q=0.9\,en-US;q=0.8\,en;q=0.7'
  // 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8',
  // 'Cache-Control: no-cache',
  // 'Connection: keep-alive',
  // 'Pragma: no-cache',
  // 'Sec-Fetch-Dest: empty',
  // 'Sec-Fetch-Site: cross-site',
  // 'sec-ch-ua: "Not)A;Brand";v="99", "Google Chrome";v="127", "Chromium";v="127"',
  // 'sec-ch-ua-mobile: ?0',
  // 'sec-ch-ua-platform: "Linux"',
];

final Map<String, String> movieZonePosterRegistry = {};
final Map<String, String> movieZoneBackdropRegistry = {};

void registerMovieZoneMedia(Map<String, dynamic> item) {
  final id = String(item['id'] ?? item['tmdb_id'] ?? item['imdb_id'] ?? '').trim();
  if (id.isEmpty) return;
  final poster = item['poster_path'] ?? item['poster_url'];
  final backdrop = item['backdrop_path'] ?? item['backdrop_url'];
  if (poster != null && String(poster).isNotEmpty) movieZonePosterRegistry[id] = String(poster);
  if (backdrop != null && String(backdrop).isNotEmpty) movieZoneBackdropRegistry[id] = String(backdrop);
}

final bool isDesk = Platform.isLinux || Platform.isWindows || Platform.isMacOS;
const Dot = "•";
int parseIdFromUrl(String url) {
  // Use regular expression to find the part containing digits
  final match = RegExp(r'\d+').firstMatch(url);

  // Check if a match was found
  if (match != null) {
    // Return the captured group (the digits)
    return int.parse(match.group(0)!);
  } else {
    // No ID found, return an empty string
    return 1;
  }
}

extension ColorExtensions on Color {
  Color inc(BuildContext context, [double amount = 0.1]) {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return lighten(amount);
    }
    return darken(amount);
  }

  Color revInc(BuildContext context, [double amount = 0.1]) {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return lighten(amount);
    }
    return lighten(amount);
  }

  Color dec(BuildContext context, [double amount = 0.1]) {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return darken(amount);
    }
    return lighten(amount);
  }

  Color revDec(BuildContext context, [double amount = 0.1]) {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return darken(amount);
    }
    return darken(amount);
  }

  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }

  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    final lightened = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return lightened.toColor();
  }
}
