coverage analyze -plansection /testplan/AHB_Bus -coverage most -file ahb_bus_most_contrib.rpt
coverage analyze -plansection /testplan/WB_Bus  -coverage most -file wb_bus_most_contrib.rpt
coverage analyze -plansection / -totals -r -showattribute Manager -showattribute Owner -showattribute Priority -file test_plan_detailed.rpt
coverage analyze -plansection / -totals -r -showattribute Manager -showattribute Owner -showattribute Priority -select coverage -lt 100 -file test_plan_holes.rpt
coverage analyze -plansection / -totals -r -showattribute Manager -showattribute Owner -showattribute Priority -select attribute Manager -eq jpeaslee -select coverage -lt 100 -file jpeaslee_holes.rpt
coverage analyze -plansection / -totals -r -showattribute Manager -showattribute Owner -showattribute Priority -select attribute Manager -eq wdisney -select coverage -lt 100 -file wdisney_holes.rpt
coverage analyze -plansection / -totals -r -showattribute Manager -showattribute Owner -showattribute Priority -select attribute Manager -eq cjones -select coverage -lt 100 -file cjones_holes.rpt
coverage analyze -plansection / -totals -r -showattribute Manager -showattribute Owner -showattribute Priority -select attribute Owner -eq boden -select coverage -lt 100 -file boden_holes.rpt
coverage analyze -plansection / -totals -r -showattribute Manager -showattribute Owner -showattribute Priority -select attribute Priority -eq 1 -select coverage -lt 100 -file priority_1_holes.rpt
quit -f
