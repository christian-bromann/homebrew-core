class Minica < Formula
  desc "Small, simple certificate authority"
  homepage "https://github.com/jsha/minica"
  url "https://github.com/jsha/minica/archive/v1.0.2.tar.gz"
  sha256 "c5b7e6c890ad472eb39f7e44d777da1b623930fd099b414213ced14bb599c6ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c7334a3e9027cc0bcc410d11904e90e142c0811549ede3d63cbeccbcc7ea99e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecf3d68d4a4e348da0de9a156062d4c45cab04506899a74f11a84cf1af7f9402"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae5f85025b2ad73a25fb69c777587a5660ab40f92e148c561df8f9aa54544356"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e6f68245edcd602ca5fe8ab2b98c5aef62e826bc1e5f6660c710d886c308bc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d368f1e0f118453a42d30d0e1a0e86f6981269ffefb427b1dd82bdee02f0df0"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a04897c252e04c3f5559cc0b7607e1b812aec6dd7548e778bf4c6b6196c46d"
    sha256 cellar: :any_skip_relocation, monterey:       "3d812f951cbf8acc0b39ceb8a8aec45a7e10d0ff96b697c4b8e34efdda458837"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0ae49ee8f0a7dd9804c19e899efad38c95632c572cf440f247fbf8c902072c2"
    sha256 cellar: :any_skip_relocation, catalina:       "6ed3047835593e51bddc2f1150ca3db84f736c4714442140ed693e23561053ee"
    sha256 cellar: :any_skip_relocation, mojave:         "3665f724fc7ca7da303894232bceda5f53b3aa75d6fe010f77635f75062212d7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "898ae6355e98099a2692f397b58c497dbed656a7859ed8bfb9e045fc4af56a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2be226df1e804807e87055c5637b7d750684c744cad1aeccbe4b031c9a980c82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"minica"
  end

  test do
    system "#{bin}/minica", "--domains", "foo.com"
    assert_predicate testpath/"minica.pem", :exist?
  end
end
