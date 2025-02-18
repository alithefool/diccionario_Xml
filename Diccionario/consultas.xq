(: 1. Buscar palabra en un idioma específico y obtener traducciones :)
declare function local:getTranslations($word as xs:string, $sourceLang as xs:string) {
  let $dictionary := doc("dictionary.xml")
  for $entry in $dictionary/dictionary/entry[word = $word and language = $sourceLang]
  return
    <result>
      <sourceWord>{$entry/word/text()}</sourceWord>
      <sourceLanguage>{$entry/language/text()}</sourceLanguage>
      <translations>
        {
          for $translation in $entry/translations/translation
          return
            <translation>
              <targetLanguage>{$translation/language/text()}</targetLanguage>
              <targetWord>{$translation/word/text()}</targetWord>
            </translation>
        }
      </translations>
    </result>
};

(: 2. Buscar por sinónimos y obtener entradas relacionadas :)
declare function local:searchBySynonym($synonym as xs:string, $lang as xs:string) {
  let $dictionary := doc("dictionary.xml")
  for $entry in $dictionary/dictionary/entry[language = $lang and synonyms/synonym = $synonym]
  return
    <result>
      <relatedWord>{$entry/word/text()}</relatedWord>
      <language>{$entry/language/text()}</language>
      <definitions>
        {
          for $def in $entry/definitions/definition
          return
            <definition>
              <text>{$def/text/text()}</text>
              <partOfSpeech>{$def/partOfSpeech/text()}</partOfSpeech>
            </definition>
        }
      </definitions>
    </result>
};

(: 3. Buscar palabras por ejemplo de uso :)
declare function local:searchByExample($exampleFragment as xs:string, $lang as xs:string) {
  let $dictionary := doc("dictionary.xml")
  for $entry in $dictionary/dictionary/entry[language = $lang]
  for $def in $entry/definitions/definition
  for $example in $def/examples/example
  where contains(lower-case($example), lower-case($exampleFragment))
  return
    <result>
      <word>{$entry/word/text()}</word>
      <language>{$entry/language/text()}</language>
      <definition>{$def/text/text()}</definition>
      <matchingExample>{$example/text()}</matchingExample>
    </result>
};

(: 4. Exportar palabra con todas sus traducciones en formato JSON :)
declare function local:exportWordToJSON($word as xs:string, $lang as xs:string) {
  let $dictionary := doc("dictionary.xml")
  let $entry := $dictionary/dictionary/entry[word = $word and language = $lang]
  return
    fn:json-serialize(
      map {
        "word": $entry/word/string(),
        "language": $entry/language/string(),
        "phonetic": $entry/phonetic/string(),
        "translations": array {
          for $tr in $entry/translations/translation
          return map {
            "language": $tr/language/string(),
            "word": $tr/word/string(),
            "phonetic": $tr/phonetic/string()
          }
        },
        "definitions": array {
          for $def in $entry/definitions/definition
          return map {
            "text": $def/text/string(),
            "partOfSpeech": $def/partOfSpeech/string(),
            "examples": array {
              for $ex in $def/examples/example
              return $ex/string()
            }
          }
        },
        "synonyms": array {
          for $syn in $entry/synonyms/synonym
          return $syn/string()
        }
      }
    )
};

(: 5. Obtener todas las palabras que comparten el mismo origen etimológico :)
declare function local:findRelatedByEtymology($etymology as xs:string) {
  let $dictionary := doc("dictionary.xml")
  for $entry in $dictionary/dictionary/entry[contains(etymology, $etymology)]
  return
    <result>
      <word>{$entry/word/text()}</word>
      <language>{$entry/language/text()}</language>
      <etymology>{$entry/etymology/text()}</etymology>
    </result>
};

(: Ejemplos de uso de las funciones :)
(: 1. Obtener traducciones de "book" en inglés :)
local:getTranslations("book", "en")

(: 2. Buscar palabras relacionadas con el sinónimo "volume" en inglés :)
local:searchBySynonym("volume", "en")

(: 3. Buscar ejemplos que contengan "reading" :)
local:searchByExample("reading", "en")

(: 4. Exportar "libro" en español a JSON :)
local:exportWordToJSON("libro", "es")

(: 5. Encontrar palabras relacionadas con etimología latina :)
local:findRelatedByEtymology("latin")