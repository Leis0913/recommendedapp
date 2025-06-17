import UIKit

class RandomViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var itemCount: Int = 0
    var itemTexts: [String] = []
    var inputTextFields: [UITextField] = []

    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var secondCardView: UIView!
    @IBOutlet weak var randomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        styleUI()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    @IBAction func createInputs(_ sender: UIButton) {
        textFieldStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        inputTextFields.removeAll()
        
        if let count = Int(countTextField.text ?? ""), count > 0 {
            itemCount = count
            for _ in 0..<count {
                let tf = UITextField()
                tf.placeholder = "항목 입력"
                tf.borderStyle = .roundedRect
                tf.font = UIFont.systemFont(ofSize: 16)
                tf.backgroundColor = .secondarySystemGroupedBackground
                tf.layer.cornerRadius = 8
                tf.clipsToBounds = true
                
                inputTextFields.append(tf)
                textFieldStackView.addArrangedSubview(tf)
            }
        }
    }
    
    @IBAction func completeInput(_ sender: UIButton) {
        view.endEditing(true) // 키보드 닫기
        itemTexts = inputTextFields.map { $0.text ?? "" }.filter { !$0.isEmpty }

        print("입력 완료됨: \(itemTexts)")
        pickerView.reloadAllComponents()
    }


    @IBAction func spinRoulette(_ sender: UIButton) {
        print("item count: \(itemTexts.count)")
        guard !itemTexts.isEmpty else { return }

        let randomIndex = Int.random(in: 0..<itemTexts.count)
        pickerView.selectRow(randomIndex, inComponent: 0, animated: true)
        
        UIView.transition(with: resultLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.resultLabel.text = "결과: \(self.itemTexts[randomIndex])"
        })
    }
    
    func styleUI() {
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 0.5
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = true
        
        secondCardView.layer.borderColor = UIColor.lightGray.cgColor
        secondCardView.layer.borderWidth = 0.5
        secondCardView.layer.cornerRadius = 12
        secondCardView.layer.masksToBounds = true
        
        randomButton.layer.cornerRadius = 12
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemTexts.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemTexts[row]
    }
}
