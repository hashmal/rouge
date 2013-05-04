module Rouge
  module Lexers
    class Shirka < RegexLexer
      desc 'shirka'
      tag 'shirka'
      aliases 'shirka'
      filenames '*.shk'

      mimetypes 'text/x-shirka', 'application/x-shirka'

      def self.analyze_text(text)
        return 0
      end

      WHITE_SPACE       = /[\s\t\n\r]+/

      COMMENT           = /--.*/

      SEPARATOR         = /[\[\]\(\)]/
      ESCAPE_SEQUENCE   = /\\[\\"abfnrstv]/
      OPERATOR_CHAR     = /[\+%\.\-\?\^*\/\|=><~&!@#\$]/

      OPERATOR          = /#{OPERATOR_CHAR}+(?=#{SEPARATOR}|#{WHITE_SPACE})/

      CHARACTER_LIT     = /'(?:\w|#{ESCAPE_SEQUENCE})/
      NUMBER_LIT        = /-?[0-9]+(?:\.[0-9]+)?/
      SYMBOL_LIT        = / (?:[a-zA-Z_]    | #{OPERATOR_CHAR})
                            (?:[a-zA-Z0-9_] | #{OPERATOR_CHAR})*
                          /x
      QUOTED_SYMBOL_LIT = /:#{SYMBOL_LIT}/

      RESERVE           = /->|=>|<-/

      BOOLEAN           = /(?:TRUE|FALSE)\b/

      state :tokens do
        rule(COMMENT,           "Comment")
        rule(WHITE_SPACE,       "Other")
        rule(CHARACTER_LIT,     "Literal.String.Char")
        rule(NUMBER_LIT,        "Literal.Number")
        rule(OPERATOR,          "Operator")
        rule(BOOLEAN,           "Name.Builtin")
        rule(QUOTED_SYMBOL_LIT, "Literal.String.Symbol")
        rule(SYMBOL_LIT,        "Name")
        rule(SEPARATOR,         "Punctuation")
      end

      state :root do
        mixin :tokens

        rule(/"/, "Literal.String", :string)

        rule(/(#{RESERVE})(#{WHITE_SPACE})(#{SYMBOL_LIT})/) do |m|
          token("Keyword",       m[1])
          token("Other",         m[2])
          token("Name.Function", m[3])
        end
      end

      state :string do
        rule(/"/, "Literal.String", :pop!)
        rule(ESCAPE_SEQUENCE, 'Literal.String.Escape')
        rule(/./m, "Literal.String")
      end
    end
  end
end

