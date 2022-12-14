/*
Product Name: dhtmlxGrid 
Version: 5.0.1 
Edition: Professional 
License: content of this file is covered by DHTMLX Commercial or Enterprise license. Usage without proper license is prohibited. To obtain it contact sales@dhtmlx.com
Copyright UAB Dinamenta http://www.dhtmlx.com
*/

window.dhtmlxAjax = {
    get: function(a, c, b) {
        if (b) {
            return dhx4.ajax.getSync(a)
        } else {
            dhx4.ajax.get(a, c)
        }
    },
    post: function(a, b, d, c) {
        if (c) {
            return dhx4.ajax.postSync(a, b)
        } else {
            dhx4.ajax.post(a, b, d)
        }
    },
    getSync: function(a) {
        return dhx4.ajax.getSync(a)
    },
    postSync: function(a, b) {
        return dhx4.ajax.postSync(a, b)
    }
};
dhtmlXCalendarObject.prototype.draw = function() {
    this.show()
};
dhtmlXCalendarObject.prototype.close = function() {
    this.hide()
};
dhtmlXCalendarObject.prototype.setYearsRange = function() {};
dhtmlXCombo.prototype.loadXML = function(a, b) {
    this.load(a, b)
};
dhtmlXCombo.prototype.loadXMLString = function(a) {
    this.load(a)
};
dhtmlXCombo.prototype.enableOptionAutoHeight = function() {};
dhtmlXCombo.prototype.enableOptionAutoPositioning = function() {};
dhtmlXCombo.prototype.enableOptionAutoWidth = function() {};
dhtmlXCombo.prototype.destructor = function() {
    this.unload()
};
dhtmlXCombo.prototype.render = function() {};
dhtmlXCombo.prototype.setOptionHeight = function() {};
dhtmlXCombo.prototype.attachChildCombo = function() {};
dhtmlXCombo.prototype.setAutoSubCombo = function() {};
dhtmlXMenuObject.prototype.loadXML = function(a, b) {
    this.loadStruct(a, b)
};
dhtmlXMenuObject.prototype.loadXMLString = function(b, a) {
    this.loadStruct(b, a)
};
dhtmlXMenuObject.prototype.setIconPath = function(a) {
    this.setIconsPath(a)
};
dhtmlXMenuObject.prototype.setImagePath = function() {};
dhtmlXToolbarObject.prototype.loadXML = function(a, b) {
    this.loadStruct(a, b)
};
dhtmlXToolbarObject.prototype.loadXMLString = function(b, a) {
    this.loadStruct(b, a)
};
dhtmlXToolbarObject.prototype.setIconPath = function(a) {
    this.setIconsPath(a)
};
dhtmlXGridObject.prototype.hidePivot = function(a) {
    if (this._pgridCont) {
        if (this._pgrid) {
            this._pgrid.destructor()
        }
        var b = this._pgridCont.parentNode;
        b.innerHTML = "";
        if (b.parentNode == this.entBox) {
            this.entBox.removeChild(b)
        }
        this._pgrid = this._pgridSelect = this._pUNI = this._pgridCont = null
    }
};
dhtmlXGridObject.prototype.makePivot = function(j, a) {
    a = a || {};
    this.hidePivot();
    if (!j) {
        var j = document.createElement("DIV");
        j.style.cssText = "position:absolute; top:0px; left:0px;background-color:white;";
        j.style.height = this.entBox.offsetHeight + "px";
        j.style.width = this.entBox.offsetWidth + "px";
        if (this.entBox.style.position != "absolute") {
            this.entBox.style.position = "relative"
        }
        this.entBox.appendChild(j)
    }
    if (typeof(j) != "object") {
        j = document.getElementById(j)
    }
    if (a.column_list) {
        this._column_list = a.column_list
    } else {
        this._column_list = [];
        for (var g = 0; g < this.hdr.rows[1].cells.length; g++) {
            this._column_list.push(this.hdr.rows[1].cells[g][_isIE ? "innerText" : "textContent"])
        }
    }
    var h = this;
    j.innerHTML = "<table cellspacing='0' cellpadding='0'><tr><td style='width:160px' align='center'></td><td>&nbsp;&nbsp;&nbsp;</td><td></td></tr></table><div></div>";
    var f = this.makePivotSelect(this._column_list);
    f.style.width = "80px";
    f.onchange = function() {
        if (this.value != -1) {
            h._pivotS.value = this.value
        } else {
            h._pivotS.value = ""
        }
        h._reFillPivotLists();
        h._renderPivot2()
    };
    var e = this.makePivotSelect(this._column_list);
    e.onchange = function() {
        if (this.value != -1) {
            h._pivotS.x = this.value
        } else {
            h._pivotS.x = ""
        }
        h._reFillPivotLists();
        h._renderPivot()
    };
    var d = this.makePivotSelect(this._column_list);
    d.onchange = function() {
        if (this.value != -1) {
            h._pivotS.y = this.value
        } else {
            h._pivotS.y = ""
        }
        h._reFillPivotLists();
        h._renderPivot()
    };
    var c = this.makePivotSelect(["Sum", "Min", "Max", "Average", "Count"], -1);
    c.style.width = "70px";
    c.onchange = function() {
        if (this.value != -1) {
            h._pivotS.action = this.value
        } else {
            h._pivotS.action = null
        }
        h._renderPivot2()
    };
    if (a.readonly) {
        f.disabled = e.disabled = d.disabled = c.disabled = true
    }
    j.firstChild.rows[0].cells[0].appendChild(c);
    j.firstChild.rows[0].cells[0].appendChild(f);
    j.firstChild.rows[0].cells[2].appendChild(e);
    var b = j.childNodes[1];
    b.style.width = j.offsetWidth + "px";
    b.style.height = j.offsetHeight - 20 + "px";
    b.style.overflow = "hidden";
    this._pgridCont = b;
    this._pgridSelect = [f, e, d, c];
    this._pData = this._fetchPivotData();
    this._pUNI = [];
    this._pivotS = {
        action: (a.action || "0"),
        value: (typeof a.value != "undefined" ? (a.value || "0") : null),
        x: (typeof a.x != "undefined" ? (a.x || "0") : null),
        y: (typeof a.y != "undefined" ? (a.y || "0") : null)
    };
    f.value = this._pivotS.value;
    e.value = this._pivotS.x;
    d.value = this._pivotS.y;
    c.value = this._pivotS.action;
    h._reFillPivotLists();
    this._renderPivot()
};
dhtmlXGridObject.prototype._fetchPivotData = function() {
    var e = [];
    for (var b = 0; b < this._cCount; b++) {
        var c = [];
        for (var a = 0; a < this.rowsCol.length; a++) {
            if (this.rowsCol[a]._cntr) {
                continue
            }
            c.push(this.cells2(a, b).getValue())
        }
        e.push(c)
    }
    return e
};
dhtmlXGridObject.prototype._renderPivot = function() {
    if (_isIE) {
        this._pgridSelect[2].removeNode(true)
    }
    if (this._pgrid) {
        this._pgrid.destructor()
    }
    this._pgrid = new dhtmlXGridObject(this._pgridCont);
    this._pgrid.setImagePath(this.imgURL);
    this._pgrid.attachEvent("onBeforeSelect", function() {
        return false
    });
    if (this._pivotS.x) {
        var a = this._getUniList(this._pivotS.x);
        var d = [160];
        for (var c = 0; c < a.length; c++) {
            d.push(100)
        }
        a = [""].concat(a);
        this._pgrid.setHeader(a);
        this._pgrid.setInitWidths(d.join(","))
    } else {
        this._pgrid.setHeader("");
        this._pgrid.setInitWidths("160")
    }
    this._pgrid.init();
    this._pgrid.setEditable(false);
    this._pgrid.setSkin(this.entBox.className.replace("gridbox gridbox_", ""));
    var b = this._pgrid.hdr.rows[1].cells[0];
    if (b.firstChild && b.firstChild.tagName == "DIV") {
        b = b.firstChild
    }
    b.appendChild(this._pgridSelect[2]);
    this._pgrid.setSizes();
    if (this._pivotS.y) {
        var a = this._getUniList(this._pivotS.y);
        for (var c = 0; c < a.length; c++) {
            this._pgrid.addRow(this._pgrid.uid(), [a[c]], -1)
        }
    } else {
        this._pgrid.addRow(1, "not ready", 1)
    }
    this._renderPivot2()
};
dhtmlXGridObject.prototype._pivot_action_0 = function(n, m, l, d, o, j) {
    var k = 0;
    var g = j[n];
    var f = j[m];
    var e = j[l];
    for (var h = g.length - 1; h >= 0; h--) {
        if (g[h] == d && f[h] == o) {
            k += this.parseFloat(e[h])
        }
    }
    return k
};
dhtmlXGridObject.prototype._pivot_action_1 = function(m, l, k, d, n, j) {
    ret = 9999999999;
    var g = j[m];
    var f = j[l];
    var e = j[k];
    for (var h = g.length - 1; h >= 0; h--) {
        if (g[h] == d && f[h] == n) {
            ret = Math.min(this.parseFloat(e[h]), ret)
        }
    }
    if (ret == 9999999999) {
        ret = ""
    }
    return ret
};
dhtmlXGridObject.prototype._pivot_action_2 = function(m, l, k, d, n, j) {
    ret = -9999999999;
    var g = j[m];
    var f = j[l];
    var e = j[k];
    for (var h = g.length - 1; h >= 0; h--) {
        if (g[h] == d && f[h] == n) {
            ret = Math.max(this.parseFloat(e[h]), ret)
        }
    }
    if (ret == -9999999999) {
        ret = ""
    }
    return ret
};
dhtmlXGridObject.prototype._pivot_action_3 = function(o, n, m, d, p, j) {
    var l = 0;
    var k = 0;
    var g = j[o];
    var f = j[n];
    var e = j[m];
    for (var h = g.length - 1; h >= 0; h--) {
        if (g[h] == d && f[h] == p) {
            l += this.parseFloat(e[h]);
            k++
        }
    }
    return k ? l / k : ""
};
dhtmlXGridObject.prototype._pivot_action_4 = function(o, n, m, d, p, j) {
    var l = 0;
    var k = 0;
    var g = j[o];
    var f = j[n];
    var e = j[m];
    for (var h = g.length - 1; h >= 0; h--) {
        if (g[h] == d && f[h] == p) {
            l++
        }
    }
    return l
};
dhtmlXGridObject.prototype.parseFloat = function(a) {
    a = parseFloat(a);
    if (isNaN(a)) {
        return 0
    }
    return a
};
dhtmlXGridObject.prototype._renderPivot2 = function() {
    if (!(this._pivotS.x && this._pivotS.y && this._pivotS.value && this._pivotS.action)) {
        return
    }
    var d = this["_pivot_action_" + this._pivotS.action];
    var a = this._getUniList(this._pivotS.x);
    var e = this._getUniList(this._pivotS.y);
    for (var c = 0; c < a.length; c++) {
        for (var b = 0; b < e.length; b++) {
            this._pgrid.cells2(b, c + 1).setValue(Math.round(d(this._pivotS.x, this._pivotS.y, this._pivotS.value, a[c], e[b], this._pData) * 100) / 100)
        }
    }
};
dhtmlXGridObject.prototype._getUniList = function(c) {
    if (!this._pUNI[c]) {
        var e = {};
        var b = [];
        for (var d = this._pData[c].length - 1; d >= 0; d--) {
            e[this._pData[c][d]] = true
        }
        for (var f in e) {
            if (e[f] === true) {
                b.push(f)
            }
        }
        this._pUNI[c] = b.sort()
    }
    return this._pUNI[c]
};
dhtmlXGridObject.prototype._fillPivotList = function(e, d, c, a) {
    if (!c) {
        c = {};
        a = -1
    }
    e.innerHTML = "";
    e.options[e.options.length] = new Option("-select-", -1);
    for (var b = 0; b < d.length; b++) {
        if (c[b] || d[b] === null) {
            continue
        }
        e.options[e.options.length] = new Option(d[b], b)
    }
    e.value = parseInt(a)
};
dhtmlXGridObject.prototype._reFillPivotLists = function() {
    var e = [];
    var b = [];
    for (var d = 0; d < 3; d++) {
        e.push(this._pgridSelect[d]);
        b.push(e[d].value)
    }
    var c = this._reFfillPivotLists;
    var a = {};
    a[b[1]] = a[b[2]] = true;
    this._fillPivotList(e[0], this._column_list, a, b[0]);
    a = {};
    a[b[0]] = a[b[2]] = true;
    this._fillPivotList(e[1], this._column_list, a, b[1]);
    a = {};
    a[b[1]] = a[b[0]] = true;
    this._fillPivotList(e[2], this._column_list, a, b[2]);
    this._reFfillPivotLists = c
};
dhtmlXGridObject.prototype.makePivotSelect = function(b, a) {
    var c = document.createElement("SELECT");
    this._fillPivotList(c, b, a);
    c.style.cssText = "width:150px; height:20px; font-family:Tahoma; font-size:8pt; font-weight:normal;";
    return c
};

function eXcell_dec(a) {
    if (a) {
        this.cell = a;
        this.grid = this.cell.parentNode.grid
    }
    this.getValue = function() {
        return parseFloat(this.cell.innerHTML.replace(/,/g, ""))
    };
    this.setValue = function(h) {
        var f = "0,000.00";
        if (h == "0") {
            this.setCValue(f.replace(/.*(0\.[0]+)/, "$1"), h);
            return
        }
        var g = f.substr(f.indexOf(".") + 1).length;
        h = Math.round(h * Math.pow(10, g)).toString();
        var b = "";
        var d = 0;
        var e = false;
        for (var c = h.length - 1; c >= 0; c--) {
            d++;
            b = h.charAt(c) + b;
            if (!e && d == g) {
                b = "." + b;
                d = 0;
                e = true
            }
            if (e && d == 3 && c != 0 && h.charAt(c - 1) != "-") {
                b = "," + b;
                d = 0
            }
        }
        this.setCValue(b, h)
    }
}
eXcell_dec.prototype = new eXcell_ed;

function eXcell_cor(a) {
    if (a) {
        this.cell = a;
        this.grid = this.cell.parentNode.grid;
        this.combo = this.grid.getCombo(this.cell._cellIndex);
        this.editable = true
    }
    this.shiftNext = function() {
        var b = this.list.options[this.list.selectedIndex + 1];
        if (b) {
            b.selected = true
        }
        this.obj.value = this.list.value;
        return true
    };
    this.shiftPrev = function() {
        var b = this.list.options[this.list.selectedIndex - 1];
        if (b) {
            b.selected = true
        }
        this.obj.value = this.list.value;
        return true
    };
    this.edit = function() {
        this.val = this.getValue();
        this.text = this.cell.innerHTML._dhx_trim();
        var d = this.grid.getPosition(this.cell);
        this.obj = document.createElement("TEXTAREA");
        this.obj.className = "dhx_combo_edit";
        this.obj.style.height = (this.cell.offsetHeight - 4) + "px";
        this.obj.wrap = "soft";
        this.obj.style.textAlign = this.cell.align;
        this.obj.onclick = function(g) {
            (g || event).cancelBubble = true
        };
        this.obj.value = this.text;
        this.list = document.createElement("SELECT");
        this.list.editor_obj = this;
        this.list.className = "dhx_combo_select";
        this.list.style.width = this.cell.offsetWidth + "px";
        this.list.style.left = d[0] + "px";
        this.list.style.top = d[1] + this.cell.offsetHeight + "px";
        this.list.onclick = function(i) {
            var h = i || window.event;
            var g = h.target || h.srcElement;
            if (g.tagName == "OPTION") {
                g = g.parentNode
            }
            if (g.value != -1) {
                g.editor_obj._byClick = true;
                g.editor_obj.editable = false;
                g.editor_obj.grid.editStop()
            } else {
                h.cancelBubble = true;
                g.editor_obj.obj.value = "";
                g.editor_obj.obj.focus()
            }
        };
        var b = this.combo.getKeys();
        var f = 0;
        this.list.options[0] = new Option(this.combo.get(b[0]), b[0]);
        this.list.options[0].selected = true;
        for (var c = 1; c < b.length; c++) {
            var e = this.combo.get(b[c]);
            this.list.options[this.list.options.length] = new Option(e, b[c]);
            if (b[c] == this.val) {
                f = this.list.options.length - 1
            }
        }
        document.body.appendChild(this.list);
        this.list.size = "6";
        this.cstate = 1;
        if (this.editable) {
            this.cell.innerHTML = ""
        } else {
            this.obj.style.width = "1px";
            this.obj.style.height = "1px"
        }
        this.cell.appendChild(this.obj);
        this.list.options[f].selected = true;
        if (this.editable) {
            this.obj.focus();
            this.obj.focus()
        }
        if (!this.editable) {
            this.obj.style.visibility = "hidden"
        }
    };
    this.getValue = function() {
        return ((this.cell.combo_value == window.undefined) ? "" : this.cell.combo_value)
    };
    this.getText = function() {
        return this.cell.innerHTML
    };
    this.getState = function() {
        return {
            prev: this.cell.__prev,
            now: this.cell.__now
        }
    };
    this.detach = function() {
        if (this.val != this.getValue()) {
            this.cell.wasChanged = true
        }
        if (this.list.parentNode != null) {
            if ((this.obj.value._dhx_trim() != this.text) || (this._byClick)) {
                var b = this.list.value;
                if (!this._byClick) {
                    this.combo.values[this.combo.keys._dhx_find(b)] = this.obj.value
                }
                this.setValue(b)
            } else {
                this.setValue(this.val)
            }
        }
        if (this.list.parentNode) {
            this.list.parentNode.removeChild(this.list)
        }
        if (this.obj.parentNode) {
            this.obj.parentNode.removeChild(this.obj)
        }
        return this.val != this.getValue()
    }
}
eXcell_cor.prototype = new eXcell;
eXcell_cor.prototype.setValue = function(b) {
    if ((b || "").toString()._dhx_trim() == "") {
        b = null
    }
    var a = this.grid.getCombo(this.cell._cellIndex).get(b);
    if ((b == -1) && (a == "")) {
        this.combo.values[this.combo.keys._dhx_find(-1)] = "Create new value";
        b = null
    }
    if (b !== null) {
        this.setCValue(a, b)
    } else {
        this.setCValue("&nbsp;", b)
    }
    this.cell.__prev = this.cell.__now;
    this.cell.__now = {
        key: b,
        value: a
    };
    this.cell.combo_value = b
};

function eXcell_wbut(a) {
    this.cell = a;
    this.grid = this.cell.parentNode.grid;
    this.edit = function() {
        var h = this.getValue().toString();
        this.obj = document.createElement("INPUT");
        this.obj.readOnly = true;
        this.obj.style.width = "60px";
        this.obj.style.height = (this.cell.offsetHeight - (this.grid.multiLine ? 5 : 4)) + "px";
        this.obj.style.border = "0px";
        this.obj.style.margin = "0px";
        this.obj.style.padding = "0px";
        this.obj.style.overflow = "hidden";
        this.obj.style.fontSize = _isKHTML ? "10px" : "12px";
        this.obj.style.fontFamily = "Arial";
        this.obj.wrap = "soft";
        this.obj.style.textAlign = this.cell.align;
        this.obj.onclick = function(i) {
            (i || event).cancelBubble = true
        };
        this.cell.innerHTML = "";
        this.cell.appendChild(this.obj);
        this.obj.onselectstart = function(i) {
            if (!i) {
                i = event
            }
            i.cancelBubble = true;
            return true
        };
        this.obj.style.textAlign = this.cell.align;
        this.obj.value = h;
        this.obj.focus();
        this.obj.focus();
        this.cell.appendChild(document.createTextNode(" "));
        var e = document.createElement("input");
        if (_isIE) {
            e.style.height = (this.cell.offsetHeight - (this.grid.multiLine ? 5 : 4)) + "px";
            e.style.lineHeight = "5px"
        } else {
            e.style.fontSize = "8px";
            e.style.width = "10px";
            e.style.marginTop = "-5px"
        }
        e.type = "button";
        e.name = "Lookup";
        e.value = "...";
        var f = this.obj;
        var b = this.cell.cellIndex;
        var d = this.cell.parentNode.idd;
        var g = this.grid;
        var c = this;
        this.dhx_m_func = this.grid.getWButFunction(this.cell._cellIndex);
        e.onclick = function(i) {
            c.dhx_m_func(c, c.cell.parentNode.idd, c.cell._cellIndex, h)
        };
        this.cell.appendChild(e)
    };
    this.detach = function() {
        this.setValue(this.obj.value);
        return this.val != this.getValue()
    }
}
eXcell_wbut.prototype = new eXcell;
dhtmlXGridObject.prototype.getWButFunction = function(a) {
    if (this._wbtfna) {
        return this._wbtfna[a]
    } else {
        return (function() {})
    }
};
dhtmlXGridObject.prototype.setWButFunction = function(a, b) {
    if (!this._wbtfna) {
        this._wbtfna = new Array()
    }
    this._wbtfna[a] = b
};

function eXcell_passw(a) {
    if (a) {
        this.cell = a;
        this.grid = this.cell.parentNode.grid
    }
    this.edit = function() {
        this.cell.innerHTML = "";
        this.cell.atag = "INPUT";
        this.val = this.getValue();
        this.obj = document.createElement(this.cell.atag);
        this.obj.style.height = (this.cell.offsetHeight - (_isIE ? 6 : 4)) + "px";
        this.obj.className = "dhx_combo_edit";
        this.obj.type = "password";
        this.obj.wrap = "soft";
        this.obj.style.textAlign = this.cell.align;
        this.obj.onclick = function(b) {
            (b || event).cancelBubble = true
        };
        this.obj.onmousedown = function(b) {
            (b || event).cancelBubble = true
        };
        this.obj.value = this.cell._rval || "";
        this.cell.appendChild(this.obj);
        if (_isFF) {
            this.obj.style.overflow = "visible";
            if ((this.grid.multiLine) && (this.obj.offsetHeight >= 18) && (this.obj.offsetHeight < 40)) {
                this.obj.style.height = "36px";
                this.obj.style.overflow = "scroll"
            }
        }
        this.obj.onselectstart = function(b) {
            if (!b) {
                b = event
            }
            b.cancelBubble = true;
            return true
        };
        this.obj.focus();
        this.obj.focus()
    };
    this.getValue = function() {
        return this.cell._rval
    };
    this.setValue = function(c) {
        var b = "*****";
        this.cell.innerHTML = b;
        this.cell._rval = c
    };
    this.detach = function() {
        this.setValue(this.obj.value);
        return this.val != this.getValue()
    }
}
eXcell_passw.prototype = new eXcell;

function eXcell_num(a) {
    try {
        this.cell = a;
        this.grid = this.cell.parentNode.grid
    } catch (b) {}
    this.edit = function() {
        this.val = this.getValue();
        this.obj = document.createElement(_isKHTML ? "INPUT" : "TEXTAREA");
        this.obj.className = "dhx_combo_edit";
        this.obj.style.height = (this.cell.offsetHeight - 4) + "px";
        this.obj.wrap = "soft";
        this.obj.style.textAlign = this.cell.align;
        this.obj.onclick = function(c) {
            (c || event).cancelBubble = true
        };
        this.obj.value = this.val;
        this.cell.innerHTML = "";
        this.cell.appendChild(this.obj);
        this.obj.onselectstart = function(c) {
            if (!c) {
                c = event
            }
            c.cancelBubble = true;
            return true
        };
        this.obj.focus();
        this.obj.focus()
    };
    this.getValue = function() {
        if ((this.cell.firstChild) && (this.cell.firstChild.tagName == "TEXTAREA")) {
            return this.cell.firstChild.value
        } else {
            return this.grid._aplNFb(this.cell.innerHTML.toString()._dhx_trim(), this.cell._cellIndex)
        }
    };
    this.setValue = function(d) {
        var c = new RegExp("[a-z]|[A-Z]", "i");
        if (d.match(c)) {
            d = "&nbsp;"
        }
        this.cell.innerHTML = d
    };
    this.detach = function() {
        var c = this.obj.value;
        this.setValue(c);
        return this.val != this.getValue()
    }
}
eXcell_num.prototype = new eXcell;

function eXcell_mro(a) {
    this.cell = a;
    this.grid = this.cell.parentNode.grid;
    this.edit = function() {}
}
eXcell_mro.prototype = new eXcell;
eXcell_mro.prototype.getValue = function() {
    return this.cell.childNodes[0].innerHTML._dhx_trim()
};
eXcell_mro.prototype.setValue = function(a) {
    if (!this.cell.childNodes.length) {
        this.cell.style.whiteSpace = "normal";
        this.cell.innerHTML = "<div style='height:100%; white-space:nowrap; overflow:hidden;'></div>"
    }
    if (!a || a.toString()._dhx_trim() == "") {
        a = "&nbsp;"
    }
    this.cell.childNodes[0].innerHTML = a
};

function eXcell_liveedit(a) {
    if (a) {
        this.cell = a;
        this.grid = this.cell.parentNode.grid
    }
    this.edit = function() {
        this.cell.inputObj.focus();
        this.cell.inputObj.focus()
    };
    this.detach = function() {
        this.setValue(this.cell.inputObj.value)
    };
    this.getValue = function() {
        return this.cell.inputObj ? this.cell.inputObj.value : ""
    };
    this.destructor = function() {};
    this.onFocus = function() {
        var b = this.grid.callEvent("onEditCell", [0, this.cell.parentNode.idd, this.cell._cellIndex]);
        if (b === false) {
            this.cell.inputObj.blur()
        }
    };
    this.onBlur = function() {
        var b = this.grid.callEvent("onEditCell", [2, this.cell.parentNode.idd, this.cell._cellIndex]);
        this.detach()
    };
    this.onChange = function() {
        var b = this.grid.callEvent("onCellChanged", [this.cell.parentNode.idd, this.cell._cellIndex, this.cell.inputObj.value]);
        this.detach()
    }
}
eXcell_liveedit.prototype = new eXcell_ed;
eXcell_liveedit.prototype.setValue = function(b) {
    var a = this;
    this.cell.innerHTML = '<input type="text" value="" style="width:100%;" />';
    this.cell.inputObj = this.cell.firstChild;
    this.cell.inputObj = this.cell.firstChild;
    this.cell.inputObj.value = b;
    this.cell.inputObj.onfocus = function() {
        a.onFocus()
    };
    this.cell.inputObj.onblur = function() {
        a.onFocus()
    };
    this.cell.inputObj.onchange = function() {
        a.onChange()
    }
};
if (window.eXcell_math) {
    eXcell_liveedit.prototype.setValueA = eXcell_liveedit.prototype.setValue;
    eXcell_liveedit.prototype.setValue = eXcell_math.prototype._NsetValue
}

function eXcell_limit(a) {
    if (a) {
        this.cell = a;
        this.grid = this.cell.parentNode.grid
    }
    this.edit = function() {
        this.cell.atag = ((!this.grid.multiLine) && (_isKHTML || _isMacOS || _isFF)) ? "INPUT" : "TEXTAREA";
        this.val = this.getValue();
        this.obj = document.createElement(this.cell.atag);
        this.obj.style.height = (this.cell.offsetHeight - (_isIE ? 6 : 4)) + "px";
        this.obj.className = "dhx_combo_edit";
        this.obj.wrap = "soft";
        this.obj.style.textAlign = this.cell.align;
        this.obj.onclick = function(b) {
            (b || event).cancelBubble = true
        };
        this.obj.onmousedown = function(b) {
            (b || event).cancelBubble = true
        };
        this.obj.value = this.val;
        this.cell.innerHTML = "";
        this.cell.appendChild(this.obj);
        if (_isFF) {
            this.obj.style.overflow = "visible";
            if ((this.grid.multiLine) && (this.obj.offsetHeight >= 18) && (this.obj.offsetHeight < 40)) {
                this.obj.style.height = "36px";
                this.obj.style.overflow = "scroll"
            }
        }
        this.obj.onkeypress = function(b) {
            if (this.value.length >= 15) {
                return false
            }
        };
        this.obj.onselectstart = function(b) {
            if (!b) {
                b = event
            }
            b.cancelBubble = true;
            return true
        };
        this.obj.focus();
        this.obj.focus()
    };
    this.getValue = function() {
        if ((this.cell.firstChild) && ((this.cell.atag) && (this.cell.firstChild.tagName == this.cell.atag))) {
            return this.cell.firstChild.value
        } else {
            return this.cell.innerHTML.toString()._dhx_trim()
        }
    };
    this.setValue = function(b) {
        if (b.length > 15) {
            this.cell.innerHTML = b.substring(0, 14)
        } else {
            this.cell.innerHTML = b
        }
    };
    this.detach = function() {
        this.setValue(this.obj.value);
        return this.val != this.getValue()
    }
}
eXcell_limit.prototype = new eXcell;