module Rouge
  module Lexers
    class Go < RegexLexer
      desc 'go'
      tag 'go'
      aliases 'go'
      filenames '*.???'

      mimetypes 'text/x-go', 'application/x-go'

      def self.analyze_text(text)
        return 0
      end

      state :root do
      end
    end
  end
end

