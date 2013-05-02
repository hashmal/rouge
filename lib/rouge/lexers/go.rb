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

      state :root do
      end
    end
  end
end
