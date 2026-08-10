class Pagescript < Formula
  desc "Compile compact .page files to standalone HTML"
  homepage "https://github.com/oliver-morrow/pagescript"
  url "https://github.com/oliver-morrow/pagescript/archive/refs/tags/v1.1.0-alpha.1.tar.gz"
  sha256 "5980a95d279b560a2e9de2e3dd23906afc8c23e1cb36049695396da88a0d9ead"
  license "MIT"
  head "https://github.com/oliver-morrow/pagescript.git", branch: "main"

  depends_on "rust" => :build

  def install
    # Navigate to the rust package directory
    Dir.chdir("rust/pagescript-rs") do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    # Create a minimal valid page
    (testpath/"test.page").write <<~EOS
      ::page id=test title="Test"
        ::text value="Hello Brew"
        ::/text
      ::/page
    EOS

    system bin/"pagescript", "validate", "test.page"

    output = shell_output("#{bin}/pagescript render test.page")
    assert_match "Hello Brew", output
  end
end
