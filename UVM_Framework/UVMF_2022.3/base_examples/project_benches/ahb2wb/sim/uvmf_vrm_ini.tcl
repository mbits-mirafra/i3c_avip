## Example VRM initialization proc content. See documentation
## for full list of available variables, behavior and legal values.
## Point to this file with the $UVMF_VRM_INI environment variable
## in order to enable its use.  This INI file points the 
## regression to the test plan for the bench
proc vrmSetup {} {
  setIniVar tplanfile "(%VRUNDIR%)/ahb2wb_TestPlan.xml"
  setIniVar tplanoptions {-verbose -format Excel -datafields "Section,Title,Description,Link,Type,Weight,Goal,Owner,Manager,Priority"}
  setIniVar code_coverage_enable 1
}
