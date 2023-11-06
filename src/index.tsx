import { NativeModules, Platform } from 'react-native';

const Haptics = NativeModules.Haptics;

export type HapticType =
  | 'light'
  | 'medium'
  | 'heavy'
  | 'rigid'
  | 'soft'
  | 'success'
  | 'warning'
  | 'error'
  | 'selectionChanged';

export function haptic(type: HapticType = 'medium') {
  if (Platform.OS === 'android') {
    console.log('Haptics is not supported on Android');
    return;
  }
  Haptics.haptic(type);
}

/**
 * Represents different haptic patterns.
 *
 * 'o' // Represents a medium impact
 * 'O' // Represents a heavy impact
 * '.' // Represents a light impact
 * ':' // Represents a soft impact
 * '-' // Represents a wait of 0.1 second
 * '='; // Represents a wait of 1 second
 */
export type HapticPattern =
  | 'o' // Represents a medium impact
  | 'O' // Represents a heavy impact
  | '.' // Represents a light impact
  | ':' // Represents a soft impact
  | '-' // Represents a wait of 0.1 second
  | '='; // Represents a wait of 1 second

export function hapticWithPattern(pattern: HapticPattern[]) {
  if (Platform.OS === 'android') {
    console.log('Haptics is not supported on Android');
    return;
  }
  Haptics.hapticWithPattern(pattern);
}

export function play(fileName: string, loop: boolean = false) {
  if (Platform.OS === 'android') {
    console.log('Haptics is not supported on Android');
    return;
  }
  Haptics.play(fileName, loop);
}
