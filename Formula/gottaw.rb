require "language/go"

class Gottaw < Formula
  desc "Local command building your code as soon as you save modifications"
  homepage "https://github.com/makii42/gottaw"
  url "https://github.com/makii42/gottaw/archive/v0.1.2.tar.gz"
  sha256 "fded1577e1f48e9342b523534968ec73c58c52a3ad0df08436aaf3a3c0ec1cb1"
  head "https://github.com/makii42/gottaw.git", :branch => "develop"
  
  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/makii42/gottaw").install buildpath.children
    cd "src/github.com/makii42/gottaw" do
      system "glide", "--no-color", "install", "--strip-vendor"
      system "go", "build", "-o", bin/"gottaw"
      bash_completion.install "vendor/gopkg.in/urfave/cli.v1/autocomplete/bash_autocomplete" => "gottaw"
      zsh_completion.install "vendor/gopkg.in/urfave/cli.v1/autocomplete/zsh_autocomplete" => "gottaw"
    end
  end

  test do
    (testpath/"foo.go").write <<-EOS.undent
      package foo

    EOS
    assert_match "Identified default Golang", shell_output("#{bin}/gottaw defaults")
  end
end
