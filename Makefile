all:
	odin build . -out:interpolation_2d.exe -debug

opti:
	odin build . -out:interpolation_2d.exe -o:speed

opti_max:
	odin build . -out:interpolation_2d.exe -o:aggressive -microarch:native -no-bounds-check -disable-assert -no-type-assert

clean:
	rm interpolation_2d.exe

run:
	./interpolation_2d.exe