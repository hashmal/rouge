describe Rouge::Lexers::Shirka do
  let(:subject) { Rouge::Lexers::Shirka.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.shk'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-shirka'
      assert_guess :mimetype => 'application/x-shirka'
    end
  end
end

