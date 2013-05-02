module Rouge
  module Lexers
    class Go < RegexLexer
      desc 'The Go programming language'
      tag 'go'
      aliases 'go', 'golang'
      filenames '*.go'

      mimetypes 'text/x-go', 'application/x-go'

      def self.analyze_text(text)
        return 0
      end

      # Characters

      WHITE_SPACE            = /[\s\t\r\n]+/

      NEWLINE                = /\n/
      UNICODE_CHAR           = /[^\n]/
      UNICODE_LETTER         = /[[:alpha:]]/
      UNICODE_DIGIT          = /[[:digit:]]/

      # Letters and digits

      LETTER                 = /#{UNICODE_LETTER}|_/
      DECIMAL_DIGIT          = /[0-9]/
      OCTAL_DIGIT            = /[0-7]/
      HEX_DIGIT              = /[0-9A-Fa-f]/

      # Comments

      LINE_COMMENT           = /\/\/(?:(?!#{NEWLINE}).)*/
      GENERAL_COMMENT        = /\/\*(?:(?!\*\/).)*\*\//m
      COMMENT                = /#{LINE_COMMENT}|#{GENERAL_COMMENT}/

      # Identifiers

      IDENTIFIER             = /#{LETTER}(?:#{LETTER}|#{UNICODE_DIGIT})*/

      # Keywords

      KEYWORD                = / break       | default     | func
                               | interface   | select      | case
                               | defer       | go          | map
                               | struct      | chan        | else
                               | goto        | package     | switch
                               | const       | fallthrough | if
                               | range       | type        | continue
                               | for         | import      | return
                               | var
                               /x

      # Operators and delimiters

      OPERATOR               = / \+     | &      | \+=    | &=     | &&
                               | ==     | \!=    | \(     | \)     | -
                               | \|     | -=     | \|=    | \|\|   | <
                               | <=     | \[     | \]     | \*     | \^
                               | \*=    | \^=    | <-     | >      | >=
                               | \{     | \}     | \/     | <<     | \/=
                               | <<=    | \+\+   | =      | :=     | ,
                               | ;      | %      | >>     | %=     | >>=
                               | --     | \!     | \.\.\. | \.     | :
                               | &\^    | &\^=
                               /x

      # Integer literals

      DECIMAL_LIT            = /[0-9]#{DECIMAL_DIGIT}*/
      OCTAL_LIT              = /0#{OCTAL_DIGIT}*/
      HEX_LIT                = /0[xX]#{HEX_DIGIT}+/
      INT_LIT                = /#{DECIMAL_LIT}|#{OCTAL_LIT}|#{HEX_LIT}/

      # Floating-point literals

      DECIMALS               = /#{DECIMAL_DIGIT}+/
      EXPONENT               = /[eE][+\-]?#{DECIMALS}/
      FLOAT_LIT              = / #{DECIMALS} \. #{DECIMALS}? #{EXPONENT}?
                               | #{DECIMALS} #{EXPONENT}
                               | \. #{DECIMALS} #{EXPONENT}?
                               /x

      # Imaginary literals

      IMAGINARY_LIT          = /(?:#{DECIMALS}|#{FLOAT_LIT})i/

      # Rune literals

      ESCAPED_CHAR           = /\\[abfnrtv\\'"]/
      LITTLE_U_VALUE         = /\\u#{HEX_DIGIT}{4}/
      BIG_U_VALUE            = /\\U#{HEX_DIGIT}{8}/
      UNICODE_VALUE          = / #{UNICODE_CHAR} | #{LITTLE_U_VALUE}
                               | #{BIG_U_VALUE}  | #{ESCAPED_CHAR}
                               /x
      OCTAL_BYTE_VALUE       = /\\#{OCTAL_DIGIT}{3}/
      HEX_BYTE_VALUE         = /\\x#{HEX_DIGIT}{2}/
      BYTE_VALUE             = /#{OCTAL_BYTE_VALUE}|#{HEX_BYTE_VALUE}/
      CHAR_LIT               = /'(?:#{UNICODE_VALUE}|#{BYTE_VALUE})'/

      # String literals

      RAW_STRING_LIT         = /`(?:#{UNICODE_CHAR}|#{NEWLINE})*`/
      INTERPRETED_STRING_LIT = /"(?:#{UNICODE_VALUE}|#{BYTE_VALUE})*"/
      STRING_LIT             = /#{RAW_STRING_LIT}|#{INTERPRETED_STRING_LIT}/

      state :root do
        rule(COMMENT,       "Comment")
        rule(/;/,           "Generic")
        rule(KEYWORD,       "Keyword")
        rule(OPERATOR,      "Operator")
        rule(INT_LIT,       "Literal.Number")
        rule(FLOAT_LIT,     "Literal.Number")
        rule(IMAGINARY_LIT, "Literal.Number")
        rule(CHAR_LIT,      "Literal.String.Char")
        rule(STRING_LIT,    "Literal.String")
        rule(IDENTIFIER,    "Name")
        rule(WHITE_SPACE,   "Other")
      end
    end
  end
end
