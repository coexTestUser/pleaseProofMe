General remarks:

Data is stored in the respective 'data' directories in each folder.
Post-processing files that evaluate data are implemented in Mathematica 11.0™ files.
The particle tracking algorithm was implemented in Matlab™.



The Structure of this repository is as follows:

experiment_autocorrelation		contains data associated with Figures S2D,E.
 data					contains single particle trajectories (associated with Movie S2)
 evaluation.nb				uses raw data of single particle trajectories to create autocorrelation functions.

experiment_collisions_processivity      contains data associated with Figures 1D,E, S1.
 data					contains data from single collisions and filament velocities.
 collision_statistics.nb		loads and evaluates collision data for 3% PEG. See reference (34) for data in 0% PEG.
 detect.m				detects all filaments in a tiff movie. (Matlab)
 trackfilament.m			uses results obtained by 'detect.m' to narrow down possible collisions. (Matlab)
 skeletonize_vid2.m			skeletonizes filaments of interest to obtain contour coordinates. (Matlab)
 find_skel_ends.m			auxiliary file for skeletonize_vid2.m.
 sort_points.m				auxiliary file for skeletonize_vid2.m.

experiment_velocity_distribution        contains data associated with Figures 2C, S2A-C.
 isotropic
  data					contains an array of tif files.
  imageanalysis.nb			employs the Kanade-Lucas-Tomasi feature tracking algorithm to create the velocity distribution.
 nematic
  data					contains an array of tif files.
  imageanalysis.nb			employs the Kanade-Lucas-Tomasi feature tracking algorithm to create the velocity distribution.
 polar
  data					contains an array of tif files.
  imageanalysis.nb			employs the Kanade-Lucas-Tomasi feature tracking algorithm to create the velocity distribution.

simulation_collisions			contains data associated with Figures 3B, S3.
 collision_statistics
  data					contains scattering data of colliding filaments, at various parameters (each curve includes 10,000 collisions).
  evaluation_comparison.nb		evaluates collision curves and compares behavior of alpha=2.75 and alpha=6.25.
  evaluation_fluctuations_a2.75.nb      evaluates collision fluctuations as a function of the persistence length at alpha=2.75.
  evaluation_fluctuations_a6.25.nb      evaluates collision fluctuations as a function of the persistence length at alpha=6.25.
 2D_collision_statistics
  data					contains scattering data of colliding filaments, at various alpha (each includes 100,000 collisions)
  evaluation.nb				evaluates collision data and creates a 2D contour of theta_out as a function of theta_in and alpha.

simulation_evolution_statistcs		each subfolder contains data and plotting files for the evolution statistics of single simulation realizations.
 autocorrelations			contains data associated with Figure S4C. The corresponding simulation produces a nematic lane.
  data					contains all filament orientations during the evolution.
  figuremaker.nb			uses filament orientations to create autocorrelation functions
 density_profile			contains data associated with Figure S4F. The corresponding simulation produces a sharp polar wave profile.
  data					contains discretized densities.
  figuremaker.nb			plots the density profile (averaged in one dimension).
 global_order_parameters_Fig_S4B	contains data associated with Figure S4B. The corresponding simulations produces different types of order.
  nematic_lane
   data
   figuremaker.nb			plots the order parameters.
  polar_wave
   data
   figuremaker.nb			plots the order parameters.
 global_order_parameters_Fig_S4D	contains data associated with Figure S4D.
  data
  figuremaker.nb			plots the order parameters.
 global_order_parameters_Fig_S4E	contains data associated with Figure S4E.
  data
  figuremaker.nb			plots the order parameters.

simulation_hysteresis_analysis		contains data associated with Figures 3F, 4A,E, S5, & S7A.
 1D_alpha				(for fixed density, varying alpha)
  data					contains stationary order parameters in both increasing and decreasing alpha directions.
  evaluation.nb				plots the order parameters and calculates the hysteresis.
 2D_alpha_vs_density			(varying alpha & density)
  data					contains stationary order parameters in both increasing and decreasing alpha directions.
  evaluation.nb				plots the order parameters and calculates the hysteresis.
 2D_alpha_vs_phip1			(varying alpha & phi_p)
  data					contains stationary order parameters in both increasing and decreasing alpha directions.
  evaluation.nb				plots the order parameters and calculates the hysteresis.
 2D_alpha_vs_phip2			(varying alpha & phi_p, DOUBLED system size)
  data					contains stationary order parameters in both increasing and decreasing alpha directions.
  evaluation.nb				plots the order parameters and calculates the hysteresis.

simulation_timescale_analysis		contains data associated with Figures 4F, S7B-E.
 timescale_fitting_procedure							
  data					contains the evolution of global and local order parameters for 20 different simulation realizations.
  evaluation_fixationtimes.nb		evaluates order parameter evolutions and fits the various fixation times of the systems.
 a3.13_phip3.30deg
  data					contains fitted time scales for different realizations and system sizes.
  evaluation_timescales.nb		plots time scales as a function of system size.
 a4.17_phip2.06deg
  data					contains fitted time scales for different realizations and system sizes.
  evaluation_timescales.nb		plots time scales as a function of system size.


