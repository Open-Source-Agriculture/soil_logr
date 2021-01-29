# Soil Mate
## *Helper app designed to assist the collection of soil data.*

The soil mate app provides a simple and convenient way to collect soil data at sample locations in the field. The Soil Mate app is targeted across multiple industries, including agriculture, environmental science, geology, and mining. The current version of the app collects soil texture data.

![image](assets/sm_screenshots.png)

Read about the app in this [article](https://open-source-agriculture.github.io/2021-01-09-soil-mate-texture-app/)


## Getting Started

Install dependencies:

```
sudo apt install curl
```

Get flutter (copy in all lines, run from home the location you want to install flutter):

```bash
git clone https://github.com/flutter/flutter.git -b stable && \
echo '#Add Flutter to PATH' >> $HOME/.bashrc && \
echo 'export PATH="$PATH:'$(pwd)'/flutter/bin"' >> $HOME/.bashrc && \
export PATH="$PATH:$(pwd)/flutter/bin" && \
echo "Check the flutter is in path" && \
echo $PATH && \
flutter precache && \
echo "Check your dependencies:" && \
flutter doctor
```

Download and install Android Studio and install the Flutter plugin:

Run `flutter doctor` again to check dependencies.

## Join us

Chat to us on Discord:

[![image](/assets/discord_logo.jpg)](https://discord.gg/8x58DuxfGz) <!-- .element height="5%" width="5%" -->

