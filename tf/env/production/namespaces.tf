resource "kubernetes_namespace" "api-job-namespace" {
  provider = kubernetes.wbaas-3

  metadata {
    name = "api-jobs"
  }
}

resource "kubernetes_resource_quota" "api-jobs-podquota" {
  provider = kubernetes.wbaas-3

  metadata {
    name      = "api-jobs-podquota"
    namespace = kubernetes_namespace.api-job-namespace.metadata[0].name
  }
  spec {
    hard = {
      pods = 16
    }
    scopes = ["BestEffort"]
  }
}


resource "kubernetes_namespace" "adhoc-job-namespace" {
  provider = kubernetes.wbaas-3

  metadata {
    name = "adhoc-jobs"
  }
}

resource "kubernetes_resource_quota" "adhoc-jobs-podquota" {
  provider = kubernetes.wbaas-3

  metadata {
    name      = "adhoc-jobs-podquota"
    namespace = kubernetes_namespace.adhoc-job-namespace.metadata[0].name
  }
  spec {
    hard = {
      pods = 6
    }
    scopes = ["BestEffort"]
  }
}

resource "kubernetes_namespace" "qs-job-namespace" {
  provider = kubernetes.wbaas-3

  metadata {
    name = "qs-jobs"
  }
}

resource "kubernetes_resource_quota" "qs-jobs-podquota" {
  provider = kubernetes.wbaas-3

  metadata {
    name      = "qs-jobs-podquota"
    namespace = kubernetes_namespace.qs-job-namespace.metadata[0].name
  }
  spec {
    hard = {
      pods = 1
    }
    scopes = ["BestEffort"]
  }
}

resource "kubernetes_namespace" "tailscale-namespace" {
  provider = kubernetes.wbaas-3

  metadata {
    name = "tailscale"
  }
}
