import Foundation
import Observation

@MainActor
@Observable
final class AudioManager {
    private(set) var lastRequestedAudioFileName: String?

    // TODO: Future real native-speaker recordings will be attached to words and phrases.
    // TODO: Future AI-generated Ingush audio may be tested, but all generated audio must be reviewed by a native speaker before release.
    func playPlaceholder(audioFileName: String?) {
        lastRequestedAudioFileName = audioFileName
    }
}
