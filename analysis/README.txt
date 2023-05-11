README:

NOTE: Tables and Figures refer to the corresponding tables and figures in the paper

EXPERIMENTAL DATA

data.RData contains the explerimental data from the 193 subjects
	cog.measures.orig -- individual differences measures
		aq.total           -- total AQ (as from the autism spectrum quotient) score
		aq.attentionDetail -- scores in the corresponding AQ sub-scale
		aq.attentionSwitch -- scores in the corresponding AQ sub-scale
		aq.communication   -- scores in the corresponding AQ sub-scale
		aq.imagination     -- scores in the corresponding AQ sub-scale
		aq.socialSkill     -- scores in the corresponding AQ sub-scale
		art                -- scores in the Author recognition test 
		crt                -- scores in the Cognitive regflection test
		iq                 -- scores in the Raven’s Progressive Matrices Test 
		rspan			   -- scores in the Reading span test
	data -- subjects' data in the main (atypicality inferences) task in the target with- and without-IR trials; for fillers, see fillers below
		workerid    -- subject IDs
		round       -- experimental session (either 1 or 2)
		order       -- trial order in which a subject saw an experimental item (within an experimental session)
		orderGlobal -- re-coded order;  in which order subjects saw target experimental items (with- and without-IR conditions; excluding fillers) throught two experimental sessions
		condition   -- story conditions (with- vs. without-IR)
		story       -- story topic
		q1          -- answers to the target typicality question (e.g., How often do you think Mary usually eats, when going to a restaurant?; see Table 1)
		q2          -- answers to the explanation question that were annotated (Why did you place the slider in this particular position?; see Table 1)
		annotation  -- annotations of the q2 answers (see Table 2 for annotation categories)
	fillers -- a dataset of subejcts' answers in filler trials


SCRIPTS

cognitive_measures.R -- produces a pairwise correlation plot of individual difference measures (Figure 1) and outputs a descriptive statistics (Table 3)
plot_ratings.R       -- produces the plot as in Figure 2 (Mean typicality ratings in the with-IR condition per annotaion and annotation counts)
model_ratings.R      -- produces the model as in Table 4 (a beta mixed effects regression model of the typicality ratings)
model_annotations.R  -- produces the model as in Table 5 (a logistic mixed effects regression model of whether the atypicality inference was drawn)
groups_of_subjects.R -- calculates the groups of subjects (consistently literal, consistently pragmatic, or inconsistent) and computes the mean typicality ratings per each group and story condition (see Section "Analysis of annotations", the second paragrah)

