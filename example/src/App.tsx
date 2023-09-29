import * as React from 'react';

import type { HapticType } from '@candlefinance/haptics';
import { haptic, hapticWithPattern } from '@candlefinance/haptics';
import { Pressable, StyleSheet, Text, View } from 'react-native';

export default function App() {
  const allHaptics: HapticType[] = [
    'light',
    'medium',
    'heavy',
    'rigid',
    'soft',
    'success',
    'warning',
    'error',
    'selectionChanged',
  ];

  return (
    <View style={styles.container}>
      {allHaptics.map((hapticType) => (
        <Pressable
          key={hapticType}
          style={styles.button}
          onPress={() => {
            console.log('haptic', hapticType);
            haptic(hapticType);
          }}
        >
          <Text>{hapticType}</Text>
        </Pressable>
      ))}
      <View style={styles.box} />
      <Pressable
        style={styles.button}
        onPress={() => {
          console.log('hapticWithPattern');
          hapticWithPattern(
            [
              '.',
              '.',
              '.',
              'o',
              'O',
              '-',
              'O',
              'o',
              '.',
              '.',
              '.',
              '.',
              '.',
              '.',
              '.',
              'o',
              'O',
              '-',
              'O',
              'o',
              '.',
              '.',
              '.',
              '.',
            ],
            1
          );
        }}
      >
        <Text>Pattern</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  button: {
    marginVertical: 10,
    backgroundColor: 'lightgray',
    padding: 10,
    width: 200,
    borderRadius: 10,
    alignItems: 'center',
  },
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
