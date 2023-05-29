# TODO
===
- Change default `StorageClass` from `gp2` to `gp3`
  ```
  kubectl apply -f - <<EOF
  kind: StorageClass
  apiVersion: storage.k8s.io/v1
  metadata:
    name: gp3
  provisioner: kubernetes.io/aws-ebs
  reclaimPolicy: Delete
  volumeBindingMode: WaitForFirstConsumer
  parameters:
    type: gp3
    fsType: ext4
  EOF

  kubectl patch storageclass gp2 \
    -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

  kubectl delete storageclass gp2
  
  kubectl patch storageclass gp3 \
    -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
  
  kubectl get storageclass
  ```

- Ensure `aws_ebs_csi_driver` is working
  ```
  kubectl -n kube-system \
    annotate sa/ebs-csi-controller-sa \
    eks.amazonaws.com/role-arn=arn:aws:iam::<YOUR_AWS_ACCOUNT_ID>:role/ebs-csi-iam-role

  kubectl -n kube-system rollout restart deployment/ebs-csi-controller
  ```