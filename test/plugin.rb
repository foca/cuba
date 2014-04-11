require_relative "helper"

scope do
  module Helper
    def clean(str)
      str.strip
    end
  end

  test do
    Cuba.plugin Helper

    Cuba.define do
      on default do
        res.write clean " foo "
      end
    end

    _, _, body = Cuba.call({})

    assert_response body, ["foo"]
  end
end

scope do
  module Number
    def num
      1
    end
  end

  module Plugin
    def self.setup(app)
      app.plugin Number
    end

    def bar
      "baz"
    end

    module ClassMethods
      def foo
        "bar"
      end
    end
  end

  setup do
    Cuba.plugin Plugin

    Cuba.define do
      on default do
        res.write bar
        res.write num
      end
    end
  end

  test do
    assert_equal "bar", Cuba.foo
  end

  test do
    _, _, body = Cuba.call({})

    assert_response body, ["baz", "1"]
  end
end

scope do
  module Plugin
    def self.setup(app, resp = "x")
      app.settings[:resp] = resp
    end

    def resp
      settings[:resp]
    end
  end

  test do
    Cuba.plugin Plugin

    Cuba.define do
      on default do
        res.write resp
      end
    end

    _, _, body = Cuba.call({})

    assert_response body, ["x"]
  end

  test do
    Cuba.plugin Plugin, "y"

    Cuba.define do
      on default do
        res.write resp
      end
    end

    _, _, body = Cuba.call({})

    assert_response body, ["y"]
  end
end
