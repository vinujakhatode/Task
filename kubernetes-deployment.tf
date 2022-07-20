resource "kubernetes_namespace" "flaskapp" {
  metadata {
    name = "flaskapp"
  }
}

resource "kubernetes_deployment" "flaskapp" {
  metadata {
    name      = "flaskapp"
    namespace = kubernetes_namespace.flaskapp.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "flaskapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "flaskapp"
        }
      }
      spec {
        container {
          image = "vinujakhatode/flaskenv:latest"
          name  = "flaskapp-container"
          port {
            container_port = 5000
          }
        

      }
    }
  }
}
}

resource "kubernetes_service" "flaskapp" {
  metadata {
    name      = "flaskapp"
    namespace = kubernetes_namespace.flaskapp.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.flaskapp.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 5000
    }
  }
}
