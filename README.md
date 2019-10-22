# Reputation systems and recruitment in online labor markets: Insights from an agent-based model

Martin Lukac 

*Centre for Sociological Research, KU Leuven*

André Grow

*Laboratory of Digital and Computational Demography, Max Planck Institute for Demographic Research*



**Abstract**

Online labour markets—freelance marketplaces, where digital labor is distributed via a web-based platform—commonly use reputation systems to overcome the cultural and geographical boundaries as well as make it easier for employers to assess the abilities and trustworthiness of potential employees. Research shows, however, that reputation systems have a tendency to create winner-takes-all dynamics, in which differences in candidates&#39; reputations become disconnected from their objective differences. In this paper, we use an empirically validated agent-based computational model to investigate to what extent reputation systems can create segmented outcomes biased towards freelancers with high reputation. We explore how jobs and earnings are redistributed on a stylised platform under different contextual conditions of information asymmetry. Results suggest that information asymmetry influences the extent to which the reputation systems may lead to inequality between freelancers and, contrary to expectations, lower levels of information asymmetry can facilitate higher inequality in outcomes.



**Keywords** :  reputation systems, online labor markets, inequality, agent-based modeling, economic sociology, gig economy

## 1. Introduction

The success of online labor market (OLM) platforms over the last decade can be attributed to their ability to match buyers of electronically deliverable services with workers, potentially connecting geographically dispersed freelancers and employers. Although the lack of geographical boundaries is one of the biggest advantages of these web-based freelance marketplaces (Berg et al. 2018), it also poses a challenge. The reason is that OLMs differ from traditional labor markets in the assessment of job applicants. As this assessment takes place fully online, employers and freelancers face a problem of information asymmetry (Rosenblat and Stark 2016; Akerlof 1970): freelancers can communicate their education and work experience via their online profiles, but information about the quality of their work or their trustworthiness are more difficult to demonstrate (Autor 2001). These frictions are exacerbated by the often large geographical and cultural distances between employers and freelancers, which can make it even more difficult to assess the suitability of applicants.

Trying to alleviate this problem, existing OLM platforms have implemented various reputation systems that aim at aggregating information about freelancers&#39; talents and previous conduct on the platform (Gandini, Pais, and Beraldo, 2016; Yoganarasimhan, 2013). At first glance, the use of reputation systems in an OLM context appears attractive, as such systems may make it easier for employers to assess the abilities and trustworthiness of potential employees. As such, reputation systems are often seen as an indispensable feature that enables business transactions and hiring online that transcend geographical boundaries. They potentially reduce the level of uncertainty that employers face and thereby enhance the efficiency of the online recruitment process.

Earlier research on reputation systems (both in online and offline contexts) has shown, however, that such systems have a tendency to create winner-takes-all dynamics, in which differences in candidates&#39; reputations become disconnected from objective differences in ability and quality (Luca 2017, Frey and van de Rijt 2016, Gould 2002). Emerging evidence suggests that many of the existing freelancing platforms are extremely unequal in terms of employees&#39; earnings (Wood et al. 2018). The reason is that many of the existing platforms create market conditions that offer better access to work and higher remuneration to workers who are already in socially better socio-economic positions, thereby reproducing existing inequalities among the workers. Considering the enormous scale of OLMs (in the last five years, the number of Americans who freelanced in the past year has risen to 56.7 million, Upwork &amp; Freelancers Union 2018), this can have significant consequences for social inequality and influence the well-being of millions of workers worldwide. So far, comparatively little research has been done to disentangle the twofold effects that reputation systems have on the hiring process in OLMs: on the one hand, they are enablers of online transactions, but on the other hand, they may also give rise to highly segmented outcomes and reproduce existing inequalities.

In this paper, we seek to address this lacuna by exploring what role the level of information asymmetry in the hiring process may play in the emergence of inequality in OLM platforms. More specifically, we suggest that the level of information asymmetry that characterizes different OLM platforms is one of the main determinants of how much inequality reputation systems will create. Previous research has shown that even in idealized labor markets, information asymmetry can lead to the emergence of inequality (Takács and Squazzoni 2015). We investigate theoretically whether and to what extent commonly used reputation systems may affect the fairness of an OLM platform&#39;s social and economic outcomes. For this, we use an empirically validated agent-based computational model, in which we first represent key features of OLMs in computer code, and then submit this code to systematic computational simulation experiments. In these experiments, we explore how jobs and earnings are redistributed on the platform between workers with various levels of reputation under different contextual conditions of information asymmetry. This approach makes it possible to deal with the complex, self-reinforcing social dynamics that often emerge in reputation systems, and which tend to be difficult to address with verbal reasoning alone (cf. Grow and Flache, 2019). Such dynamics arise from the fact that reputation systems make hiring decisions both interdependent and path dependent: the hiring decisions that some employers have made at one point in time will affect workers&#39; reputation, thereby affecting hiring decisions by other employers in the future (Lehdonvirta, Hjorth, Graham, &amp; Barnard 2015; Gandini 2016).

In what follows, we first discuss the theoretical background of our work. Second, we present the computational model, providing both mathematical definitions and verbal explanations for each of its different elements. Third, we present the results we obtained from conducting systematic computational simulations with the model and discuss their implications for our understanding of OLMs. We end with conclusions and implications for future research.

## 2. Theoretical background

### 2.1 Trust and information asymmetry in online labor markets

Business transactions, be it goods or services, depend on mutual trust between the contracting parties. The reason is that not all aspects of a good or service can be evaluated unambiguously before the purchase and sometimes critical flaws show only after a considerable amount of time (Coleman 1990). Lack of expertise on the side of the buyer may even make it impossible to evaluate the quality of a good or service before the purchase. This problem is commonly referred to as the problem of information asymmetry (Diekmann &amp; Przepiorka 2018; Akerlof 1970) and arises in any transaction between two parties. In the case of conducting business online, issues of geographic and cultural distance and a lack of legal protections against fraud across states and international borders can further exacerbate the problem (Gandini 2016, Kässi and Lehdonvirta 2018). This does not only concern the question of whether the business partner will deliver at all, but also concerns the agreed upon quality of a service or good.

There are large differences in how different OLM platforms are structured. Some of the platforms offer location- or app-based work (e.g. transportation or delivery; e.g. UBER or Deliveroo), or microtasking (e.g. Amazon MTurk), where the tasks are distributed to larger crowds (see Berg et al. 2018). Our focus is on OLMs (Horton 2010)—freelance marketplaces, where digital labor is distributed via a web-based platform and allocated to an individual freelancer, rather than to a crowd of workers (e.g. Upwork, Freelancer, or Truelancer). In these, recruitment is typically initiated by employers who seek a certain service, by opening a new project on the platform. The project serves as a call for bids, in which the employer specifies a price range and expected duration of the project, together with a short description of the required service. Hiring on OLMs can also occur directly without the call for bids, yet in most cases it takes place via an auction (specifically buyer-determined reverse auctions). As the project becomes public, freelancers have a chance to apply for the job by submitting their bids. This entails stating a price for which they are willing to perform the service and the expected time to finalize the task. The employer can choose to close the auction at any time and choose the winning freelancer from the available bids. After the employer has accepted one of the bids, the work on the project commences. Payments for work can be made either during the project, based on the number of hours worked, or at the end as a lump sum when the project is delivered. Once the freelancer delivers the project, both parties are asked to leave public feedback about their exchange.

Evaluation and selection of applicants by employers is typically based on very limited information about the bidders (Gandini 2016). Freelancers can easily provide credentials on education or work experience via their profiles, but providing information on less directly observable characteristics—such as quality, trustworthiness, or motivation—is more difficult online (Autor 2001). Evaluating the work quality of a freelancer is based on uncertain and unreliable signals found in online profiles.

The extent to which this creates challenges for employers depends on the nature of the tasks that they seek to have completed. More specifically, existing OLM platforms feature a large diversity of tasks and vary in the skills that are requested (Berg et al. 2018), ranging from simple tasks, such as &quot;click-work&quot; or typing, to highly complex tasks, such as training machine learning algorithms (De Groen, Maselli and Fabo 2016). Even more, for some tasks it is easier to evaluate the quality of the delivered service than for others. For example, it is easier to assess the visual appeal of a graphical design or a newly developed website, than the quality of a translation of a foreign text. Depending on the task at hand, it can be difficult for freelancers to persuade the employer of their capabilities, as it remains a challenge to transmit the information about one&#39;s qualities through the online space to motivate a business exchange.

### 2.2 Reputation systems as a potential solution

Reputation systems present a potential solution to the dilemma of information asymmetry that employers face on OLM platforms. In such systems, the reputation of a given freelancer is an algorithmically generated score that carries information about the workers&#39; activities and past conduct on the platform. It is based on evaluations from previous employers and can take the form of a star-rating or any other arbitrary scale. Since the reputation score is public and accessible by future employers, it provides an immediate evaluation of employee&#39;s quality of work and motivates employees to provide the best service possible. As a result, reputation systems are a crucial feature of OLMs and the reputation score represents a powerful signal during the hiring process (Snijders and Matzat 2019).

OLM platforms feature a diverse pool of projects (Berg et al. 2018) and employers are likely to adjust their expectations regarding price and reputation depending on the project they are currently advertising (Connelly, Certo, Ireland and Reutzel 2011). Especially for projects highly dependent on the quality of the service (complex tasks, e.g. software development, data science, or marketing; see Snir and Hitt 2003), the reputation of the freelancer becomes a fundamental signal in hiring, as it is assumed to reflect their ability to deliver high-quality work (Jin and Kato 2006). Simple repetitive tasks with low potential for quality variation (e.g. typing, clerical, or data entry work), by contrast, do not require extensive talent or education and the reputation score will thus be of lower importance. These tasks are expected to be performed as cheaply as possible, and therefore the price is the deciding factor for choosing the freelancer. In practice, hiring criteria will combine both signals—price and reputation—when choosing a freelancer and the decision is based on a deliberation between the two.

The extent to which employers can weigh the signal of reputation and price depends on the amount of information that is available to the employer during the hiring process (Spence 1973). When asymmetry is low, employers have enough signals about the freelancer. The decision to hire a freelancer will thus be more equally based on the required price along with the signaled quality via the reputation score. In a situation with high information asymmetry, however, employers must rely on the most relevant signal for the advertised project: in case of simple projects, selection is guided predominantly by price; for complex projects, selection is guided predominantly by the reputation score.

### 2.3 The (unintended) consequences of reputation systems

Reputation systems have been previously equated with the &quot;invisible hand&quot; that rewards good producers while punishing poor ones (Goldman 2011: 53). Indeed, research shows that reputation systems can offset social biases among a large heterogeneous and independent population of users at online marketplaces (Abrahao et al. 2017; Cui, Li and Zhang 2017). However, processes of reputation formation can also have unintended consequences that might be socially and individually undesirable (Grow and Flache, 2019). For example, Kas, Corten and van de Rijt (2019) have shown that since reputation scores and reviews at online marketplaces are obtained only after completed interactions, initial differences between users in the probability to be selected as transaction partner are crucial. The reason is that early differentials in success are likely to multiply as chances of obtaining more projects in the future increase (see Bol, de Vaan and van de Rijt 2018; Squazzoni and Gandelli 2012; Yoganarasimhan 2013) and result in a significant cumulative advantage over time (Merton 1968; DiPrete and Eirich 2006). Such dynamics are likely to produce core-periphery divides between freelancers that are likely to grow over time.

The problem is particularly severe for newcomers to OLM platforms, who—by definition—have no algorithmically generated reputation. Hence, the only way in which they can convey information about their abilities is by self-portrayals in their profile (D&#39;Cruz and Noronha 2016), personal branding (Vallas and Christin 2017), educational and employment credentials (Gandini 2016), and digital skill certificates (Kässi and Lehdonvirta 2018). These signals of quality are, however, easy to fake and therefore are often seen as not trustworthy by employers. Reputation scores, by contrast, are often considered a form of a costly signal that is more difficult to fake (Zahavi 1995), given that accruing high reputation scores requires large amounts of time and energy, as well as the delivery of high-quality work (Gintis et al. 2001). The existence of several competing OLM platforms further exacerbates the perceived cost of the reputation score, as reputation accrued on one platform is not transferable to other platforms (Kokkodis &amp; Ipeirotis 2016).

Empirical research shows that in anonymous online markets with a reputation system, buyers will trust and pay sellers with a good reputation more (Diekmann et al. 2014). The work of Pallais (2014) illustrates this with experimental evidence. Freelancers with no prior work experience who received the experimental treatment—being hired for a project and obtaining positive feedback—almost tripled their relative income in comparison to the control group. As a result, reputation scores have been identified as one of the crucial features of OLM platforms (see Wood et al. 2018). One of the coping strategies that freelancers use to accrue an initial reputation is selling labor at a substantially lower cost to attract the first clients (Gandini, Pais and Beraldo 2016). Furthermore, empirical research has shown that poor reputation leads to lower bid amounts in auctions on the side of workers, in order to compensate for the perceived disadvantage due to a low reputation score (Diekmann et al. 2014). This finding is in line with previous studies (e.g. Kollock 1999; Diekmann et al. 2009; Dellarocas 2003; Resnick et al. 2006) and highlights the fact that participants in OLMs have direct financial incentives to invest in a good reputation.

Establishing an initial reputation on a platform is harder for some workers than others. Freelancers from less developed countries are disadvantaged relative to those from developed countries in terms of their likelihood of being hired (Agrawal, Lacetera, and Lyons 2013). Building up reputation is contingent on spending a significant amount of time on unpaid work such as looking for tasks, taking qualification tests, and researching clients. The International Labour Organization (ILO) estimates that &quot;for every hour of paid work, [freelancers at OLMs] spent 20 minutes performing unpaid work&quot; (Berg et al. 2018: 4). Such requirements segment the workforce into freelancers who can afford undertaking a period of low or unpaid work and those who are dependent on earning a steady income to make ends meet—a group of workers who are already in an insecure position in regular labor markets (Standing 2011). This presents an important entry barrier for workers with precarious backgrounds or from vulnerable geographies (e.g. the global South), who might not be able to dispense of such investment in terms of time and resources for building up their reputation (Beerepoot and Lambregts 2014). As a consequence, OLMs potentially reproduce inequalities present in offline labor markets and produce unfair outcomes that disproportionately favor already successful applicants. Importance of initial differences for obtaining a first project to build reputation and penalization of low (or no) reputation by lower payments introduces an important feedback loop that helps successful workers and further disadvantages workers from vulnerable social and economic circumstances.

The literature underlines the vast differences in the experiences of workers with OLMs. On the one hand, evidence of personal success of workers from the global South and low-income countries shows the possibility of talented workers to realize their potential on the global scale and earn wages far above the level of their home country (Lehdonvirta et al. 2018). On the other hand, testimonies of pay below the livable minimum, high work pressures due to easy replaceability of workers, and a lack of workers&#39; voice highlight structural problems in how work is distributed at online platforms (see Lehdonvirta et al. 2018; Caraway 2010). As Graham, Hjorth and Lehdonvirta (2017: 135) demonstrate, &quot;there are important and tangible benefits for a range of workers, [but] there are also a range of risks and costs that unduly affect the livelihoods of digital workers.&quot; It therefore is crucial to uncover the potential underlying mechanisms that segment the OLMs into winners and losers. Aside from the ongoing pressures for policy response from national and international actors (see ILO 2018), platform reputation and skills are crucial individual resources in the platform economy and a direct source of income, security, and marketplace bargaining power (Wood et al. 2018). Despite its global presence, the setup of OLM platforms have the potential to preserve already existing disparities and social divides in access to labor.

### 2.4 Modelling OLM complexity

As the foregoing discussion highlights, reputation systems may yield efficiency benefits for employers in OLM contexts, because they can reduce problems that arise from information asymmetries. Yet, they might also create new inefficiencies, by disconnecting the allocation of tasks to workers from objective quality differences. So far, it is poorly understood how likely it is that such inefficiencies emerge, and which specific characteristics of existing reputation systems might make this emergence more likely. One reason for this is that the self-reinforcing dynamics that reputation systems can create are often difficult to grasp (Grow and Flache 2019).

To address this issue, in this paper we develop an agent-based computational model of reputation systems in OLMs, that we inform with web-scraped data from an undisclosed OLM platform (see more on data collection in the Ethics and Data Availability section). With this approach, we explicitly model the decision processes that underlie the behavior of both employers and freelancers as a dynamic social system. This approach is fitting, because for freelancers the likelihood of succeeding in auctions is dependent on their previous success and the reputation of other employees in the pool of applicants. This path dependence is difficult to explore with empirical data, since different dynamics may lead to the same outcome. Systematic simulations allow us to re-run the experiment and explore the outcomes of potential alternative worlds, not only in terms of their results but also the variability of the results across different assumptions about individual behavior. Moreover, some of the important aspects of the social processes of interest are not directly observable––such as the extent of information asymmetry at a specific OLM platform. Social simulation therefore offers a possibility to explore large range of implications of different assumptions and their outcomes to establish bounds on the potential effect that reputation systems can have on freelancers&#39; success under different conditions of information asymmetry.

## 3. Model

### 3.1 Agent-based computational modelling

We propose an agent-based computational model that simulates recruiting processes at OLM platforms. The model is a stylized representation of an OLM, and therefore does not aim to explicitly model any specific platform. However, as it is set up, we argue that our model subsumes the most prominent OLM platforms (e.g. Freelancer, Upwork, or Truelancer) and our experiments yield results that are directly applicable to the context of these platforms. Hence, the results that our model generates can be considered as hypotheses, that can be assessed with appropriate data from actual OLM platforms, as we describe in more detail below. The code for the model, figures, and analyses can be obtained from a GitHub online repository, together with a more detailed model description (_link placeholder, to be added after peer review_).

### 3.2 Modelling the recruiting at OLMs

The model contains two types of agents: employers (; from ) and employees (; from ; also referred to as freelancers or workers), and jobs (; from ; also referred to as projects). The aim of employers is to find the most fitting employees for their projects. The aim of employees is to find as many projects to work on as possible. The ratio of employers and employees stays constant during a simulation run and we carried out a sensitivity test to verify that the results are not dependent on this assumption. The model proceeds in discrete time steps and closely mirrors progression in recruitment on OLM platforms. In each time step a set of actions take place which are shown in Figure 1.

[Figure 1 about here]

Each employee can be described by a set of characteristics, namely their true talent score (; unobserved by the employer), the number of previously finished jobs (), and their earnings obtained on the platform (). Employees&#39; talent () is initialized as coming from a uniform distribution between 1 and 100. To make the context of the OLM realistic, we assume that the platform has been established for some time already. This means that there is a mix of employees in terms of the jobs they have received in the past and the reputations they have developed based on this. To model the distribution of the number of jobs that employees have received before, the number of previously received jobs comes from a random exponential distribution (with ; rounded down to the nearest integer) where the majority of users received small number of jobs and a minority of users received a large number of jobs (see Gandini, Pais and Beraldo 2016). Earnings are initially set to zero, in order to track how much a given freelancer was able to earn since the start of the simulation.  Employers do not have any characteristics. Jobs differ in complexity () and price (; positively correlated with  as more complex jobs are likely to be more expensive; Agrawal et al. 2015) and are randomly assigned to employers.

Employee&#39;s talent and the number of finished jobs are aggregated into a reputation score (). Inspired by the insights from previous research (Gandini 2016; Yoganarasimhan 2013), the reputation score is calculated at the end of each time step as

 (Eq. 1)

where  is a normalizing constant to scale the result between 1-100, and  and  are standardized by subtracting the respective mean and dividing them by the respective standard deviation in the employee population, yielding  and . In short, a freelancer&#39;s reputation is proportional to their (latent) talent—representing their ability to provide high-quality service—and the number of finished projects.

Employee&#39;s values on and  are assigned when they enter the simulation (as discussed below), followed by calculating the initial reputation . Their reputation then changes over the course of the simulation as a result of receiving new jobs. Table 1 provides an overview of all agent variables and Table 2 provides an overview of all other model parameters.

[Table 1 about here]

The model proceeds as follows: In each iteration, (1) one employer creates a job and employees have an opportunity to apply. Each job receives an application from at least 2 and up to 10 randomly chosen (uniform distribution) employees (, from  ). (2) Employees submit their bids (; bid of employee  on job )—a price for which they are willing to perform the advertised task (see details in section _3.2.1 Employees&#39; bidding strategy_). (3) After all bids are submitted, the employer evaluates each employee&#39;s bid and their respective reputation and constructs a selection score for each bidding employee, mirroring the best match based on the available information (see details in Sect. &#39;3.2.2 Employers&#39; selection and information asymmetry&#39;). (4) The employee with the highest selection score is selected and awarded the job. After finishing the transaction, the reputation () of the winning employee is recalculated and the process starts over until a prespecified number of jobs () jobs is finished.

[Table 2 about here]

### 3.2.1 Employees' bidding strategy

Our model distinguishes between the two possible auction formats that platforms typically employ—sealed vs. open bid auction (see Hong, Wang and Pavlou 2016). The sealed bid auction format does not permit employees to see each other&#39;s bids, hence they decide about their bid only using the information about the job they are bidding on. In the sealed bid auction employees submit bids to a project (step 2 in Figure 1) as

, where  (Eq. 2)

Employee&#39;s bid on project  consists of the project&#39;s price  and a random noise , representing variation around this price given unobserved employee characteristics. The employee does not need to separately take into account the project&#39;s complexity, as this is already encoded in its price.

Under the open bid auction format, employees bidding on a project are free to observe the bids previously submitted by other applying workers. As a result, we assume that employees take this additional information into consideration when deciding about their own bid (see Zhang &amp; Liu 2012; Liu et al. 2015). The first bidding employee applies the heuristic used with sealed bid auctions (Eq. 2) since they are the first to bid and there is no other information to adjust to. Subsequent bidders will use the additional information provided by previous bidders:

, where  (Eq. 3)

Thus, applicants take the average bid of all previous bidders as a starting point (first term in Eq. 3) and adjust this value by taking the difference between their own reputation and the average reputation of previous bidders (second term in Eq. 3). The reputation adjustment is weighted by  which represents agent&#39;s responsiveness to such information. The intuition behind this heuristic is that applicants with lower than average reputation will try to compete by compensating their reputation with a lower price, whereas applicants with high reputation will ask a higher price due to their verified status on the platform. There is a minimum and maximum bid limit on each project, set by the interval . After winning a project, the employee receives the bid amount () to their earnings ().

### 3.2.2 Employers' selection and information asymmetry

An employer&#39;s decision to select the winning employee depends on the job complexity (, see Lehdonvirta, Barnard, Graham and Hjorth 2014). For more complex jobs, employers require workers with better reputation, as the quality of the product is crucial and reputation systems serve as a useful signal. For simpler jobs, employers are not as interested in reputation as they are interested in the price for which the employee is willing to perform the task. Accordingly, employers combine these two factors––bid and reputation––and weigh each input according to the complexity of the task when selecting from the available workers. The precise way in which the information about reputation and bids translates into decision strategies, however, depends on the amount of information asymmetry () that exists on the platform. This is shown in Figure 2a, where the level of information asymmetry changes the slope of a logistic function that determines the weighting of information by the employer. Under low information asymmetry (represented by low values of ) , the employer relies equally on both, reputation and bid, as there is abundant information to use in a freelancer&#39;s evaluation. On the contrary, under high information asymmetry (represented by high values of ), the employer relies on the most relevant information at hand for the project: for simple jobs, this the height of a worker&#39;s bid, but for complex jobs, this is the worker&#39;s reputation. The coefficients depicted in Figure 2 are calculated as

 (Eq. 4)

and depend on two inputs:  which is the information asymmetry parameter and  which is a value of job complexity (centered around 50). For example (see Figure 2b), if an employer offers a job with complexity of 75 (and ), approximately 82% of the decision is based on an employee&#39;s reputation and 18% on their bid.

[Figure 2 about here]

 Each applying employee is evaluated based on an individual selection score, which uses  as a weight to combine information about the employee&#39;s reputation () and bid (). The selection score for employee  for project  is calculated as

 (Eq. 5)

The selection score summarizes an employer&#39;s selection heuristic to choose the employee, given their reputation and bid, for a specific project, given its complexity. In the final step, the employee with the highest selection score is selected as a winner.

### 3.3 Experimental set-up and outcome measures

The number of employees and employers is fixed at 30 and 120 respectively. Each simulation run consists of 200 jobs being auctioned and assigned. The experimental parameters are the information asymmetry and auction type: The information asymmetry parameter  is manipulated between 0.001 and 0.4 in increments of size 0.005 (outside this interval the function barely changes its slope), while auction type is varied between open and sealed in a full factorial design with 160 experimental conditions. All results are based on averages obtained from 50 independent simulation runs per condition, totaling 8000 simulation runs.

We investigate two main measures: First, we focus on employee&#39;s earnings () at the end of each simulation run to evaluate their economic success.  Second, we look at the number of received jobs (). As some workers already have an initial number of jobs at the start of a given simulation run, the value of interest is the number of jobs received since the start of the simulation, which is given by .

For ease of presenting the results, each worker is categorized into one of three reputation groups. If their initial reputation is below 33, they are categorized as &quot;low&quot;, between 33-67, they are categorized as &quot;medium&quot;, and above 67, as &quot;high&quot;.

We measured the inequality in employee&#39;s monetary outcomes () as the ratio of average earnings () of the high reputation group over those of the low reputation group (and  respectively). Similarly, we measure inequality in the average number of jobs received () as the ratio of the number of jobs  () that the high reputation group received over that of the low reputation group (and  respectively)

   (Eq. 6a)

 (Eq. 6b)

High  values show large distances between the reputation groups, and thereby indicate large disparities in access to work and earnings of workers with different reputations. For example,  means that freelancers with a high reputation earned twice as much per job as freelancers with a low reputation.

 Finally, in order to gauge the extent of a core-periphery divide, we measure the percentage of workers who did not obtain any projects during a simulation run. We analyze their average reputation to see whether a freelancer&#39;s ability to thrive is related to their reputation. If the average reputation of workers who did not obtain any projects is low, we conclude that low reputation workers (and in particular newcomers) face barriers in access to work due to the reputation system.

### 3.4 Model validation data

Validation with empirical data provides some evidence as to whether the model represents the phenomenon that we aim to model (see Ormerod and Rosewell 2009). The model formulates two agent-level rules that we validate with two web-scraped datasets. Data were collected from an undisclosed OLM platform (see section Ethics and Data Availability), during two days in November 2018. The first dataset, focusing on employee decisions about bids, contains data on 3,434 bids from 192 randomly selected projects across all job categories. The second dataset, focusing on employer selection strategies, contains 879 bids from 55 awarded projects labelled as &quot;typing job&quot; and 575 bids from 52 awarded projects labelled &quot;Python job&quot;, totaling 1,454 observations.

## 4. Results

Our results are split into three sections: First, we start by validating our assumption about employer and employee behavior with web-scraped data. Second, we focus on the average earnings and the number of jobs that our artificial employees received across simulation runs, followed by a quantification of the inequality that emerged under various conditions of information asymmetry and auction type. Finally, we investigate the access to work by looking at how many and which freelancers have not received work across simulation runs.

### 4.1 Validating model assumptions

The first rule states that employees make decisions about bids based on available local information and adjust their bids in order to increase the chances of obtaining projects (see Eq. 2 and 3). Workers with high reputation ask a higher price for their work, while workers with lower reputation compensate their reputation with a lower bid. Bidding behavior is therefore correlated with reputation within each auction. In line with this assumption, the empirical data show a significant positive association between reputation and bids. One standard deviation increase in reputation is associated with approximately 0.1530 standard deviation increase in bids (CI95: 0.1361-0.1699, _p-value_ \&lt; 0.001).

The second agent-level rule states that employers adjust their selection strategy based on information asymmetry of the platform and advertised project complexity. Although we cannot directly measure information asymmetry of a platform, we can compare job categories that are evidently different in their complexity. For simple jobs, we use the category of typing jobs, as these jobs are highly repetitive, cognitively undemanding, and with low variation in quality. For complex jobs, we chose jobs containing use of the Python programming language, as programming is relatively varied from case-to-case, demanding, and quality of the product is highly dependent on freelancer&#39;s quality. The validation is facilitated by a comparison of coefficients in logistic regression models predicting the winner of the auction for each job category shown in Table 3.

[Table 3 about here]

In agreement with Eq. 4, empirical data show that the probability of winning a project decreases with higher bids; although there is a difference in estimated effects, this negative relationship does not significantly differ between the two job categories. Reputation, on the other hand, increases the probability of winning a project. Moreover, the estimated effects are significantly different between job categories; the probability of winning is less dependent on the reputation for simple and more for complex projects—in other words, reputation matters more for complex jobs. These findings suggest that our assumptions about employee selection are plausible in reality and the heuristics represented in the social simulation can be considered credible representation of the investigated phenomenon.

### 4.2 Earnings and job access

Success on OLM platforms can be defined by the volume of jobs and earnings that a freelancer is able to obtain. Figure 3 plots the average earnings and average number of received jobs by level of information asymmetry on the platform along with our inequality measure _K_, which summarizes the differences in the average pay per job received between high and low reputation freelancers (see Eq. 6a and 6b). The results in Figure 3 show that recruiting in the simulated OLMs leads to outcomes that considerably favor the high reputation freelancers: regardless of the auction format and level of information asymmetry, workers with high reputation systematically receive higher remuneration and more projects to work on. Success in receiving jobs is dependent on reputation; however, success further inflates worker&#39;s reputation in a positively self-reinforcing loop, thereby improving their chances of receiving more work in the future.

[Figure 3 about here]

According to the simulation model, information asymmetry influences the distribution of earnings and jobs on OLM platforms. Lower information asymmetry—i.e. the more information employers have—accentuates the differences in success between low and high reputation workers both in terms of earnings and number of jobs received. The results in panel (b) of Figure 3 show that under low information asymmetry, employees with high reputation can on average reach as many as 10-times the jobs as the low reputation group. In addition, high reputation employees are on average likely to gain as much as eight- to nine-times the earnings as members of the low reputation group. On the contrary, downward sloping lines in panel (b) show that higher levels of information asymmetry moderate the extent of inequality of OLM outcomes.

In open bid auctions, with increasing information asymmetry distance between high and low reputation workers decreases faster than in sealed bid auctions. The ratio of earnings between high and low reputation groups in open bid auctions becomes as low as 2.5, compared to sealed bid auctions, where it remains as high as 5. Number of received jobs show similar results; under open bid auctions, high reputation workers acquire approximately 1.5-times as many jobs as low reputation employees. Sealed bid auctions gain a lower yet substantial inequality reduction to slightly more than 3-times as many jobs for high rather than low reputation employees.

These results offer evidence to the notion that distribution of earnings and work at OLM platforms is influenced by the recruiting system based on algorithmically generated reputation score. Although the general knowledge considers reduction of information asymmetry desirable in business exchanges, it must not necessarily apply to OLM platforms. Lower levels of information asymmetry at OLM platforms can sway employers to start biasing towards freelancers with the highest reputation score, blocking out access to work for other freelancers.

### 4.3 Emerging barriers at OLMs

At the end of each simulation run, a number of freelancers were left without receiving any work (regardless of what they started with). In Figure 4, we plot the size of this group (% of employees) and their average reputation. If jobs were awarded at random, each freelancer would receive on average 1.67 jobs. However, the level of information asymmetry directly influences the proportion of workers who received work during a simulation run. Under low information asymmetry, regardless of the auction type, 37%-41% of workers did not obtain any project to work on. Increasing the information asymmetry, this number diminishes rapidly and then levels off at around 20% for open bid auctions and 28% for sealed bid auctions.

[Figure 4 about here]

Combined with results from Figure 3, the core of the workforce that repeatedly obtains jobs is relatively small and concentrated mainly in the ranks of high reputation workers. The average reputation of workers who fail to obtain work over a simulation run also changes with information asymmetry. Low information asymmetry leads to a situation in which those who struggle to obtain work are mostly workers with low reputation (hence also newcomers). With increasing information asymmetry, we observe a diverging trend between open and sealed bid auctions. Under open bid auctions, the average reputation of freelancers without work converges to the median reputation of all workers (shown as the dashed line). The probability to obtain work, therefore, becomes less dependent on freelancers&#39; reputation and more equal among all workers. On the contrary, under sealed bid auctions, the average reputation of freelancers without work remains relatively stable with varying levels of information asymmetry. This shows that redistribution under sealed bid auctions is less dependent on information asymmetry, but freelancers&#39; success is inherently more dependent on their reputation score.

On the whole, open auctions seem to generate fairer outcomes than sealed auctions for the accessibility to work, not only for established workers, but also for newcomers. Open bid auctions maximize the redistribution of work to the largest proportion of the workforce and democratize access to work away from algorithmically generated reputation scores. Sealed bid auctions are much less accessible as they redistribute work to smaller a number of workers with high reputation. To conclude, based on the simulation results, low levels of information asymmetry do not offer optimal results when evaluated through their ability to impartially redistribute work among freelancers.

## 5. Discussion

Our simulation results demonstrate that reputation systems can play a crucial role in determining the outcomes of OLM platforms. We explored the extent to which information asymmetry may play a role in shaping these outcomes.As we show, information asymmetry influences the extent to which the reputation system may lead to inequality between freelancers. Diminishing information asymmetry on OLM platforms might bring about greater inequality, while higher information asymmetry generates more equal outcomes. This finding is essential, as platforms often go to great lengths to diminish information asymmetry by any means possible—e.g. platform-facilitated tests, premium user badges, or mandatory fields in extensive profiles. As the simulation shows, such measures might, contrary to their intention, be a cause for higher inequality on the platform. As a result, these measures indirectly shift the burden of the transaction from employers to freelancers, as they segment the online workforce into core and periphery—those whose success is driven by their high platform reputation and those who are left to compete for poorly paid projects or fail to obtain projects altogether.

As the reputation score heavily influences freelancer&#39;s future success on the platform, the setup and fine-tuning of the reputation score can be considered a crucial feature of OLM platforms. Reputation scores are not a perfect measure of a person&#39;s skills and capability (Gandini 2016; D&#39;Cruz and Noronha 2016; Caraway 2010) and therefore it is problematic that such scores, as a means of algorithmic control, can account for such a large part of a worker&#39;s success. On the one hand, reputation systems are necessary for overcoming the social dilemma of coordinating work between distant and anonymous parties, serving as a signal for employers to make selection decisions among many workers online. On the other hand, however, we show that reputation systems are a source of inequality that can strongly influence the distribution of jobs in OLMs.
 The success of freelancers on OLM platforms hinges on the ability to invest in building a reputation—be it working for very low pay or performing jobs that are below a worker&#39;s actual skill level (Gandini 2016). Since reputation scores and reviews are obtained only after completing some work on a given platform, initial differences between users play a major role in freelancers&#39; success. Workers with strong academic credentials, from developed countries, and previous work experience are likely to have a higher probability of obtaining their first job, even without a reputation score (Agrawal, Lacetera, and Lyons 2013, Beerepoot and Lambregts 2014). The existence of numerous online markets further exacerbates this problem, as a reputation accrued on one platform is not transferable to another (Kokkodis &amp; Ipeirotis 2016). As a result, workers have to repeatedly bear the cost of generating a good reputation to access various online markets. Such differentials are likely to snowball into a Matthew effect (Merton 1968) where the already successful get richer, offering only little opportunity for success to others. OLM platforms may thus reproduce existing social and economic disparities from the offline world.

Our simulation findings highlight risks emerging in the literature about freelance workers undertaking extremely long working hours for relatively low pay, which often results in overwork, sleep deprivation, and exhaustion (Wood et al. 2018). Such behavior may likely stem from the necessity to receive positive reviews to be competitive for better paying projects. Especially in a context where it is easy to dispose of one worker and hire another—which is likely the situation on OLMs—workers involuntarily become strongly entrepreneurial under pressure to protect their interests and settle for substantially lower pay (Holtgrewe 2014; Rosenblat, Kneese &amp; boyd 2014). As such, digital platforms are enablers of virtual exploitation of geographical differences in skills and labor costs (Lehdonvirta 2016) and thus mirror the existing global inequalities. Although OLMs were initially considered &quot;&#39;borderless&#39; virtual business platforms&quot; (Friedman 2005) that were to globally equalize access to labor, our simulation results along with previous research show that recruiting at OLMs based on algorithmically generated reputation can give rise to new and previously unknown barriers in access to labor that needs to be scrutinized further.

## 6. Conclusions

In this paper, we have introduced a novel tool—agent-based modeling—that can be used to explore many issues occurring on OLM platforms either prior to or in concert with the use of traditional methodologies and new data sources. We have demonstrated this process through a systematic simulation experiment that shows how such modeling can provide further insight and new ideas for investigation and thus widen the focus of the ongoing research.

We have demonstrated that commonly used reputation systems create segmented core-periphery outcomes and shown that worker&#39;s ability to obtain jobs on OLM platforms is closely tied to their reputation score. The extent of inequality produced at the OLMs is dependent on the level of information asymmetry at the platform. Information asymmetry is therefore demonstrated as one of the mechanisms that explain the two-fold nature of reputation systems: on the one hand, reputation systems assist in overcoming the information barriers in hiring online; while, on the other, they channel resources to freelancers with the highest reputation score. Diminishing information asymmetry, although widely considered a desirable aim, can in its extreme create exceptionally unequal outcomes, where high reputation workers obtain disproportionately large part of the resources redistributed on OLM platforms.

## Author Information

**Martin Lukac** (martin.lukac@kuleuven.be) is a PhD student at the Centre for Sociological Research at KU Leuven. His field of research revolves around social research methods and computational social science. In his PhD, Martin uses agent-based modeling, network analysis, and advanced statistical modelling to study segmentation in online and offline labor markets.

**André Grow** (grow@demogr.mpg.de) is a Research Scientist in the Laboratory of Digital and Computational Demography at the Max Planck Institute for Demographic Research. His research interests lie in family sociology, social stratification, migration, and agent-based computational modeling.



## Ethics and Data Availability

The empirical data that we used in this study is based on information from a popular online labor market platform, which is publicly available (i.e., the information is visible to all site visitors without the need to subscribe or log in to the platform). While conducting this study, we were careful to collect data in an ethical manner. First, we made sure to respect the platforms&#39; constraints as to which part of its webpage could be accessed by web crawlers (as defined in its robots.txt file). Second, to impose minimal load on the platform&#39;s servers during our crawls, we minimized our data collection whenever possible. Third, to ensure the privacy of the platforms&#39; users, we did not collect any identifying information. Finally, to prevent biasing the competition between different platforms, we decided to not disclose the name of the platform from which we collected the data and to not make the dataset openly available. However, to ensure reproducibility and transparency, we are open to sharing the data for scientific purposes under controlled conditions with an accompanying letter from an academic institutional review board. For these purposes, please contact the corresponding author.



## Software Information

We implemented the model in NetLogo 6.0.4 (Wilensky 1999) and analyzed the results in R 3.5.1 (R Core Team 2012) and RStudio 1.1.456 (RStudio Team 2015) by using the dplyr (Wickham et al. 2018, version 0.7.8) and ggplot2 (Wickham 2016, version 3.1.0) packages. Code for replicating all the figures is available in the online repository.

## Funding

This research is part of the research project &quot;How are social divides produced in contemporary labour markets?&quot;, which is financed by the Federale Wetenschappelijk Onderzoek (FWO) with a project number G071716N and KU Leuven C1 Grant number C14/16/015.

## References

Abrahao, B., Parigi, P., Gupta, A., Cook, K. S. (2017). Reputation offsets social biases on Airbnb. _Proceedings of the National Academy of Sciences_, 114 (37), 9848-9853.

Agrawal, A., Horton, J.,  Lacetera, N., Lyons, E. (2015). Digitization and the Contract Labor Market: A Research Agenda. In A. Goldfarb, S. M. Greenstein, &amp; C. E. Tucker (Eds.), _Economic Analysis of the Digital Economy_, Chicago: The University of Chicago Press, 219-256.

Agrawal, A., Lacetera, N., Lyons, E. (2013). Does Information Help or Hinder Job Applicants from Less Developed Countries in Online Markets? _NBER Working Paper_, No. 18720.

Akerlof, G. A. (1970). The Market for &#39;Lemons&#39;: Quality Uncertainty and the Market Mechanism. _Quarterly Journal of Economics_, 84 (3), 488-500.

Autor, D. H. (2001). Wiring the labor market. _Journal of Economic Perspectives_, 15 (1), 25-40.

Beerepoot, N. and Lambregts, B. (2014). Competition in online job marketplaces: towards a global labor market for outsourcing services? _Global Networks_, 15 (2), 236–255.

 Berg, J., Furrer, M., Harmon, E., Rani, U., Silberman, M. S. (2018). _Digital labor platforms and the future of work: towards decent work in the online world_.  Geneva: International Labor Office.

Bol, T., de Vaan, M., van de Rijt, A. (2018). The Matthew effect in science funding. _Proceedings of the National Academy of Sciences_, 115 (19), 4887-4890.

Caraway, B. (2010). Online labour markets: an inquiry into oDesk providers. _Work Organisation, Labour &amp; Globalisation_, 4 (2), 111-125.

Coleman, S. (1990). _Foundations of Social Theory_. Cambridge: Harvard University Press.

Connelly, B. L., Certo, S. T., Ireland, R. D., Reutzel, C. R. (2010). Signaling Theory: A Review and Assessment. _Journal of Management_, 37 (1), 39–67.

Cui, R., Li, J., Zhang, D. (2017). Reducing Discrimination with Reviews in the Sharing Economy: Evidence from Field Experiments on Airbnb. Available at SSRN: [https://papers.ssrn.com/sol3/papers.cfm?abstract\_id=2882982](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2882982)

D&#39;Cruz, P., Noronha, E. (2016). Positives outweighing negatives: The experiences of Indian crowdsourced workers. _Work organisation, labour &amp; globalisation_, 10 (1), 44-63.

De Groen, W. P., Maselli, I., Fabo, B. (2016). The Digital Market for Local Services: A one-night stand for workers? An example from the on-demand economy. _CEPS Special Report_, No. 133.

Dellarocas, C. (2003). The Digitization of Word of Mouth: Promise and Challenges on Online Feedback Mechanisms. _Management Science_, 49 (10), 1407-24.

Diekmann, A., Przepiorka, W. (2018).  Trust and Reputation in Markets. In F. Giardini and R. Wittek (Eds.), _The Oxford Handbook of Gossip and Reputation_, Oxford: Oxford University Press.

Diekmann, A., Jann, B., Wyder, D. (2009). Trust and Reputation in Internet Auctions. In K. S. Cook, C. Snijders, V. Buskens, and C. Cheshire (Eds.), eTrust: Forming Relationships in the Online World, pp. 139-165, New York: Russell Sage.

Diekmann, A., Jann, B., Przepiorka, W., Wehrli, S., (2014). Reputation Formation and the Evolution of Cooperation in Anonymous Online Markets. _American Sociological Review_, 79 (1), 65-85.

DiPrete T.A., Eirich, G.M. (2006). Cumulative advantage as a mechanism for inequality: A review of theoretical and empirical developments. _Annual Review of Sociology_, 32, 271–297.

Frey, V. and van de Rijt, A. (2016). Arbitrary Inequality in Reputation Systems. _Nature: Scientific Reports_, 6, Article number: 38304.

Friedman, T. (2005). _The world is flat: a brief history of the twenty-first century_. New York: Farrar, Straus and Giroux.

Gandini, A. (2016). _The reputation economy: understanding knowledge work in digital society_. London: Palgrave Macmillan.

Gandini, A., Pais, I., Beraldo, D. (2016). Reputation and trust on online labor markets: the reputation economy of elance. _Work organisation, Labor &amp; Globalisation_, 10 (1), 27-43.

Gintis, H., Smith, E. A., &amp; Bowles, S. (2001). Costly signaling and cooperation. _Journal of Theoretical Biology_, 213, 103-119.

Goldman, E. (2011). Regulating reputation. In H. Masum and M. Tovey (Eds.) _The Reputation Society: How Online Opinions are Reshaping the Offline World_, pp. 51-62, Cambridge, MA: MIT Press.

Gould, R. V. (2002). The Origins of Status Hierarchies: A Formal Theory and Empirical Test. _American Journal of Sociology_, 107 (5), 1143-1178.

Graham, M., Hjorth, I., Lehdonvirta, V. (2017). Digital labor and development: impacts of global digital labor platforms and the gig economy on worker livelihoods. _Transfer: European Review of Labor and Research_, 23 (2), 135–162.

Grow, A., Flache, A. (2019). Agent-Based Computational Models of Reputation and Status Dynamics. In F. Giardini &amp; R.P.M. Wittek (Eds.), _The Oxford Handbook of Gossip and Reputation,_ Oxford: Oxford University Press, pp. 231-249.

Holtgrewe, U. (2014). New new technologies: The future and the present of work in information and communication technology. _New Technology, Work and Employment_, 29 (1), 9-24.

Hong, Y., Wang, C., Pavlou, P. A. (2016). Comparing Open and Sealed Bid Auctions: Evidence from Online Labor Markets. _Information Systems Research_, 27 (1), 49-69.

Horton, J. J. (2010). Online labor markets. _The 6th Workshop on Internet and Network Economics_, 515-522.

ILO (2018). _Job quality in the platform economy_. International Labour Organization, Issue Brief #5. Available online at [https://www.ilo.org/wcmsp5/groups/public/---dgreports/---cabinet/documents/publication/wcms\_618167.pdf](https://www.ilo.org/wcmsp5/groups/public/---dgreports/---cabinet/documents/publication/wcms_618167.pdf)

Jin, G., &amp; Kato, A. (2006). Price, Quality, and Reputation: Evidence from an Online Field Experiment. _The RAND Journal of Economics_, 37 (4), 983-1004.

Kas, J., Corten, R., &amp; van de Rijt, A. (2019). The role of reputation systems in digital discrimination. SocArXiv, [https://doi.org/10.31235/osf.io/85cze](https://doi.org/10.31235/osf.io/85cze)

Kässi, O., Lehdonvirta, V. (2018). Online labor index: Measuring the online gig economy for policy and research. _Technological Forecasting and Social Change_, 137, 241-248.

Kokkodis, M., Ipeirotis, P. G. (2016). Reputation Transferability in Online Labor Markets. _Management Science_, 62 (6), 1687-1706.

Kollock, P. (1999). The Production of Trust in Online Markets. In E. J. Lawler and M. W. Macy (Eds.), _Advances in Group Processes_, pp. 99-123, Amsterdam: JAI Press.

Lehdonvirta, V. (2016). Algorithms that Divide and Unite: Delocalisation, Identity and Collective Action in &#39;Microwork&#39;. In Jorg Flecker (Ed.), _Space, Place and Global Digital Work_, pp. 53-80, London: Palgrave Macmillan UK.

Lehdonvirta, V., Barnard, H., Graham, M., Hjorth, I. (2014). Online labor markets — leveling the playing field for international service markets? _Presented at IPP2014: Crowdsourcing for Politics and Policy_, 25-26 September 2014, Oxford, UK.

Lehdonvirta, V., Hjorth, I., Graham, M., Barnard, H. (2015). Online labor markets and the persistence of personal networks: Evidence from workers in southeast asia. _Presented at ASA 2015_. Oxford: Oxford University.

Lehdonvirta, V., Kässi, O., Hjorth, I., Barnard, H., Graham, M. (2018). The Global Platform Economy: A New Offshoring Institution Enabling Emerging-Economy Microproviders. _Journal of Management_, 45 (2), 567–599.

Liu, D., Brass, D. J., Chen, D. (2015). Friendships in Online Peer-to-Peer Lending: Pipes, Prisms, and Relational Herding. _MIS Quarterly_, 39 (3), 729-742.

Luca, M. (2017). Designing Online Marketplaces: Trust and Reputation Mechanisms. _Innovation Policy and the Economy_, 17, 77-93.

Merton R.K. (1968). The Matthew effect in science: The reward and communication systems of science are considered. _Science_, 159, 56–63.

Ormerod P., Rosewell B. (2009). Validation and Verification of Agent-Based Models in the Social Sciences. In F. Squazzoni (Ed.) _Epistemological Aspects of Computer Simulation in the Social Sciences_, 117-129, EPOS 2006. Lecture Notes in Computer Science, Vol 5466. Berlin: Springer.

Pallais, A. (2014). Inefficient Hiring in Entry-Level Labor Markets. _American Economic Review_, 104 (11), 3565-3599.

R Core Team (2012). _R: A language and environment for statistical computing_. R Foundation for Statistical Computing, Vienna, Austria.

Resnick, P., Zeckhauser, R., Friedman, E., Kuwabara, K. (2006). Reputation Systems. _Communications of the ACM_, 43 (12), 45-48.

Rosenblat, A., Kneese, T., boyd, D. (2014). _Workplace Surveillance_. Data &amp; Society, Prepared for Open Society Foundations&#39; Future of Work Commissioned Research Papers. Available at http://dx.doi.org/10.2139/ssrn.2536605.

Rosenblat, A. and Stark, L. (2016). Algorithmic Labor and Information Asymmetries: A Case Study of Uber&#39;s Drivers. _International Journal of Communication_, 10, 3758–3784.

RStudio Team (2015). _RStudio: Integrated Development for R_. RStudio, Inc., Boston, MA.

Snijders, C., Matzat, U. (2018). Online Reputation Systems. In F. Giardini and R. Wittek (Eds.), _The Oxford Handbook of Gossip and Reputation_, pp. 479-496, Oxford: Oxford University Press.

Snir, E. M., Hitt, L. M. (2003). Costly Bidding in Online Markets for IT Services. _Management Science_, 49 (11), 1504-20.

Spence, M. (1973). Job market signaling. _The Quarterly Journal of Economics_, 87 (3), 355–374.

Squazzoni, F., Gandelli, C. (2012). Saint Matthew strikes again: An agent-based model of peer review and the scientific community structure. _Journal of Informetrics_, 6 (2), 265–275.

Standing, G. (2011). _The Precariat: The New Dangerous Class_. London: Bloomsbury.

Takács, K., Squazzoni, F. (2015). High Standards Enhance Inequality in Idealized Labor Markets. _Journal of Artificial Societies and Social Simulation_, 18 (4).

Upwork and Freelancers Union (2018). _5th Annual Report: Freelancing in America 2018_. Available online [https://www.upwork.com/i/freelancing-in-america/2018/](https://www.upwork.com/i/freelancing-in-america/2018/)

Vallas, S. P., Christin, A. (2017). Work and Identity in an Era of Precarious Employment: How Workers Respond to &quot;Personal Branding&quot; Discourse. _Work and Occupations_, 45 (1), 3–37.

Wickham, H. (2016). _ggplot2: Elegant Graphics for Data Analysis_. Springer-Verlag New York.

Wickham, H., François, R., Henry, L., Müller, K. (2018). _dplyr: A Grammar of Data Manipulation_. R package version 0.7.8. https://CRAN.R-project.org/package=dplyr

Wood, A., Graham, M., Lehdonvirta, V., Hjorth, I. (2018). Good Gig, Bad Gig: Autonomy and Algorithmic Control in the Global Gig Economy. _Work, Employment and Society_, 33 (1), 56-75.

Yoganarasimhan, H. (2013). The value of reputation in an online freelance marketplace. _Marketing Science_, 32 (6), 860-891.

Zahavi, A. (1995). Altruism as a handicap: The limitations of kin selection and reciprocity. _Journal of Avian Biology_, 26, 1-3.

Zhang, J., Liu, P. (2012). Rational Herding in Microloan Markets. _Management Science_, 58 (5), 892-912.

| **Variable** | **Notation** | **Initial value (distribution)** |
| --- | --- | --- |
| **Employees (i)** |   |   |
| Talent |   |   |
| Jobs received |   |   |
| Earnings |   |   |
| Reputation |   |   |
| Responsiveness to others&#39; bids |   |   |
|   |   |   |
| **Employers (j)** |   |   |
| Selection weight |   |   |
|   |   |   |
| **Jobs (k)** |   |   |
| Complexity |   | ,limited to [1, 100] |
| Price |   |     |

**Table 1** _Overview of all agent variables and their initial values (distributions)_

| **Parameter** | **Notation** | **Experimental value** |
| --- | --- | --- |
| _Experimental parameters_ |   |   |
| Information asymmetry |   | [0.001, 0.4] |
| Auction type |  auction | [Open, Sealed] |
|   |   |   |
| _Fixed parameters_ |   |   |
| Number of Employers |   | 30 |
| Number of Employees |   | 120 |
| Number of Jobs |   | 200 |

**Table 2** _Overview of model parameters and ranges for experimental values_

|   | _Job category: Typing_ | _ _ | _Job category: Python_ |
| --- | --- | --- | --- |
|   | Model 1 | Model 2 | Model 3 |   | Model 1 | Model 2 | Model 3 |
| Bid (standardized) | -0.4609\*\* (0.1641) |   | -0.4084\*\* (0.1564) |   | -0.2154 (0.1634) |   | -0.2882\* (0.1677) |
| Reputation (centered) |   | 0.2670\*\*\* (0.0730) | 0.2647\*\*\* (0.0740) |   |   | 0.4091\*\*\* (0.1188) | 0.4304\*\*\* (0.1202) |
| Intercept | -2.8044 (0.1515) | -2.8205 (0.1533) | -2.9026 (0.1619) |   | -2.3250 (0.1477) | -2.4660 (0.1691) | -2.4963 (0.1730) |
| AIC | 401.13 | 401.63 | 390.24 |   | 351.25 | 338.48 | 337.34 |
| Nagelkerke pseudo R-sq. | 0.0429 | 0.0414 | 0.0812 |   | 0.0069 | 0.0551 | 0.0667 |
| _Note:_ \* p \&lt; 0.1; \*\* p \&lt; 0.05; \*\*\* p \&lt; 0.001 |   |   |   |   |   |   |

**Table 3** _Binary logistic regression model of the probability of winning a project, based on standardized bid and project-centered reputation. Point estimates are in log odds ratios, standard errors in parentheses._
