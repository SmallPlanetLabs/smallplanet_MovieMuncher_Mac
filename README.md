# MovieMuncher

##### What is MovieMuncher?
We've long yearned for playing movies in our apps with a transparent background. MovieMuncher is a utility that processes video in a way to make it possible to rock transparent video. Given a specially formatted .mov or a sequence of .png files, MovieMuncher will generate a .mov double the width of the original asset(s). The left half of the resulting movie looks like the normal asset(s) against a black background and the right half shows an alpha mask. At runtime, these information streams can be recombined to make transparent video.

##### Usage
    munch input.mov
Generates input_alpha.mov

    munch input.mov -o output.mov<
Generates output.mov

    munch input001.png input002.png ...
Generates input001_alpha.mov

## License

MovieMuncher is free software distributed under the terms of the MIT license, reproduced below. MovieMuncher may be used for any purpose, including commercial purposes, at absolutely no cost. No paperwork, no royalties, no GNU-like "copyleft" restrictions. Just download and enjoy.

Copyright (c) 2014 [Small Planet Digital, LLC](http://smallplanet.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## About Small Planet

Small Planet is a mobile agency in Brooklyn, NY that creates lovely experiences for smartphones and tablets. MovieMuncher has made our lives a lot easier and we hope it does the same for you. You can find us at www.smallplanet.com. 
