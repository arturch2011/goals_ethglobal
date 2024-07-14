# My Flutter DApp Project

This project is a decentralized application (DApp) built using Flutter. It interacts with smart contracts deployed on the Ethereum blockchain.

## Prerequisites

* **Flutter SDK:** Make sure you have Flutter installed and configured. Follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
* **Android Studio:** You'll need Android Studio to set up the Android emulator.
* **Android Emulator:** Configure an Android Virtual Device (AVD) within Android Studio to simulate an Android device.
* **Node.js and npm (or yarn):** Required for Hardhat.
* **Hardhat:** Install Hardhat globally using `npm install --global hardhat`.

## Environment Variables

This project requires environment variables to function correctly. Create a `.env` file in the root directory of your project and add the following:

```
# Infura Project ID (replace with your own)
INFURA_PROJECT_ID=YOUR_INFURA_PROJECT_ID

# Private key for your Ethereum wallet (replace with your own)
PRIVATE_KEY=YOUR_PRIVATE_KEY

# Other environment variables your DApp might need
# ...
```

**Important:** Never commit your `.env` file to version control. It contains sensitive information.


## Smart Contract Compilation (Hardhat)

1. **Install dependencies:** Navigate to the `contracts` directory (or wherever your Hardhat project is located) and run:
   ```bash
   npm install
   ```

2. **Compile contracts:**
   ```bash
   npx hardhat compile
   ```

This will generate the compiled contract artifacts in the `artifacts` directory.


## Running the App

1. **Connect a device or start the emulator:**
   * **Physical device:** Connect your Android device via USB and enable USB debugging.
   * **Emulator:** Launch your configured Android emulator from Android Studio.

2. **Run the app:**
   ```bash
   flutter run
   ```

Flutter will build the app and deploy it to the connected device or emulator.


## Troubleshooting

* **Environment variables:** Double-check that your `.env` file is correctly formatted and that all required variables are present.
* **Contract artifacts:** Ensure that the compiled contract artifacts are available in the `artifacts` directory.
* **Emulator or device:** Verify that your device or emulator is correctly connected and recognized by Flutter.
* **Dependencies:** Make sure all project dependencies are installed. Run `flutter pub get` to fetch any missing packages. 
* **Hardhat Issues:** Refer to the Hardhat documentation for troubleshooting tips: [https://hardhat.org/](https://hardhat.org/)


## Additional Notes

* **Security:**  Be extremely cautious with your private keys. Never share them publicly.
* **Testing:** Thoroughly test your DApp on a test network (like Goerli or Sepolia) before deploying to the mainnet. 
* **Updates:** Stay up-to-date with Flutter and Hardhat for the best experience.

## About

## Project Description
Goals is a mobile application that allows users to stake tokens - bet - on a habit they want to pursue, such as waking early for the next month. There are various categories, such as exercise, routines, reading or studying habits. Frequency and time frame is fully customizable. Habit bets can be public, with customizable participant limit, so others can join and challenge each other. Image recognition is used to verify the habit completion. Onboarding is as seamless as it gets, users can sign up using Gmail, Twitter or Facebook accounts. The betting pool is distributed to those who successfully complete their habit journey.

## How it's Made
This project is developed with Flutter using Dart as the main language. Web3Auth is used to abstract the users' wallets and simplify the onboarding process as much as possible. Ethereum development is done using HardHat Ignition. Project cover images are stored securely on Filecoin. These pictures are then passed through an image recognition model to verify if the user is completing the habit. Celo technology allows fee abstraction that enables users to cover the transaction fees in a wide range of tokens, providing flexibility.

## Contracts

scroll
* **tk** - 0x7E06dc439277E00B9717fE44C140B82B682C5a0c
* **goals** - 0x905a3dB053b868e9ECb0D368f43b1C825d9e485f

arbitrum
* **tk** - 0x7E06dc439277E00B9717fE44C140B82B682C5a0c
* **goals** - 0x905a3dB053b868e9ECb0D368f43b1C825d9e485f

inco
* **tk** - 0x7E06dc439277E00B9717fE44C140B82B682C5a0c
* **goals** - 0x905a3dB053b868e9ECb0D368f43b1C825d9e48