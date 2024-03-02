variable "REPO_PREFIX" {
    default = "harbor.ingtra.net/"
}

variable "L4T_VERSION" {
    default = "36.2.0"
}

variable "CUDA_ARCH" {
    default = "87"
}

target "wheel-flash-attn" {
    context = "wheels/flash-attn"
    platforms = ["linux/arm64"]
    tags = ["docker.io/ingtranet/py-pack-wheel:flash-attn-2.5.5-l4t${L4T_VERSION}"]
    args = {
        REPO_PREFIX = "${REPO_PREFIX}"
        L4T_VERSION = "${L4T_VERSION}"
        FLASH_ATTENTION_VERSION = "2.5.5"
    }
}

target "wheel-auto-awq" {
    context = "wheels/auto-awq"
    platforms = ["linux/arm64"]
    tags = ["docker.io/ingtranet/py-pack-wheel:auto-awq-0.2.2-l4t${L4T_VERSION}"]
    args = {
        REPO_PREFIX = "${REPO_PREFIX}"
        L4T_VERSION = "${L4T_VERSION}"
        CUDA_ARCH = "87"
        AUTOAWQ_KERNEL_VERSION = "0.0.5"
        AUTOAWQ_VERSION = "0.2.2"
    }
}

