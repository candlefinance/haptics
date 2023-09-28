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

Currently the project only supports the iOS using [Haptica](https://github.com/efremidze/Haptica) under the hood.

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

haptic('medium'); // light, medium, heavy, etc.
hapticWithPattern(
  ['.', '.', '.', 'o', 'O', '-', 'O', 'o', '.', '.', '.', '.'],
  0.1
);
```

The pattern format:

- O - heavy impact
- o - medium impact
- . - light impact
- X - rigid impact
- x - soft impact
- - wait 0.1 second

## Contributing

Join our [Discord](https://discord.gg/qnAgjxhg6n) and ask questions in the **#oss** channel.

## License

MIT
