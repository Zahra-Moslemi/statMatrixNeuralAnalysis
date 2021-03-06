# statMatrixNeuralAnalysis
**************************************************************
# Overview of the statMatrix
**************************************************************
The statMatrix data structure is a standard data matrix structure used by the Fortin Lab. It was designed to provide a standard organization for both neural and behavioral data derived from experimental sessions. Each file contains two workspace variables, 1) the main data structure and 2) column identifiers for the main data structure. The main data structure consists of an NxM double matrix consisting of N rows, determined by the sample rate of the LFP signal for the recording session (standard = 1kHz), and M columnns corresponding to different information sources. For each recording session a separate statMatrix file is produced for each recording source, i.e. tetrode as well as a separate file with containing the behavior data from the session.

For data stored from each recording source, i.e. tetrode, the workspace variables saved in those files are the 'statMatrix' (main data matrix) and the 'statMatrixColIDs' (column identifiers), whereas behavioral data contains the 'behavMatrix' (main data matrix) and the 'behavMatrixColIDs' (column identifiers).

The statMatrix is organized with rows indexed to the LFP sampleRate. This makes it easy to associate spiking activity and behavioral events to LFP signals with minimal loss of precision. As the LFP data is either collected directly at 1kHz/s or downsampled to that frequency, the loss of precision, i.e. associating a spike/event to one ms or another, is trivial, especially since most analysis is done using time aggregated spiking (spk/s).

***************************************************************
# Main Data Structure Organization
***************************************************************
____________________________________________
### statMatrix Columns Organization
____________________________________________
**Sequence Task**
* **Timebin:** Timestamps pulled from the LFP trace
* **LFP Data:** Multiple columns consisting of the Raw LFP trace as well as bandpass filtered traces for band-specific analysis. Each frequency range contains two columns, one indicating the voltage value for that trace e.g. "_RAW" or "_Theta" as well as a column of phase values appended with *"_HilbVals," e.g. "_RAW_HilbVals"* or *"_Theta_HilbVals."* 
* **Unit Data:** Logical vector (there shouldn't be any 2s...) indicating individual unit spiking activity. 1s indicate if the unit spiked during that time bin. 
____________________________________________
### behavMatrix Columns Organization
____________________________________________
**Sequence Task**
* **'Odor\[1-X]'**: Columns with logical 1 indicating when odor was delivered (no flag or indicator when odor presentation was terminated, assume it was at port withdrawal or trial feedback, whichever came first)
* **'Position\[1-X]'**: Columns with logical 1 indicating what sequence position the trial occured during. Indexed with odor delivery.
* **'InSeqLog'**: Column with values of \[1,0,-1]; 1 = InSeq trial, 0 = Nothing/Filler, -1 = OutSeq trial. Use inSeq==1 and outSeq==-1 to create logical trial vectors; use 'trials==(abs(InSeqLogColumn#)==1)' or something like it can be used to pull out trial start indices. Indexed with odor delivery.
* **'PerformanceLog'**: Column with values \[1,0,-1]; 1 = Correct trial, 0 = Nothing/Filler, -1 = Incorrect trial. Can be used like 'InSeqLog' to pull out correct/incorrect trials and/or trial start indices. Indexed with odor delivery.
* **'PokeEvents'**: Column with values \[1,0,-1]; 1 = Port Entry, 0 = Nothing/Filler, -1 = Port Withdrawal. To identify port entry relative to trial start identify the last port entry (PokeEvents==1) prior to odor delivery; likewise to identify port withdrawal identify the first port withdrawal (PokeEvents==-1) following odor delivery.
* **'FrontReward'**: Column with logical 1 indicating when reward was given at the front of the maze.
* **'BackReward'**: Column with logical 1 indiciating when reward was given at the back of the maze.
* **'XvalRatMazePosition'**: Column indexing the rat's position within the maze along the long axis of the maze.
* **'YvalRatMazePosition'**: Column indexing the rat's position within the maze along the short axis of the maze. **NOTE** The motion capture system sample rate is lower than the time bins used to organize the statMatrix (~30Hz vs 1kHz), all non-zero positions are actual position values, position \[0,0] is out of the maze and the rat never went there.

****************************************************************
# Select list of statMatrix Functions
****************************************************************
NOTE Any modifications made to tailor code to processing a different file structure or data set should be saved as a new file and apppropriately named and commented to reflect that.

____________________________________________
### statMatrix Creation
____________________________________________
* **StatMatrixCreator.m**
This is currently the standard function used to create the statMatrix files. It consists of a series of prompts to determine how the data was collected, where it was collected and what experiment the data is from and then organizes the data into the statMatrix format.

____________________________________________
### statMatrix Organization Functions
____________________________________________
* **EpochExtraction.m**:
This function provides an easy way to compile the data from a single session. It uses the OrganizeTrialData_SM and ExtractTrialData_SM functions listed below to extract and organize all the spiking activity and LFP data (currently only from the raw LFP signal column, an updated version is in the works) from a session. **Recommended method for most purposes/collaborators use**

* **OrganizeTrialData_SM.m**:
Code to organize the behavior data into a 1xN structure variable where each index corresponds to a session trial. Compiles information about each trial as subfields at each index and creates a logical vector for that trial period that can be used to extract neural data that occurred during that trial. **Needs to be commented**.

* **ExtractTrialData_SM.m**:
Code to use the trial period logical vector created in OrganizeTrialData_SM.m to extract neural data stored in matrices.

************************************************************************
# List of Suggested Functions/Toolboxes
************************************************************************
* *Plexon Offline Files SDK*: 
Toolbox created by Plexon to analyze .plx files in Matlab. Used in the statMatrix creation. Link [here](https://plexon.com/wp-content/uploads/2017/08/OmniPlex-and-MAP-Offline-SDK-Bundle_0.zip)
* *Circular Statistics Toolbox*:
Toolbox from the matlab file exchange to perform circular (directional) statistics. Used in some statMatrix related analyses. Link [here](https://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox--directional-statistics-)
