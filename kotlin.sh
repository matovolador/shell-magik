#!/bin/bash
echo "This script sets up a basic Kotlin project with gradle build tools to use with VSC or Scripting Editors."
read -p "Make sure you are inside the project folder. Press enter to proceed." continue
read -p "This setup script requires SDKMAN. Do you wish to install it? (y|n):" install_sdkman

if [[ "$install_sdkman" = "y" || "$install_sdkman" = "Y" ]]
then
    curl -s https://get.sdkman.io | bash
fi

echo "Creating file build.gradle ..."
cat <<EOF >build.gradle
buildscript {
    repositories {
        mavenCentral()
        maven {
            url "https://dl.bintray.com/jetbrains/kotlin-native-dependencies"
        }
    }
    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-native-gradle-plugin:+"
    }
}

apply plugin: 'konan'

konan.targets = ['linux']

konanArtifacts {
    program('hello')
}
EOF

echo "Creating src/main/kotlin/hello.tk (project main)..."
mkdir -p src/main/kotlin
cd src/main/kotlin
cat <<EOF >hello.kt
fun main(args: Array<String>) {
    println("Hello Gradle!")
}
EOF

cd ../../..
echo "Do you wish to install Kotlin SDK with SDKMAN? (y|n):" install_kotlin
if [[ "$install_kotlin" = "y" || "$install_kotlin" = "Y" ]]
then
    sdk install kotlin
fi
mkdir -p kotlin-native
wget https://github.com/JetBrains/kotlin-native/archive/v1.3.0.zip && unzip v1.3.0.zip -d kotlin-native && rm v1.3.0.zip

echo "Adding .gitignore, and initializing git components."
cat <<EOF >.gitignore
.vscode
kotlin.sh
.settings
.project
# check for more of those massive folders that need to be ignored
EOF

git init
echo "Make sure you reload your IDE. (Gradle and Kotlin installations require so if you use a scripting IDE)."
read -p "Done! Press any key to exit script." continue