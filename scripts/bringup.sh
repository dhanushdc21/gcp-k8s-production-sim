#!/bin/bash
set -e

echo "=== K8s Production Simulator — Bring Up ==="

echo "Step 1: Setting project..."
gcloud config set project k8s-prod-sim

echo "Step 2: Undeleting Workload Identity Pool..."
gcloud iam workload-identity-pools undelete github-actions-pool   --location=global   --project=k8s-prod-sim 2>/dev/null || echo "Pool already active"

gcloud iam workload-identity-pools providers undelete github-provider   --workload-identity-pool=github-actions-pool   --location=global   --project=k8s-prod-sim 2>/dev/null || echo "Provider already active"

echo "Step 3: Initialising Terraform..."
cd ~/terraform/environments/prod
terraform init

echo "Step 4: Importing WIF pool into state..."
terraform import   module.iam.google_iam_workload_identity_pool.github_pool   projects/k8s-prod-sim/locations/global/workloadIdentityPools/github-actions-pool   2>/dev/null || echo "Pool already in state"

terraform import   module.iam.google_iam_workload_identity_pool_provider.github_provider   projects/k8s-prod-sim/locations/global/workloadIdentityPools/github-actions-pool/providers/github-provider   2>/dev/null || echo "Provider already in state"

echo "Step 5: Applying all infrastructure..."
terraform apply -auto-approve

echo "Step 6: Reconnecting kubectl..."
gcloud container clusters get-credentials prod-cluster   --zone us-central1-a   --project k8s-prod-sim

echo "Step 7: Creating namespaces..."
kubectl create namespace production 2>/dev/null || echo "Namespace exists"
kubectl create namespace monitoring 2>/dev/null || echo "Namespace exists"

echo "Step 8: Installing External Secrets Operator..."
helm repo add external-secrets https://charts.external-secrets.io 2>/dev/null
helm repo update
helm install external-secrets   external-secrets/external-secrets   --namespace monitoring   --set installCRDs=true 2>/dev/null || echo "ESO already installed"

echo "Step 9: Waiting for ESO pods to be ready..."
sleep 30
kubectl apply -f https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/crds/bundle.yaml

echo "Step 10: Creating service account..."
kubectl create serviceaccount f1-app-sa   --namespace production 2>/dev/null || echo "SA exists"

kubectl annotate serviceaccount f1-app-sa   --namespace production   iam.gke.io/gcp-service-account=github-actions-sa@k8s-prod-sim.iam.gserviceaccount.com   2>/dev/null || echo "Annotation exists"

echo "Step 11: Applying SecretStore and ExternalSecret..."
python3 << INNEREOF
secretstore = """apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: gcp-secret-store
  namespace: production
spec:
  provider:
    gcpsm:
      projectID: k8s-prod-sim
      auth:
        workloadIdentity:
          clusterLocation: us-central1-a
          clusterName: prod-cluster
          clusterProjectID: k8s-prod-sim
          serviceAccountRef:
            name: f1-app-sa
"""
externalsecret = """apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: f1-db-password
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: gcp-secret-store
    kind: SecretStore
  target:
    name: f1-db-password
    creationPolicy: Owner
  data:
    - secretKey: password
      remoteRef:
        key: f1-db-password
"""
open("/tmp/secretstore.yaml", "w").write(secretstore)
open("/tmp/externalsecret.yaml", "w").write(externalsecret)
print("YAML files written")
INNEREOF

kubectl apply -f /tmp/secretstore.yaml
kubectl apply -f /tmp/externalsecret.yaml

echo "Step 12: Deploying F1 app..."
cd ~/terraform/apps/f1-telemetry-app
helm install f1-telemetry-app ./helm   --namespace production   --values ./helm/values.yaml 2>/dev/null || helm upgrade f1-telemetry-app ./helm   --namespace production   --values ./helm/values.yaml

echo ""
echo "=== Bring Up Complete ==="
kubectl get pods -n production
kubectl get pods -n monitoring
