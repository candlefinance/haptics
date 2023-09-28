import * as React from 'react';

import { StyleSheet, View, Text, Pressable } from 'react-native';
import { haptic, hapticWithPattern } from '@candlefinance/haptics';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {}, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Pressable
        onPress={() => {
          console.log('haptic');
          haptic('medium');
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
