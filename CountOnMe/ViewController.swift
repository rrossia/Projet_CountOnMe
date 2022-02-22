//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    var resultat:Double!
    var isEquals:DarwinBoolean!
   
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "X"
        
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "X"
    }
    
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    var divisionByZero: Bool {
        let operations = elements
        for i in 1 ... operations.count-1{
            if operations[i-1] == "/" && operations[i] == "0"{
                return true
            }
        }
        return false
    }
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //It will Hide Keyboard
        textView.inputView = UIView()
        //It will Hide Keyboard tool bar
        textView.inputAccessoryView = UIView()
    }
    
   
    // View actions
    
    @IBAction func tappedReset(_ sender: UIButton) {
        textView.text = "0"
    }
    
    @IBAction func tappedDot(_ sender: UIButton) {
        let lastElement = elements.last
        if !(lastElement?.contains("."))! && canAddOperator{
            textView.text.append(".")
        }
        else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
           self.present(alertVC, animated: true, completion: nil)
       }

        }
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            textView.text = ""
        }
        //effacer le zero initial
        if textView.text == "0" {
            textView.text = numberText
        }
        else {
            textView.text.append(numberText)
        }
        
    }
        
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            
            if ((isEquals) != nil){
                 textView.text=String(resultat)
                 isEquals=false
            }

            textView.text.append(" + ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            
            if ((isEquals) != nil){
                 textView.text=String(resultat)
                 isEquals=false
            }
            textView.text.append(" - ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if canAddOperator {
            if ((isEquals) != nil){
                 textView.text=String(resultat)
                 isEquals=false
            }
                        textView.text.append(" / ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if canAddOperator {
            if ((isEquals) != nil){
                 textView.text=String(resultat)
                 isEquals=false
            }
                        textView.text.append(" X ")
        } else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard !divisionByZero else {
            let alertVC = UIAlertController(title: "Zéro!", message: "Division par 0 !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        let operations = elements
        
        if operations.contains("="){
            let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        // Create local copy of operations
        let result: Double
        result = calculer(operation:operations)
        resultat=result
        isEquals=true
        textView.text.append(" = \(result)")
       
    }
    
    
    func calculer(operation:[String])->Double{
      var total=0 as Double
      var signe:Double=1
      var temp :Double=0
      var temp2:Double=0
      var temp3:Double=0
      for i in 0 ... operation.count-1 {
     
        if(operation[i]=="+" ){
          total=total+(temp*signe)
          signe=1
        }
        else if(operation[i]=="-" ){
          total=total+(temp*signe)
          signe=(-1)
     
               
        }
        else if operation[i]=="/" {
          temp2=temp
        }
        else if operation[i]=="X" {
          temp3=temp
        }
        else{
          temp=Double(operation[i])!
          if(temp2>0 || temp2<0){
            temp=temp2/temp
            temp2=0
          }
          if(temp3>0 || temp3<0){
            temp=temp3*temp
            temp3=0
          }
        }
      }
      total=total+(temp*signe)
      return total
    }
}
