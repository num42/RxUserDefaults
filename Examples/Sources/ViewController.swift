import UIKit
import RxUserDefaults
import RxSwift

class ViewController: UIViewController {
    let settings: RxSettings
    let reactiveSetting: Setting<String>
    var disposeBag = DisposeBag()
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        return valueLabel
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.text = "Enter new value here"
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.blue, for: .normal)
        saveButton.setTitleColor(.lightGray, for: .highlighted)
        return saveButton
    }()
    
    init() {
        settings = RxSettings(userDefaults: UserDefaults.standard)
        reactiveSetting = settings.setting(key: "the_settings_key", defaultValue: "The Default Value")
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibNameOrNil:nibBundleOrNil:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupView()
       setupRxSettingsBinding()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(valueLabel)
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    private func setupRxSettingsBinding(){
        // Setup Saving to Settings
        saveButton.rx.tap
            .subscribe(onNext:
                { [weak self] _ in
                    guard let self = self else { return }
                    
                    guard let text = self.textField.text else {
                        self.reactiveSetting.remove()
                        return
                    }
                    
                    self.reactiveSetting.value = text
                }
            )
            .disposed(by: disposeBag)
        
        // Setup Displaying value when settings change
        reactiveSetting.asObservable()
            .asDriver(onErrorJustReturn: "Error")
            .drive(valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

