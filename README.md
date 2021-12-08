<p align="center">
  <a href="https://github.com/philipplk/metis"><img alt="metis" src="logo.png" width="100%"></a>
  <p align="center">Computing Constrained Mechanical Systems.</p>
</p>

See [license](LICENSE) and [acknowledgements](#acknowledgements). Cite as:

```bibtex
@misc{kinon_metis_2021,
  author = {Kinon, Philipp Lothar},
  title = {metis: computing constrained dynamical systems (GitHub repository)},
  year = {2021},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/philipplk/metis}}
}
```

* * *

## Description

Metis was a mythical Titaness who became the goddess of wisdom, prudence and ingenuity. Ingenuity being the "practical, complex and implicit" kind differs from the other types of wisdom.

Likewise, this project targets the efficient and aesthetically pleasing numerical computation of dynamical systems being subject to holonomic constraints: particle systems as well as rigid body systems.

Metis is an object-oriented MATLAB code package - tested with the R2020b version.

A startscript loads the desired input-file. This input-file includes all necessary parameters for the given mechanical problem (geometry, loads, initial values,...), the chosen numerical integration scheme (time-step size, method, simulation time), the Postprocessing routine (plot quantities, animation, export) and the solution technique (max. iterations, tolerance). Metis creates all necessary objects and computes the approximate solution based on the given parameters. Eventually, one can choose to have an animation of the solution, some plots are created and the results are being exported.

#### Prerequisites

-   [MATLAB](https://www.mathworks.com/products/matlab.html)
-   [matlab2tikz][urlmatlab2tikz] (optional)


#### Theoretical Background

-   Initial Value Problems (IVP) of Constrained Dynamics leading to Differential-algebraic Equations (DAEs)
-   Numerical Integration (Direct Methods, Variational Integrators, Energy-Momentum Schemes)
-   Newton-Rhapson Method
-   Particle Systems
-   Rigid Body Dynamics with Director Formulation

[Back To The Top](#table-of-contents)

* * *

## How To Start

1.  Clone this directory or download the .zip folder, get [matlab2tikz][urlmatlab2tikz]
2.  Open the MATLAB editor or run it with the shell script [metis.sh](metis.sh)
3.  Open [start_metis_single_analysis.m](start_metis_single_analysis.m), adjust the path to the matlab2tikz repository if needed
4. adjust `<input_file_name>` corresponding to a file from [/input](/input), for more info look at [README_input](/input/README_input.md)

```matlab
[simulation, system, integrator, solver] = Metis('input/<input_file_name>',1,1);
```

5.  Execute [start_metis_single_analysis.m](start_metis_single_analysis.m) for a first simulation
6.  Edit or change input file or create a new one in [/input](/input)
7.  For error analyses run [start_metis_error_analysis.m](start_metis_error_analysis.m) with corresponding input-file
8.  Have fun!

* * *

## References

[Back To The Top](#table-of-contents)

* * *

## Author Info

-   GitHub - [philipplk](https://github.com/philipplk)
-   Website - [Philipp L. Kinon, Karlsruhe Institute of Technology (KIT)](https://www.ifm.kit.edu/english/14_5490.php)
-   ResearchGate - [Philipp L. Kinon](https://www.researchgate.net/profile/Philipp-Kinon)
-   LinkedIn - [Philipp Kinon](https://www.linkedin.com/in/philipp-kinon-9092781b5/)

[Back To The Top](#table-of-contents)

* * *

## Acknowledgements

Metis was mainly initialised by Philipp L. Kinon during his master thesis at the [_Institute of Mechanics (IFM)_](https://www.ifm.kit.edu/english/index.php) at [_Karlsruhe Institute of Technology (KIT)_](https://www.kit.edu/english/), Germany. This project would not have been possible without the support of others:

**Academic Supervisors:**

-   [Prof. Dr.-Ing. Peter Betsch](https://www.ifm.kit.edu/english/14_4655.php)
-   [Simeon Schneider, M. Sc.](https://www.ifm.kit.edu/english/14_4890.php)
-   [Dr.-Ing. Mark Schiebl](https://www.ifm.kit.edu/english/14_4906.php)

**Coding support:**

[Julian Bauer M. Sc.](https://www.ifm.kit.edu/english/14_5166.php)
(GitHub: [JulianKarlBauer](https://github.com/JulianKarlBauer))

* * *

[Back To The Top](#table-of-contents)

[urlmatlab2tikz]: https://github.com/matlab2tikz/matlab2tikz
