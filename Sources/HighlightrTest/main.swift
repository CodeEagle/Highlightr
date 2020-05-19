import Foundation
import Highlightr

func main() {
    guard let h = Highlightr() else { return }
    let themes = h.availableThemes()
    print(themes.count, themes)

    let langs = h.supportedLanguages()
    print(langs.count, langs)
}

main()
