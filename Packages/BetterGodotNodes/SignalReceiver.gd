class_name SignalReceiver
extends Node

signal signal_received

func receive_signal():
	signal_received.emit()
