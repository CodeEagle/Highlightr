import Foundation
import Highlightr

func trimSeperator(_ value: String, of target: String) -> String {
    let raw = target.components(separatedBy: value)
        if raw.count >= 2 {
            var total = ""
            for r in raw {
                if r == raw.first {
                    total += r
                } else {
                    total += r.capitalized
                }
            }
            return total
        } else {
            return target
        }
}

func generateSupportedLanguagesEnum(langs: [String]) {
    var caseContent = ""
    let sorted = langs.sorted()
    for lang in sorted {
        var processedLang = lang
        let firstChar = String(lang.first!)
        if Int(firstChar) != nil {
            processedLang = "lang\(lang)"
        } else {
            processedLang = lang
        }

        processedLang = trimSeperator("-", of: processedLang)

        let caseName = processedLang
        if lang == processedLang {
            caseContent += "case \(caseName)"
        } else {
            caseContent += "case \(caseName) = \"\(lang)\""
        }
        
        if lang != sorted.last {
            caseContent += "\n\t\t"
        }
    }
    let enumRaw = """
public extension Highlightr {
\tenum SupportedLanguage: String, CaseIterable {
\t\t\(caseContent)
\t}
}
"""
    let langEnumStorePath = FileManager.default.currentDirectoryPath + "/Sources/Highlightr/SupportedLanguage.swift"
    let url = URL(fileURLWithPath: langEnumStorePath)
    let d = enumRaw.data(using: .utf8)
    try? d?.write(to: url)
}



func generateThems(themes: [String]) {
    var caseContent = ""
    let sorted = themes.sorted()
    for theme in sorted {
        var name = theme

        name = trimSeperator("-", of: name)
        name = trimSeperator(".", of: name)
        name = trimSeperator("_", of: name)

        let caseName = name.replacingOccurrences(of: "default", with: "`default`")
        if caseName == theme {
            caseContent += "case \(caseName)"
        } else {
            caseContent += "case \(caseName) = \"\(theme)\""
        }

        if theme != sorted.last {
            caseContent += "\n\t\t"
        }
    }
    let enumRaw = """
public extension Highlightr {
\tenum SupportedTheme: String, CaseIterable {
\t\t\(caseContent)
\t}
}
"""
    let path = FileManager.default.currentDirectoryPath + "/Sources/Highlightr/SupportedTheme.swift"
    let url = URL(fileURLWithPath: path)
    let d = enumRaw.data(using: .utf8)
    try? d?.write(to: url)
}

func main() {
    guard let h = Highlightr() else { return }
    let themes = h.availableThemes()
    generateThems(themes: themes)

    let langs = h.supportedLanguages()
    generateSupportedLanguagesEnum(langs: langs)
}

main()
