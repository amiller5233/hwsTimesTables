//
//  ContentView.swift
//  TimesTables
//
//  Created by Adam Miller on 7/12/23.
//

import SwiftUI

struct Question {
    var text: String
    var correctAnswer: Int
    var userAnswer: Int?
}

struct ContentView: View {
    
    @State private var isGameRunning = false
    
    @State private var multiplier = 2
    @State private var questionCount = 5
    @State private var questions: [Question] = []
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    
    var body: some View {
        if !isGameRunning {
            NavigationView {
                VStack {
                    Form {
                        Section {
                            Picker("Number", selection: $multiplier) {
                                ForEach(2...12, id: \.self) {
                                    Text(String($0))
                                }
                            }
                        } header: {
                            Text("Which number would you like to practice?")
                        }
                        
                        Section {
                            Picker("Number of questions", selection: $questionCount) {
                                ForEach([5, 10, 20], id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(.segmented)
                        } header: {
                            Text("How many questions do you want?")
                        }
                        
                        Section {
                            Button("Start Game!") {
                                startGame()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .navigationTitle("TimesTables")
            }
        } else {
            NavigationView {
                Form {
                    ForEach($questions, id: \.text) { $question in
                        Section {
                            TextField("0", value: $question.userAnswer, format: .number)
                                .keyboardType(.decimalPad)
                        } header: {
                            Text("\(question.text)")
                        }
                    }
                        
                    Section {
                        Button("Submit") {
                            print(questions)
                            submitAnswers()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .toolbar {
                    Button("Reset", action: resetGame)
                }
                .alert(alertTitle, isPresented: $showAlert) {
                    Button("OK") {
                        resetGame()
                    }
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
    
    func startGame() {
        isGameRunning = true
        questions = Array(1...questionCount)
            .map { number in
                Question(text: "What is \(number) x \(multiplier)?", correctAnswer: number * multiplier)
            }
            .shuffled()
    }
    
    func resetGame() {
        isGameRunning = false
        multiplier = 2
        questionCount = 5
        alertTitle = ""
        alertMessage = ""
    }
    
    func submitAnswers() {
        alertTitle = "Results"
        let numCorrect = questions.reduce(0) { acc, cur in
            if let userAnswer = cur.userAnswer {
                print(userAnswer, cur.correctAnswer)
                return acc + (userAnswer == cur.correctAnswer ? 1 : 0)
            }
            return acc
        }
        alertMessage = "You got \(numCorrect)\\\(questions.count) correct"
        showAlert = true;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
