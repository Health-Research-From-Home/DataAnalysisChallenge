# Saturn Cloud Environment Setup

This page provides instruction on setting up your Saturn Cloud environment which we will be using during this hackathon.

## Invitation

You will receive an invitation from HDRUK to join Saturn Cloud in approximately a week in advance of the hackathon.

*You must have signed and return the Immersion Week Participation Agreement to HDRUK before you will gain access to Saturn Cloud.*

You should accept the invite which will request that you create a Saturn Cloud account with an associated user name and password.

## Test Run

After completing registration on Saturn Cloud, please follow these instructions to ensure that you are able to set up the correct environment:

1. Log in to [Saturn Cloud](https://saturncloud.io/) using the user name and password you created after accepting the invitation.

2. On the left side menu pane, make sure `Organization` is set to `HDRUK`

  <img src='../images/saturn-user.jpg' width='260'>

3. Under the resources section find: `Roche-Hackathon / ParticipantTemplateCPU`

  <img src='../images/saturn-resources.jpg' width='460'>

If you cannot see the resource on your dashboard try the following link instead:
https://app.community.saturnenterprise.io/dash/o/HDRUK/resources?templateId=03387dcd739a4edab95a43bbd2a5a27e

4. After clicking on this resource open the `manage` tab and scroll down to the `Clone Resource` section and then click `clone as a Python server`.

5. Click the `Start` button - it may take up to 5 minutes for the server to start up.

  <img src='../images/saturn-jupyter.jpg' width='360'>

6. Once it says `running` click the blue Jupyter Lab button.

7. Open a terminal within the web browser

8. Check that your environment is working by running the following commands:

`cd RocheHackathon2024`

`python src/train.py`

9. You should see the baseline model training for 10 epochs and then evaluating (for two separate datasets). Results will be saved in `outputs/`

10. Next in the side-bar open the notebook that is in `RocheHackathon2024/notebooks`. This should give you some idea of the data format which you will use to train and evaluate your neural networks.
