import func Foundation.round
public class StepSliderCore {
    public init() {
    }
   
    public var maximunValue:Int = 4
    public var minimunValue:Int = 0
    public var value: Double {
        get {
            Double(_value)
        }
        set {
                let roundedValue = round(newValue)
                let value = Int(roundedValue)
            _value = min(max(minimunValue, value), maximunValue)
        }
    }
    private var _value:Int = 0
}
