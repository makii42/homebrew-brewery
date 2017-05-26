require "language/go"

class Gottaw < Formula
  desc "Local command building your code as soon as you save modifications"
  homepage "https://github.com/makii42/gottaw"
  url "https://github.com/makii42/gottaw/archive/v0.1.0.tar.gz"
  sha256 "ba08e6a450dcea6dfaa5a26a69a33ce9bb8f5d0dd5a146177c9d1c053ddb34af"
  head "https://github.com/makii42/gottaw.git", :branch => "develop"
  
  depends_on "go" => :build

  go_resource "github.com/0xAX/notificator" do
    url "https://github.com/0xAX/notificator.git",
      :revision => "82e921414e037b057d5f9c5c8b9a8313dfa584de"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
      :revision => "9131ab34cf20d2f6d83fdc67168a5430d1c7dc23"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://gopkg.in/fsnotify.v1.git",
      :revision => "875cf421b32f8f1b31bd43776297876d01542279"
  end

  go_resource "gopkg.in/urfave/cli.v1" do
    url "https://gopkg.in/urfave/cli.v1.git",
      :revision => "0bdeddeeb0f650497d603c4ad7b20cfe685682f6"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/makii42/gottaw").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/makii42/gottaw" do
      system "go", "build", "-o", bin/"gottaw"
    end
    bash_completion.install "src/gopkg.in/urfave/cli.v1/autocomplete/bash_autocomplete" => "gottaw"
  end

  test do
    (testpath/"foo.go").write <<-EOS.undent
      package foo

    EOS
    assert_match "Identified default Golang", shell_output("#{bin}/gottaw defaults")
  end
end
