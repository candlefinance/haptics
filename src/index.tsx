import { NativeModules, Platform } from 'react-native';

const Haptics = NativeModules.Haptics;

export type HapticType =
  | 'light'
  | 'medium'
  | 'heavy'
  | 'success'
  | 'warning'
  | 'error';

export function haptic(type: HapticType = 'medium') {
  if (Platform.OS === 'android') {
    console.warn('Haptics is not supported on Android');
    return;
  }
  Haptics.haptic(type);
}

/**
 * "O" (capital "o") - heavy impact
"o" - medium impact
"." - light impact
"-" - delay which has duration of 0.1 second
 */
export type HapticPattern = 'O' | 'o' | '.' | '-';

export function hapticWithPattern(pattern: HapticPattern[], delay: number = 0) {
  console.log('hapticWithPattern', pattern, delay);
  if (Platform.OS === 'android') {
    console.warn('Haptics is not supported on Android');
    return;
  }
  Haptics.hapticWithPattern(pattern, delay);
}
