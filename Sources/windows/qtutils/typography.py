from typing import Tuple
from PyQt6.QtGui import QPixmap, QFont
from PyQt6.QtWidgets import QLabel, QScrollArea, QVBoxLayout

def _set_font_size(widget, size):
    font = widget.font()
    font.setPointSize(size)
    widget.setFont(font)
    return widget

def _make_front_bold(widget):
    font = widget.font()
    font.setBold(True)
    widget.setFont(font)
    return widget

def _make_title(widget):
    widget = widget.withFontSize(21).bold()
    return widget

QLabel.withFontSize = _set_font_size
QLabel.bold = _make_front_bold
QLabel.title = _make_title