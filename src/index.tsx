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
    console.log('Haptics is not supported on Android');
    return;
  }
  Haptics.haptic(type);
}

/*
Use pattern symbols to represent custom vibrations.

O - heavy impact
o - medium impact
. - light impact
X - rigid impact
x - soft impact
- - wait 0.1 second
*/
export type HapticPattern = '.' | '-' | 'o' | 'O' | 'x' | 'X';

export function hapticWithPattern(pattern: HapticPattern[], delay: number = 0) {
  console.log('hapticWithPattern', pattern, delay);
  if (Platform.OS === 'android') {
    console.log('Haptics is not supported on Android');
    return;
  }
  Haptics.hapticWithPattern(pattern, delay);
}
