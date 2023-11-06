<div align="center">
</div>

<br/>

<div align="center">
  <img alt="npm downloads" src="https://img.shields.io/npm/dw/@candlefinance/@candlefinance/haptics?logo=npm&label=NPM%20downloads&cacheSeconds=3600"/>
  <a alt="discord users online" href="https://discord.gg/qnAgjxhg6n" 
  target="_blank"
  rel="noopener noreferrer">
    <img alt="discord users online" src="https://img.shields.io/discord/986610142768406548?label=Discord&logo=discord&logoColor=white&cacheSeconds=3600"/>
</div>

<br/>

<h1 align="center">
   Haptics for React Native
</h1>

<br/>

Supports playing haptics on iOS with default UIImpactFeedbackGenerator and CoreHaptics for patterns and ahap files.

## Installation

```sh
yarn add @candlefinance/haptics
```

```sh
npm i @candlefinance/haptics
```

## Basic Usage

There are two functions:

```js
import { haptic, hapticWithPattern } from '@candlefinance/haptics';

// light, medium, heavy, soft, rigid, warning, error, success, selectionChanged
haptic('medium');

// pattern
hapticWithPattern(['.', '.', '.', 'o', 'O', '-', 'O', 'o', '.', '.', '.', '.']);

// play ahap file
play('fileName');
```

The pattern format:

- 'o' // medium impact
- 'O' // heavy impact
- '.' // light impact
- ':' // soft impact
- '-' // wait of 0.1 second
- '=' // wait of 1 second

For playing ahap files to the root of your project add a folder called `haptics` and add your ahap files there. Use (Haptrix)[https://www.haptrix.com/] or equivalent to generate ahap files.

## Contributing

Join our [Discord](https://discord.gg/qnAgjxhg6n) and ask questions in the **#oss** channel.

## License

MIT
