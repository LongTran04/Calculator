//
//  ContentView.swift
//  Calculator
//
//  Created by Long Tran 20/07/2022.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case mutliply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .mutliply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {

    @State var value = "0"
    @State var runningNumber: Double = 0
    @State var currentOperation: Operation = .none
    @State var check = 1

    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }
                .padding()
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }

    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .mutliply, .divide, .equal:
            if button == .add {
                check = 0
                self.currentOperation = .add
                self.runningNumber = Double(self.value) ?? 0
            }
            else if button == .subtract {
                check = 0
                self.currentOperation = .subtract
                self.runningNumber = Double(self.value) ?? 0
            }
            else if button == .mutliply {
                check = 0
                self.currentOperation = .multiply
                self.runningNumber = Double(self.value) ?? 0
            }
            else if button == .divide {
                check = 0
                self.currentOperation = .divide
                self.runningNumber = Double(self.value) ?? 0
            }
            else if button == .equal {
                check = 0
                let runningValue = self.runningNumber
                let currentValue = Double(self.value) ?? 0
                switch self.currentOperation {
                case .add:
                    self.value = "\(display(value: (runningValue + currentValue)))"
                case .subtract:
                    self.value = "\(display(value: (runningValue - currentValue)))"
                case .multiply:
                    self.value = "\(display(value: (runningValue * currentValue)))"
                case .divide:
                    if currentValue == 0{
                        self.value = "ERROR"
                        break
                    }
                    else {
                        self.value = "\(display(value: (runningValue / currentValue)))"
                    }
                case .none:
                    break
                }
            }

            if button != .equal {
                self.value = "\(self.value)"
            }
        case .clear:
            self.value = "0"
            check = 1
        case .decimal:
            var checkCharacter: Bool = true
            for i in self.value {
                if i == "." {
                    checkCharacter = false
                }
            }
            if checkCharacter {
                self.value = "\(self.value)."
            }
        case .negative:
            let currentValue = Double(self.value) ?? 0
            self.value = "\(display(value: -currentValue))"
        case .percent:
            let currentValue = Double(self.value) ?? 0
            self.value = "\(display(value: (currentValue/100)))"
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            }
            else if check == 0 {
                value = number
                check = 1
            }
            else {
                self.value = "\(self.value)\(number)"
            }
        }
    }
    
    func display(value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        }
        else {
            var result = formatValue(value: value)
            while(result.last == "0") {
                result.removeLast()
            }
            return result
        }
    }
    
    func formatValue(value: Double) -> String {
            return String(format: "%.4f", value)
    }

    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
