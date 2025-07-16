# WordScramble 🧩

A fun SwiftUI word game where players try to make as many valid words as possible from a given root word.

## 📦 Features

- Start with a random word from a bundled `start.txt` file
- Enter words made from the root word's letters
- Validates:
  - Word originality (no repeats)
  - Word possibility (letters must match root word)
  - Dictionary validity (must be a real English word)
- Shows word length with a system icon (e.g. `5.circle`)
- Nice feedback via alerts for invalid entries

## 🛠 Technologies

- Swift
- SwiftUI
- UIKit (for `UITextChecker`)
- Xcode 15+
