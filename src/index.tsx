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
 * - `.`: Represents a light impact.
 * - `-`: Represents a wait of 0.1 second.
 * - `o`: Represents a medium impact.
 * - `O`: Represents a heavy impact.
 * - `x`: Represents a soft impact.
 * - `X`: Represents a rigid impact.
 */
export type HapticPattern =
  | '.' // Represents a light impact
  | '-' // Represents a wait of 0.1 second
  | 'o' // Represents a medium impact
  | 'O'; // Represents a heavy impact

export function hapticWithPattern(pattern: HapticPattern[], delay: number = 0) {
  console.log('hapticWithPattern', pattern, delay);
  if (Platform.OS === 'android') {
    console.log('Haptics is not supported on Android');
    return;
  }
  Haptics.hapticWithPattern(pattern, delay);
}
