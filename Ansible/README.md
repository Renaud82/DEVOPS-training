# Ansible

# Table des matières
I. [Installation](#install)<br />
&nbsp;&nbsp;&nbsp;A. [Création d’une machine cloud ec2](#ec2)<br />
&nbsp;&nbsp;&nbsp;B. [Installation de Jenkins et dépendances](#jenkins)<br />
II. [Build Image](#docker)<br />
III. [Pipeline](#pipeline)<br />
&nbsp;&nbsp;&nbsp;A. [Création des credentials](#credential)<br />
&nbsp;&nbsp;&nbsp;B. [Création du pipeline](#pipelinecreation)<br />
&nbsp;&nbsp;&nbsp;C. [Lancement du pipeline](#pipelinelaunch)<br />
IV. [Ajout de plugin au Pipeline](#pugin)<br />
&nbsp;&nbsp;&nbsp;A. [Trigger GitHub](#trigger)<br />
&nbsp;&nbsp;&nbsp;B. [Embeddable Build Status](#embeddable)<br />
&nbsp;&nbsp;&nbsp;C. [Slack notification](#slack)<br />
&nbsp;&nbsp;&nbsp;D. [Test du pipeline](#test)<br />

## I- Installation <a name="install"></a>
### A – Création d’une machine cloud ec2 (renaud-ec2-prod) <a name="ec2"></a>
![screenshot001](./images/IMG-001.png)
