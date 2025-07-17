//
//  ContentView.swift
//  WordScramble
//
//  Created by Sandro Gakharia on 14.07.25.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var rootWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var userScore = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter Your Word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Text("Your score: \(userScore)")
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Restart") {
                    startGame()
                }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up!")
            return
        }
        
        guard isLong(word: answer) else {
            wordError(title: "Word too short", message: "Try a word with 4 letters or more!")
            return
        }
        
        guard isNewWord(word: answer) else {
            wordError(title: "Original word not permitted", message: "Try a new word!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        switch answer.count {
        case 4:
            userScore += 1
        case 5:
            userScore += 2
        case 6:
            userScore += 3
        case 7:
            userScore += 4
        case 8:
            userScore += 5
        default:
            break
        }
        
        newWord = ""
    }
    
    func startGame() {
        userScore = 0
        usedWords.removeAll()

        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func isLong(word: String) -> Bool {
        word.count > 3 && word != rootWord
    }
    
    func isNewWord(word: String) -> Bool {
        word != rootWord
    }
    
}

#Preview {
    ContentView()
}
 
