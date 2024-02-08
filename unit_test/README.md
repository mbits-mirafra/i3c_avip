# Unit Test for I3C Project
The idea of using unit test inside the I3C_AVIP project is verifying the src code by using the SVUnit.


# Installation - Get the I3C_AVIP project from the GitHub repository

```
# Checking for git software, open the terminal type the command
git version

# Get the VIP collateral
git clone git@github.com/mbits-mirafra/i3c_avip.git

```

# setup environment variable path
```
For setenv path source svunit_setenv_path.csh file

#Run command:
source svunit_setenv_path.csh
```

# How to run Unit test

### Using Mentor's Questasim simulator 

```
cd i3c_avip/unit_test

#Run Command:
runSVUnit -s questa

```

```
## Follow the below link for the more information about SVUnit 
https://github.com/mbits-mirafra/svunit/wiki

## Contact Mirafra Team  
You can reach out to us over mbits@mirafra.com

