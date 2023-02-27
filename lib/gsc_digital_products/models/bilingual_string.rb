# frozen_string_literal: true

module GscDigitalProducts
  class BilingualString
    attr_reader :en, :fr

    def initialize(en:, fr:)
      @en = en
      @fr = fr
    end
  end
end
