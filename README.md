# gke-basic-cluster-deployment
> ✨ Deploy GKE private cluster using terraform and expose an echo server
>
> 🖱️ For Details and components explanation read [A gentle introduction to GKE private cluster deployment](https://www.pistocop.dev/posts/gke_gentle_introduction/)
>
> 🏗️ For production-grade deployments see the official [Terraform Kubernetes Engine Module](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine)

---

## Deploy

### Infrastructure
- Prerequisites 
    - [`terraform`](https://www.terraform.io/)
    - [`kubectl`](https://kubernetes.io/docs/tasks/tools/)
    - [`gcloud`](https://cloud.google.com/sdk/gcloud)
    - [`tfswitch`](https://tfswitch.warrensbox.com/) - optional
- Enable the following GCP APIs using the GCP console [1]
    - Open GCP console -> APIs & Services -> enable APIs and services
    - Enable:
        - Compute Engine API
        - Kubernetes Engine API
- Clone the repo [gke-basic-cluster-deployment](https://github.com/pistocop/gke-basic-cluster-deployment)
- Compile the input variables:
    ```bash
        $ cp iac/variables.tfvars.example iac/variables.tfvars
        $ vi iac/variables.tfvars # replace with your data
    ```
- Deploy the cluster:
    - Replace\set the variables with your data
    ```bash
        # configure gcloud to the desired project
        $ gcloud config set project $PROJECT_ID

        # configure terraform
        $ cd iac
        $ tfswitch
        $ terraform init

        # deploy the GKE pre-requisites
        $ terraform plan -out out.plan -var-file="./variables.tfvars" -var  deploy_cluster=false
        $ terraform apply out.plan
        
        # deploy GKE - can take more than 20 minutes
        $ terraform plan -out out.plan -var-file="./variables.tfvars" -var deploy_cluster=true
        $ terraform apply out.plan
    ```

- Deploy the services into k8s
    - Replace\set the variables with your data
    ```bash
        # set kubectl context
        $ gcloud container clusters get-credentials gkedeploy-cluster --zone $PROJECT_REGION --project $PROJECT_ID

        # create common resources
        $ kubectl apply -f k8s/common

        # deploy the server
        $ kubectl apply -f k8s/gechoserver/

        # wait that the ADDRESS will be displayed - can take more than 10 minutes
        $ kubectl -n dev get ingress -o wide
        NAME          CLASS    HOSTS   ADDRESS          PORTS   AGE
        gechoserver   <none>   *       34.120.114.207   80      67s

        # query the server from internet - can take  more than 10 minutes
        # replace "34.120.114.207" with your address:
        $ curl -XPOST -v http://34.120.114.207/ -d "foo=bar"

        # ~ Congratulation, your server on GKE is up and running! ~
    ```

- Destroy the cluster:
    ```bash
        $ cd iac
        $ terraform destroy -auto-approve -var-file="./variables.tfvars" -var deploy_cluster=true
    ```