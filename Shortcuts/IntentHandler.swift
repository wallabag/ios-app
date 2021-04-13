import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is AddEntryIntent:
            return AddEntryIntentHandler()
        default:
            fatalError()
        }
    }
}
