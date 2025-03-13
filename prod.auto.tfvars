project_id     = "natural-region-452705-m6"
region         = "us-central1"
zone           = "us-central1-c"
instance_count = 3
machine_type   = "n1-standard-2"
source_image   = "debian-cloud/debian-11"
network        = "default"
disk_name = "prod-disk"
disk_type = "pd-ssd"
disk_size = 100
instance_template_name = "prod-appserver-template"
instance_template_description = "Production app server template"
auto_delete = true
boot = true
auto_delete_secondary = false
boot_secondary = false
snapshot_name = "prod-snapshot"
storage_locations = ["us-central1"]
instance_name = "prod-instance-from-template"
