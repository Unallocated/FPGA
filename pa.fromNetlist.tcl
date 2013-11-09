
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name fpga -dir "/home/main/git/FPGA/planAhead_run_3" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/main/git/FPGA/cpu_instructor_copy.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/main/git/FPGA} {ipcore_dir} }
add_files [list {ipcore_dir/memory.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "nexys3.ucf" [current_fileset -constrset]
add_files [list {nexys3.ucf}] -fileset [get_property constrset [current_run]]
link_design
