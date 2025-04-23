# ESPM_Model
This set of functions generates two additional dislocations to the deep dislocation model, which originally considers only a single dislocation to estimate displacement on the surface


Function: espm_geometry (inputs: Fault Dip, Locking Depth, Plate thickness)
Creates the Elastic Subducting Plate Model by adding two additional dislocations mimicking a subducted slab geometry with a finite thickness.


<img width="528" alt="image" src="https://github.com/user-attachments/assets/0f2c8630-36c5-4a47-bab6-9a61905b835d" />

# After defining the geometry, the script estimates the  displacement due to the individual dislocations and adds them to get the resultant displacement using the Okada formulation. Note the change in vertical displacement among the backslip, deep dislocation, and the espm models. 


<img width="388" alt="image" src="https://github.com/user-attachments/assets/1ebab48a-7202-4f6c-9785-e4989d771e05" />


Do not hesitate to reach out to me for any queries!
