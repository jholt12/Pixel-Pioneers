extends Node

# Global singleton to connect signal callers to receivers
# through a single object
#
# Helpful when a receiver needs to receive all signal calls
# without connecting directly to every caller in the scene

signal on_health_changed(node : Node, amount_changed : int)
