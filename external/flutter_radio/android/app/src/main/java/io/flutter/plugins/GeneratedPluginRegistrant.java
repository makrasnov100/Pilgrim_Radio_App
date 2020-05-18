package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import br.com.thyagoluciano.flutterradio.FlutterRadioPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterRadioPlugin.registerWith(registry.registrarFor("br.com.thyagoluciano.flutterradio.FlutterRadioPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
