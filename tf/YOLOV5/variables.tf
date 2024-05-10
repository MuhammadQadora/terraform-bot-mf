variable "yolov5-sm" {
  type = string
}

variable "yolov5-secret-values" {
  type = map(string)
  sensitive = true
}
