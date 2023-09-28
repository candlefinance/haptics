import * as React from 'react';

import { haptic, hapticWithPattern } from '@candlefinance/haptics';
import { Pressable, StyleSheet, Text, View } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Pressable
        onPress={() => {
          console.log('haptic');
          haptic('error');
        }}
      >
        <Text>Medium</Text>
      </Pressable>
      <Pressable
        onPress={() => {
          console.log('hapticWithPattern');
          hapticWithPattern(
            ['.', '.', '.', 'o', 'O', '-', 'O', 'o', '.', '.', '.', '.'],
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
