# ppm - Proton Package Manager

Discover and install Proton packages powered by [Proton](https://github.com/yonas/proton)

Proton is a fork of [apm](https://github.com/atom/apm). See [README-old.md](https://github.com/yonas/ppm/blob/master/README-old.md) for the old README.

## Installing

ppm is bundled and installed automatically with Proton. You can run the
_Proton > Install Shell Commands_ menu option to install it again if you aren't
able to run it from a terminal.

## Building
  * Clone the repository
  * Run `pkg install libgnome-keyring` on FreeBSD. Install `libgnome-keyring-dev` on Linux.
  * Run `npm install`
  * Run `grunt` to compile the CoffeeScript code
  * Run `npm test` to run the specs
