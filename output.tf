#aqui lo que hago es mostrar mi ip externa a la cual me voy a conectar
output "external_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
#aqui veo la ip interna de mi maquina vm
output "internal_ip" {
  value = google_compute_instance.default.network_interface[0].network_ip
}
