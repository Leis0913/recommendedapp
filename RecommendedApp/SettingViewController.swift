import UIKit
import CoreLocation

class SettingViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var recommendedButton: UIButton!
    @IBOutlet weak var moodSegment: UISegmentedControl!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var showMapButton: UIButton!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var recommendedMenu: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleUI()
        
        showMapButton.isEnabled = false
        setupLocationManager()
        updateTimeLabel()
        
        resultTextView.isHidden = false
        resultTextView.alpha = 1
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location.coordinate
        fetchAddress(for: location)
        fetchWeather(for: location.coordinate)
    }
    
    func fetchAddress(for location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let address = [placemark.locality, placemark.subLocality].compactMap{ $0 }.joined(separator: " ")
                DispatchQueue.main.async{
                    self.locationLabel.text = "현재 위치: \(address)"
                }
            }
        }
    }
    
    func updateTimeLabel() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시"
        let timeString = formatter.string(from: Date())
        timeLabel.text = "현재 시간: \(timeString)"
    }
    
    func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        let apiKey = "43b9f7cfe3fdda95ce63f8cf9258b8a2"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)&units=metric&lang=kr"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let weatherArray = json["weather"] as? [[String: Any]],
                   let weather = weatherArray.first?["description"] as? String,
                   let main = json["main"] as? [String: Any],
                   let temp = main["temp"] as? Double {

                    let weatherText = "\(weather), \(Int(temp))°C"
                    DispatchQueue.main.async {
                        self.weatherLabel.text = "현재 날씨: \(weatherText)"
                    }
                }
            } catch {
                print("날씨 파싱 실패: \(error)")
            }
        }

        task.resume()
    }

    func sendToGPT(prompt: String) {
        let apiKey = "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"
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "당신은 음식 추천 전문가입니다."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                DispatchQueue.main.async {
                    self.resultTextView.text = "추천 실패"
                }
                return
            }
            
            DispatchQueue.main.async {
                let lines = content.components(separatedBy: "\n")
                
                let explanationLines = lines.dropLast()
                let explanationText = explanationLines.joined(separator: "\n")
                self.resultTextView.text = explanationText
                print("explanationText : \(explanationText)")
                self.showMapButton.isEnabled = true
            }
            
            if let lastLine = content.components(separatedBy: "\n").last,
               let menuData = lastLine.data(using: .utf8),
               let menuJson = try? JSONSerialization.jsonObject(with: menuData) as? [String: String],
               let menu = menuJson["menu"] {
                self.recommendedMenu = menu
                print("recommendedMenu : \(menu)")
            }
        }.resume()
    }
    
    @IBAction func recommendButtonTapped(_ sender: UIButton) {
        let selectedMood = moodSegment.titleForSegment(at: moodSegment.selectedSegmentIndex) ?? "알 수 없음"
        
        guard let lat = currentLocation?.latitude, let lon = currentLocation?.longitude else{
            resultTextView.text = "위치 정보를 불러올 수 없습니다."
            return
        }
        
        let weatherInfo = weatherLabel.text?.replacingOccurrences(of: "현재 날씨", with: "") ?? "알 수 없음"
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시"
        let nowTime = formatter.string(from: Date())
        
        let prompt = """
            사용자의 현재 기분은 '\(selectedMood)', 위치는 위도 \(lat), 경도 \(lon)입니다. 현재 시간은 \(nowTime)이고 날씨는 '\(weatherInfo)'입니다.
            이 정보를 종합해 가장 적절한 메뉴를 설명 문장과 함께 추천해 주세요.
            ** 출력 형식은 다음과 같이 구성합니다 **
        
            1. 사용자에게 전달할 자연어 설명 문장
            2. 마지막줄은 아래 형식의 JSON으로 추천할 메뉴만 포함
        
            **추천 메뉴는 따로 분리해서 마지막 줄은 반드시 JSON형식으로 제공해야 합니다**
            
            주의사항:
            메뉴의 이름은 반드시 **영어**로 표기
            점심 또는 저녁식사로 적절한 **주요리 또는 식사메뉴**만 추천해주세요
            **디저트, 음료류는 추천하지 마세요**
            메뉴이름은 반드시 **명사 하나만** 사용
            이름은 형용사, 꾸밈말이 붙지 않는 간단한 명사로 해야합니다.
            **형용사, 꾸밈말 없이**
            예시:
            'hotdog','hotchoco','kimchi' 형태로만 작성
            
            예시 :
            'warm hotchoco' -> 'hotchoco'
            'hotdog with bacon' -> 'hotdog'
            {"menu": "menu name"}
        
            예시 :
            오늘은 날씨가 맑고 기분도 좋아서 냉면을 추천드립니다!
            {"menu": "naengmyeon"}
            설명은 JSON에 넣지 마세요.JSON에는 반드시 메뉴 이름만 포함하세요.
            
            Recommend one Korean meal name in English that can be searched in Apple Maps using MKLocalSearch.
            Use simple and common terms like "Bulgogi", "Bibimbap", or "Korean BBQ" that are easily found in restaurant names.
            Only return dish names that are likely to appear in real restaurant listings on Apple Maps.
            Do not include drinks or desserts.
            Output format must be a single line of JSON like this:

            {"menu": "Bibimbap"}
        """
        
        sendToGPT(prompt: prompt)
    }
    
    @IBAction func showMapButtonTapped(_ sender: UIButton) {
        guard let _ = currentLocation else {
            let alert = UIAlertController(title: "위치 정보 없음", message: "현재 위치를 불러오는 중입니다. 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
            return
        }
        performSegue(withIdentifier: "showMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            if let nav = segue.destination as? UINavigationController,
               let destination = nav.topViewController as? MapViewController {
                print("working prepare - self.recommendedMenu: \(self.recommendedMenu)")
                destination.searchKeyword = self.recommendedMenu
                destination.currentLocation = self.currentLocation
            }
        }
        
    }
    
    
    func styleUI() {
        resultTextView.layer.cornerRadius = 12
        resultTextView.layer.borderColor = UIColor.lightGray.cgColor
        resultTextView.layer.borderWidth = 0.5
        resultTextView.layer.masksToBounds = true
        
        cardView.layer.cornerRadius = 12
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 0.5
        cardView.layer.masksToBounds = true
        
        recommendedButton.layer.cornerRadius = 12
        
    }
    
}
