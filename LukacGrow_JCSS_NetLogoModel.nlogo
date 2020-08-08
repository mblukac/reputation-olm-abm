extensions [
  nw
]

breed [ employers employer ]
breed [ employees employee ]
breed [ jobs job ]

globals [
  nr-jobs-received-sd
  recent-link
  winner-rep
]

turtles-own [
  ;; focal variables
  talent                     ;; unobserved talent of each employee
  nr-jobs-received-start     ;; starting value for nr-jobs-start (stays stable) --> for tracking the change during runs
  nr-jobs-received           ;; number of jobs received --> this one is changing
  reputation-start           ;; starting value for reputation (stays stable)
  reputation                 ;; changing value of reputation -- dependent on talent & nr-jobs-received
  feedback-start
  feedback
  earnings                   ;; amount of money earned during the run

  ;; temporary variables
  employee-partner
  employer-partner
  winner
  bid
  prob-select

]

jobs-own [
  complexity                 ;; each job has a complexity -- low complexity means easy jobs (typing, clicking, etc.)
                             ;; high complexity mean complicated jobs (programming, translating, copy-writing, etc.)
  price                      ;; offered reward for the project -- given by the employer -- correlated with scomplexity
]


links-own [
  application
  weight
]

to setup
  clear-all

  set-default-shape turtles "circle"

  ;; create employers
  create-employers num-employers
  ;; set employers' attributes
  ask employers [
    set color red
    setxy random-xcor random-ycor
    set shape "square"
    set size 0.7
  ]

  ;; create employees
  create-employees num-employees
  ;; set employees' attributes
  ask employees [
    set color blue
    setxy random-xcor random-ycor
    set shape "circle"
    set size 0.5

    ;; focal variables -- using plausible starting values
    set talent floor random 99 + 1      ;; there are people of all talents (0; 100)

    set nr-jobs-received ( floor ( random-exponential 2 )  )       ;; previously received jobs
    set nr-jobs-received-start nr-jobs-received

    set feedback 0

    set bid 0

    set earnings 0          ;; although people have received jobs in the past, we track only
                            ;; the earnings since the start, hence earnings = 0
  ]

  ;; calculation of REPUTATION (from standardized variables of TALENT & NR-JOBS-RECEIVED)
  ask employees [
    ;; center & standardize TALENT
    let talent-std ( talent - mean [talent] of employees ) / standard-deviation [ talent ] of employees

    ;; log and standardize NR-JOBS-RECEIVED
    let nr-jobs-received-log ln ( nr-jobs-received + 0.1 )
    set nr-jobs-received-sd standard-deviation [ ln ( nr-jobs-received + 0.1 ) ] of employees
    let nr-jobs-received-std ( ( nr-jobs-received-log - mean [ ln ( nr-jobs-received-start + 0.1 ) ] of employees ) / nr-jobs-received-sd )

    ;; use COEF-TALENT and COEF-NR-JOBS as weights to calculate reputation -- it is multiplied by 100 to get to 0-100 scale + added random noise
    set reputation floor ( 100 * (( exp( coef-talent * talent-std + coef-nr-jobs * nr-jobs-received-std) / ( 1 + exp( coef-talent * talent-std + coef-nr-jobs * nr-jobs-received-std) )) + random-normal 0 0.1 ) ) + 1
    set reputation-start reputation
  ]

  reset-ticks
end

to go
  ;; let it run until all jobs (NUM-JOBS) are gone
  ifelse (count links) < ( num-jobs ) [
    ;; create a new job assigned to an employer and let employees apply (up to 10)
    create-a-job

    ;; employees place their bids
    ;;  - first one looks only at the offered PRICE
    bid-first

    ;;  - others look at the offered PRICE + other peoples' BIDs and REPUTATIONs
    bid-others

    ;; employers evaluate the local pool of bidders and decide how good their bids are (probability)
    evaluate

    ;; selection procedure -- finding the winner (highest probability to select)
    select-employee

    ;; create link between employer & winning employee
    create-links

    ;; send feedback for employee's work -- this is on hold for now
    ;;job-feedback

    ;; recalculate everyone's reputation
    set-reputation

    ;; reset everything for next job call
    clean-job-apps

      ]
  [

    ;; all jobs are gone, so stop
    stop

  ]

  tick
end



;; this creates a job, assigns it to an employer, lets employees apply for it
to create-a-job

  create-jobs 1 [
    ;; job COMPLEXITY is normally distributed random variable (mean = 50, sd = 20)
    set complexity floor random-normal 50 20

    ;; check too high & too low numbers
    if complexity > 100 [
      set complexity 100
    ]
    if complexity < 1 [
      set complexity 1
    ]

    ;; job PRICEs are distributed exponentially and positively correlated with COMPLEXITY
    ;;   - the correlation coefficient is an absolute value of randomly distributed variable (mean = 0, sd = 5)
    set price abs ( random-exponential 20 + ( abs ( random-normal 0 5 ) * complexity ))

  ]

  ask jobs [
    ;; assign it to an employer
    create-link-with one-of employers

    ;; pick randomly up to 10 employees that apply
    create-links-with n-of ( (random 9) + 2 ) employees

  ]
  ;; make them noticable by [BREED]-PARTNER = 1
  ask jobs [
      ask my-links [
        set application 1
        ask other-end [
          set employee-partner 1
          set employer-partner 1
        ]
      ]
  ]
  ;; correction assign employee/employer partner status
  ask employers [
    set employee-partner 0
  ]
  ask employees [
    set employer-partner 0
  ]

  ;; Log entry for the newly created job
  ask jobs [
    if print-log [
      show "#### Created a job: ####"
      print word "Complexity: " complexity
      print word "Price: " price
    ]
  ]
end



;; Bidding process starts here:

;; First bid is separate, because it does not depend on any other agent's bid
to bid-first
  ask jobs [
    ;; define price as a variable to use in a calculation for employees (employees don't own PRICE)
    let price-job price
    ;; min & max set as 75% - 125% around PRICE --> avoid extreme under-bidding & over-bidding
    let price-job-min 0.75 * price
    let price-job-max 1.25 * price


    ;; create the first bid only based on PRICE + noise -- independent of REPUTATION!
    ask one-of link-neighbors with [ employee-partner = 1 ] [

      ;; price setting for first BID
      set bid (price-job + random-normal 0 10)

      ;; prevent BIDs below minimum & maximum
      if bid < price-job-min [
        set bid price-job-min
      ]
      if bid > price-job-max [
        set bid price-job-max
      ]

      ;; Log entry to check the first bid:
      if print-log [
        show "####################"
        print word "### First bid set: " bid
        print word "### Reputation: " reputation
      ]

    ]
  ]
end

;; Other bids taking into consideration others' bids and reputations
to bid-others
  ask jobs [
    let price-job price
    ;; min & max set as 75% - 125% around PRICE
    let price-job-min price - 0.25 * price
    let price-job-max price + 0.25 * price

    ;; let others bid
    while [ count link-neighbors with [ employee-partner = 1 and bid = 0 ] > 0 ] [

      ;; Distinguish between open vs. sealed bid auction format
      if auction = "open" [

      ;; calculate mean bid of bidders: MEAN-BID
      let sum-bids sum [ bid ] of link-neighbors with [ employee-partner = 1 and bid != 0 ]
      let mean-bid sum-bids / ( count link-neighbors with [ employee-partner = 1 and bid != 0 ] ) + random-normal 1 0.1

      ;; calculate mean reputation of bidders: MEAN-REPS
      let sum-reps sum [ reputation ] of link-neighbors with [ employee-partner = 1 and bid != 0 ]
      let mean-reps sum-reps / ( count link-neighbors with [ employee-partner = 1 and bid != 0 ] ) + random-normal 1 0.1


      ask one-of link-neighbors with [ employee-partner = 1 and bid = 0] [

        ;;
        ;; -----> BIDDING STRATEGY
        ;;
        ;; 1. take the mean-bid
        ;; 2. assess your reputation vs. mean-reputation (rep - mean-rep)
        ;; 3. adjust the mean-bid by the difference in reputations weighted by a random
        ;;    normal variable (mean = 1, sd = 0.1)

        ;; set bid (mean-bid + random-exponential 0.5 * (reputation - mean-reps)) --> no justification for this, so avoided
        set bid (mean-bid + random-normal 1 0.1 * (reputation - mean-reps))

      ;; prevent bids out of range of the job
      if bid < price-job-min [
        set bid price-job-min
      ]
      if bid > price-job-max [
        set bid price-job-max
      ]

      ;; Log to check subsequent bids:
        if print-log [
          show "########################## OPEN ##########################"
          print word "### Other bid set: " bid
          print word "### Mean reputation: " mean-reps
          print word "### Employee reputation: " reputation
        ]
        ]
      ]

      if auction = "sealed" [
        ask one-of link-neighbors with [ employee-partner = 1 and bid = 0] [

          set bid (price-job + random-normal 0 10)

        while [ ( bid < price-job-min ) or ( bid > price-job-max ) ] [
          set bid (price-job + random-normal 0 10)
        ]

              ;; Log to check subsequent bids:
        if print-log [
          show "########################## SEALED ##########################"
          print word "### Other bid set: " bid
          print word "### Employee reputation: " reputation
        ]
        ]

      ]
    ]
  ]
end

;; Evaluation step
;; ------------------------------------------------------------------------------------------------------------------
;; In this step, each job is assessed based on its COMPLEXITY
;;  --> if the job has low COMPLEXITY -- the selection is driven more by the BID (lower is better)
;;  --> if the job has high COMPLEXITY -- the selection is driven more by the REPUTATION (higher is better)
;;
;; This part contains the crucial variable -- COEF-STRATEGY, which mirrors the structural condition on the platform
;; Communication of the low & high bandwidth information on the platform directly influences how people choose
;; their employees -- hence manipulating this variable allows us to simulate different conditions under which platforms
;; operate and evaluate their economic outcomes.
;; ------------------------------------------------------------------------------------------------------------------
to evaluate
  ask jobs [
    let job-complexity complexity

    ;; selection strategy is calculated here: low complexity jobs have low prob-strategy; high complexity jobs have high prob-strategy
    let prob-strategy exp(coef-strategy * (job-complexity - 50)) / (1 + exp(coef-strategy * (job-complexity - 50)))

    ;; Log of the complexity and its selection strategy
    if print-log [
      print word "Complexity: " complexity
      print word "Prob-strategy: " prob-strategy
    ]

    ;; Evaluate all applicants one-by-one:
    ask link-neighbors with [ employee-partner = 1 ] [

      ;; this is calculated to standardize the BIDs & REPUTATIONs from the pool of applicants
      let max-bid max [ bid ] of employees with [ employee-partner = 1 ]
      let max-reputation max [ reputation ] of employees with [ employee-partner = 1 ]

      ;; Log -- what is the highest bid and reputation in the pool?
      if print-log [
        print word "Max bid: " max-bid
        print word "Max reputation: " max-reputation
      ]

      ;; Calculation of the probability to be selected by the employer
      set prob-select ( prob-strategy * ( reputation / max-reputation ) + ( 1 - prob-strategy ) * ( 1 - bid / max-bid ) )

      ;; Log to check the probabilities based on their REPUTATION & BID
      if print-log [
        show "######################"
        print word "Probability to select: " prob-select
        print word "Reputation: " reputation
        print word "Bid: " bid

      ]
    ]
  ]

end

;; choose the winning employee -- locally selected from the pool of applicants with the highest PROB-SELECT
to select-employee
  ask employees [

    if prob-select = ( max [ prob-select ] of turtles with [ employee-partner = 1 ] ) [
      set winner 1
      set nr-jobs-received nr-jobs-received + 1
      set earnings earnings + bid
    ]

    ;; if there are more employees selected with the same PROB-SELECT, choose randomly among the two
    while [ count turtles with [ winner = 1 ] > 1 ] [
      ask one-of turtles with [ winner = 1 ] [
        set winner 0
        set nr-jobs-received nr-jobs-received - 1
        set earnings earnings - bid
      ]
    ]
  ]
end

to create-links
 ;; check if there is already a link:
  ;; -- if there is a link: increase WEIGHT + 1; increase NR-JOBS-RECEIVED + 1 of WINNER = 1 employee
  ;; -- if there is no link yet: create a link; increase NR-JOBS-RECEIVED + 1
  ask links [
    ifelse (end1 = one-of turtles with [ employee-partner = 1 and winner = 1] and end2 = one-of turtles with [ employer-partner = 1 ]) or
           (end1 = one-of turtles with [ employer-partner = 1 ] and end2 = one-of turtles with [ employee-partner = 1 and winner = 1 ]) [
      set weight weight + 1
    ] [
      ask employers with [ employer-partner = 1 ] [
        create-links-with turtles with [ employee-partner = 1 and winner = 1 ] [
          set weight weight + 1
          set recent-link self
        ]
      ]
    ]
  ]

  set winner-rep [ reputation ] of employees with [ winner = 1 ]

end


;; Recalculate reputation of all employees
to set-reputation
  ask employees [
    if nr-jobs-received > 0 [

      let talent-std ( talent - mean [talent] of employees ) / standard-deviation [ talent ] of employees

      let nr-jobs-received-log ln ( nr-jobs-received + 0.1 )
      let nr-jobs-received-std ( ( nr-jobs-received-log - mean [ ln ( nr-jobs-received-start + 0.1 ) ] of employees ) / nr-jobs-received-sd )

      ;; same formula as in the beginning:
      set reputation floor ( 100 * (( exp( coef-talent * talent-std + coef-nr-jobs * nr-jobs-received-std) / ( 1 + exp( coef-talent * talent-std + coef-nr-jobs * nr-jobs-received-std) )) + random-normal 0 0.1 ) ) + 1

    ]
  ]

  ;; Log to compare starting and new REPUTATION:
    if print-log [
      ask employees with [ winner = 1 ] [
        show "###################"
        print word "Start reputation: " reputation-start
        print word "New reputation: " reputation
     ]
   ]
end



to clean-job-apps
;; Reset all attributes that are used along the way
  ask turtles [
    set employee-partner 0
    set employer-partner 0
    set winner 0
    set bid 0
    set prob-select 0
  ]

;; Kill the JOB and its links
  ask jobs [ die ]
  ask links with [ application = 1 ] [ die ]
end


;; For SNA in R -- not part of "GO", just as a possibility to save the network with a click
to save-network
  nw:save-matrix (word "matrix " date-and-time ".csv")
  export-world (word "results " date-and-time ".csv")
  print "Simulation results saved: Network & variables"
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Analytical reporters ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; In the first part, I analyze dependence of EARNINGS and NR-JOBS-RECEIVED on REPUTATION
;;   --> this shows relatively strong segmentation, where low rep. individuals are able to compete with high rep
;;       individuals under some conditions
;; In the second part, I analyze dependence of EARNINGS and NR-JOBS-RECEIVED on TALENT
;;   --> this is to investigate the efficiency of the platform redistribution of rewards and job access

;; PART I: sucess dependent on REPUTATION
;; a. EARNINGS
to-report earn-rep0_30
  let earn mean [ earnings ] of employees with [ reputation-start < 33 ]
  report earn
end
to-report earn-rep30_70
  let earn mean [ earnings ] of employees with [ reputation-start > 32 and reputation-start < 67 ]
  report earn
end
to-report earn-rep70_100
  let earn mean [ earnings ] of employees with [ reputation-start > 66 ]
  report earn
end
;; b. NR-JOBS-RECEIVED
to-report jobs-rep0_30
  let jobs-rec mean [ nr-jobs-received - nr-jobs-received-start ] of employees with [ reputation-start < 33 ]
  report jobs-rec
end
to-report jobs-rep30_70
  let jobs-rec mean [ nr-jobs-received - nr-jobs-received-start ] of employees with [ reputation-start > 32 and reputation-start < 67 ]
  report jobs-rec
end
to-report jobs-rep70_100
  let jobs-rec mean [ nr-jobs-received - nr-jobs-received-start ] of employees with [ reputation-start > 66 ]
  report jobs-rec
end

;; PART II: sucess dependent on TALENT
;; a. EARNINGS
to-report earn-tal0_30
  let earn mean [ earnings ] of employees with [ talent < 33 ]
  report earn
end
to-report earn-tal30_70
  let earn mean [ earnings ] of employees with [ talent > 32 and talent < 67 ]
  report earn
end
to-report earn-tal70_100
  let earn mean [ earnings ] of employees with [ talent > 66 ]
  report earn
end
;; b. NR-JOBS-RECEIVED
to-report jobs-tal0_30
  let jobs-rec mean [ nr-jobs-received - nr-jobs-received-start ] of employees with [ talent < 33 ]
  report jobs-rec
end
to-report jobs-tal30_70
  let jobs-rec mean [ nr-jobs-received - nr-jobs-received-start ] of employees with [ talent > 32 and talent < 67 ]
  report jobs-rec
end
to-report jobs-tal70_100
  let jobs-rec mean [ nr-jobs-received - nr-jobs-received-start ] of employees with [ talent > 66 ]
  report jobs-rec
end

;; Network reporters
to-report average-shortest-path-length
  report nw:mean-path-length
end

to-report meanrep-no-work
  let mean-rep mean [ reputation ] of employees with [ nr-jobs-received = nr-jobs-received-start ]
  report mean-rep
end
to-report count-no-work
  let cnw count employees with [ nr-jobs-received = nr-jobs-received-start ]
  report cnw
end


to-report new-link
  report recent-link
end





;;;;;;;;;;;;;;
;;; Layout ;;; <- from Preferential Attachment module in NetLogo
;;;;;;;;;;;;;;

;; resize-nodes, change back and forth from size based on degree to a size of 1
to resize-nodes
  ifelse all? turtles [size <= 1]
  [
    ;; a node is a circle with diameter determined by
    ;; the SIZE variable; using SQRT makes the circle's
    ;; area proportional to its degree
    ask turtles [ set size sqrt count link-neighbors ]
  ]
  [
    ask turtles [ set size 1 ]
  ]
end

to layout
  ;; the number 3 here is arbitrary; more repetitions slows down the
  ;; model, but too few gives poor layouts
  repeat 3 [
    ;; the more turtles we have to fit into the same amount of space,
    ;; the smaller the inputs to layout-spring we'll need to use
    let factor sqrt count turtles
    ;; numbers here are arbitrarily chosen for pleasing appearance
    layout-spring turtles links (1 / factor) (7 / factor) (1 / factor)
    display  ;; for smooth animation
  ]
  ;; don't bump the edges of the world
  let x-offset max [xcor] of turtles + min [xcor] of turtles
  let y-offset max [ycor] of turtles + min [ycor] of turtles
  ;; big jumps look funny, so only adjust a little each time
  set x-offset limit-magnitude x-offset 0.1
  set y-offset limit-magnitude y-offset 0.1
  ask turtles [ setxy (xcor - x-offset / 2) (ycor - y-offset / 2) ]
end

to-report limit-magnitude [number limit]
  if number > limit [ report limit ]
  if number < (- limit) [ report (- limit) ]
  report number
end
@#$#@#$#@
GRAPHICS-WINDOW
427
15
744
333
-1
-1
9.364
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

SLIDER
9
15
181
48
num-employers
num-employers
5
100
30.0
5
1
NIL
HORIZONTAL

SLIDER
9
50
181
83
num-employees
num-employees
10
200
120.0
10
1
NIL
HORIZONTAL

SLIDER
9
87
181
120
num-jobs
num-jobs
0
300
200.0
10
1
NIL
HORIZONTAL

BUTTON
10
127
65
160
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
68
127
123
160
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
126
127
181
160
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
903
162
1013
195
NIL
evaluate
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
872
46
982
79
NIL
create-a-job
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1039
103
1211
136
coef-talent
coef-talent
0
1
0.5
0.05
1
NIL
HORIZONTAL

SLIDER
1039
175
1211
208
coef-nr-jobs
coef-nr-jobs
0
1
0.5
0.05
1
NIL
HORIZONTAL

TEXTBOX
1044
89
1194
107
Other parameters
11
0.0
1

BUTTON
904
86
1013
119
NIL
bid-first
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
904
119
1013
152
NIL
bid-others
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
904
204
1015
237
NIL
select-employee
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
905
246
1017
279
NIL
create-links
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
905
290
1019
323
NIL
set-reputation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
917
330
1044
363
NIL
clean-job-apps
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
874
337
914
355
----->
11
0.0
1

TEXTBOX
871
23
1021
41
STEP-BY-STEP\n
11
0.0
1

TEXTBOX
877
94
906
112
-->
11
0.0
1

TEXTBOX
877
128
905
146
-->
11
0.0
1

TEXTBOX
877
168
902
186
-->
11
0.0
1

TEXTBOX
877
210
899
228
-->
11
0.0
1

TEXTBOX
878
251
902
269
-->
11
0.0
1

TEXTBOX
877
295
901
313
-->
11
0.0
1

BUTTON
10
165
181
198
NIL
layout
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
890
396
1006
429
NIL
save-network\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
1040
50
1153
83
print-log
print-log
1
1
-1000

SLIDER
222
76
394
109
coef-strategy
coef-strategy
0
1
0.3
0.05
1
NIL
HORIZONTAL

SLIDER
1039
139
1211
172
coef-feedback
coef-feedback
0
1
0.5
0.05
1
NIL
HORIZONTAL

MONITOR
63
362
163
407
NIL
earn-rep0_30
1
1
11

MONITOR
277
362
393
407
NIL
earn-rep70_100
1
1
11

MONITOR
63
408
163
453
NIL
jobs-rep0_30
1
1
11

MONITOR
277
409
393
454
NIL
jobs-rep70_100
1
1
11

MONITOR
166
362
274
407
NIL
earn-rep30_70
1
1
11

MONITOR
166
409
274
454
NIL
jobs-rep30_70
1
1
11

TEXTBOX
225
59
375
77
Experimental parameters:
11
0.0
1

TEXTBOX
873
381
1023
399
Possibly:
11
0.0
1

TEXTBOX
124
287
336
325
ANALYTICAL REPORTERS
15
0.0
1

TEXTBOX
17
304
396
332
==========================================
11
0.0
1

TEXTBOX
63
326
143
358
Reputation
13
0.0
1

TEXTBOX
100
345
146
363
Low\n
11
0.0
1

TEXTBOX
198
345
252
363
Medium
11
0.0
1

TEXTBOX
322
346
381
364
High\n
11
0.0
1

TEXTBOX
7
373
63
391
Earnings:
11
0.0
1

TEXTBOX
7
419
55
437
Nr-jobs:
11
0.0
1

CHOOSER
222
110
394
155
auction
auction
"open" "sealed"
0

TEXTBOX
1044
36
1194
54
Debugging toolkit
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

This is an agent-based model of recruiting mechanisms on online labour markets used in
the following research paper

Lukac, M. and Grow, A. (2020). Reputation systems and recruitment in online labor markets: insights from an agent-based model. *Journal of Computational Social Science*. Online First. [Download paper here](https://link.springer.com/epdf/10.1007/s42001-020-00072-x?sharing_token=tMO5y1XihT3jhqXHTEIEMfe4RwlQNchNByi7wbcMAY4DqitSn5ErRM0-e06aggmGUMd5ZAkBDkjLzmLjQjAO3bvcj3XY88Uayg7Aqhu2CJn3K3qc0pehoBIuuUIJqjhIE95gr2fuJ2QUxb-zybXupeASFp78qYd8L6r2I1lspq0%3D)

**Research question:** Can structural conditions of the recruitment mechanism produce inequal and segmented outcomes on online labour markets?


## HOW IT WORKS

### Step 1. (procedure create-a-job)
A job is created (represented by an agent, breed JOB), with some level of COMPLEXITY (random normal variable, mu = 50, sd = 20) and PRICE (random exponential variable, mu = 30, positively correlated with COMPLEXITY). The PRICE of each job has a range of possible bids between [0.75 * PRICE; 1.25 * PRICE].

A random employer is linked with the job and 1-10 freelancers are randomly chosen to apply for this job (assuming a market only with one skill) and links are created between the JOB on the one hand, and EMPLOYER & EMPLOYEES on the other.


### Step 2. (procedures bid-first and bid-others)
**First bidder**
The first bidder makes a bid equal to PRICE of the job with random noise (mu = 0, sd = 5). This bidder does not take into consideration anyone else's applications.

**Other bidders**
Other bidders make their bids sequentially, taking into consideration all the previous bids on the job. Bids are made in local pools of available information for the bidding. There are two bidding strategies of agents, dependent on their REPUTATION:

*Logic 1:* If REPUTATION is high, bid slightly higher than the average of bids of freelancers with similar REPUTATION.
*Logic 2:* If REPUTATION is low, bid lower than the average of bids of freelancers with similar REPUTATION

### Step 3. (procedure evaluate)
Probability of being selected is calculated -- this depends on the COMPLEXITY of the job. For low COMPLEXITY jobs, the REPUTATION of the freelancer is not very important as anyone can perform simple tasks and the BID is more decisive (e.g. think data collection tasks, copy-paste, simple clicking tasks). For high COMPLEXITY jobs, the REPUTATION of the freelancer is crucial, due to the need being sure that the freelancer is skilled enough and trustworthy to perform more complex work (e.g. think programming, data analysis, etc.)

Majority of jobs are, however, in between (COMPLEXITY ~ 50), so the mixing of preferences (REPUTATION vs. BID) is decided by a weight that is distributed as cumulative density function of a random normal variable. I approximate this by a logistic regression model:

> COEF-STRATEGY => as a slider, deciding the steepness
>
> P(strategy | complexity) ~ exp(coef-strategy * (complexity - 50)) / (1 + exp(coef-strategy * (complexity - 50)))

The higher the COMPLEXITY, the more you take REPUTATION into account. At COMPLEXITY = 50, the probability of selection is given equally by REPUTATION and BID.


### Step 4. (procedure select-employee)
Choose the employee with the higherst probability to be selected (PROB-SELECT).

Increase NR-JOBS-RECEIVED (+1) for the winning candidate.


### Step 5. (procedure create-links)
Create a link between winning EMPLOYEE and the EMPLOYER. If there is a link, increase link's WEIGHT (+1). 


### Step 6. (procedure set-reputation)
Recalculate REPUTATION
> reputation ~ ( coef-feedback * feedback ) + (coef-nr-jobs * nr-jobs-received )

Both COEF-FEEDBACK and COEF-NR-JOBS are unknown random parameters -- these platforms do not share their exact way of calculating the reputation score, so I will need to run experiments with different values to see how this influences the result.

In general, I don't think they will matter too much, but I will test it.

### Step 8. (procedure clean-job-apps)
General clean-up of previous job (JOBS [ die ]), its job's application-links, and resetting job selection variables (EMPLOYEE-PARTNER, EMPLOYER-PARTNER, WINNER, BID, PROB-SELECT)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="info_asym_auctiontype" repetitions="50" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="250"/>
    <metric>earn-rep0_30</metric>
    <metric>earn-rep30_70</metric>
    <metric>earn-rep70_100</metric>
    <metric>jobs-rep0_30</metric>
    <metric>jobs-rep30_70</metric>
    <metric>jobs-rep70_100</metric>
    <metric>count-no-work</metric>
    <metric>meanrep-no-work</metric>
    <enumeratedValueSet variable="num-employers">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-employees">
      <value value="120"/>
    </enumeratedValueSet>
    <steppedValueSet variable="coef-strategy" first="0.001" step="0.005" last="0.4"/>
    <enumeratedValueSet variable="print-log">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coef-nr-jobs">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coef-talent">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coef-feedback">
      <value value="0.75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-jobs">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="auction">
      <value value="&quot;open&quot;"/>
      <value value="&quot;sealed&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
