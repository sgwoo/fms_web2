
<div id="floater" style="position:absolute; left:984px; top:<%=204-100%>px; width:162px; height:<%=305+300%>px;  z-index:1; visibility:visible"> 
  <iframe src="quick2.jsp?height=<%=305+300%>" cellpadding="0" cellspacing="0" border="0" width="162" height="<%=305+300%>" scrolling="no" frameborder="0" ></iframe>
</div>
<script language=javascript>
<!--
// 슬라이드
self.onError=null;
currentX = currentY = 0;
whichIt = null;
lastScrollX = 0; lastScrollY = 0;

var tmp1= tmp2= tmp3 =0;
tmp1 = document.body.clientHeight;

function heartBeat() {
	tmp2 = document.body.clientHeight;
	if(tmp1 != tmp2)
	{
		tmp3 = tmp2 - tmp1;
		tmp1 = tmp2;
		if(tmp3<0)
		{
		}
	}

	diffY = document.body.scrollTop;
	diffX = 0;
	
	if(diffY != lastScrollY) {
		percent = .1 * (diffY - lastScrollY);
		
		if(percent > 0)
			percent = Math.ceil(percent);
		else
			percent = Math.floor(percent);
		
		document.all.floater.style.pixelTop += percent;
		
		lastScrollY = lastScrollY + percent;
	}

	if(diffX != lastScrollX) {
		percent = .1 * (diffX - lastScrollX);
	
		if(percent > 0)
			percent = Math.ceil(percent);
		else
			percent = Math.floor(percent);
		
		document.all.floater.style.pixelLeft += percent;
		lastScrollY = lastScrollY + percent;
	}
}

window.setInterval("heartBeat()",1);

//-->
</script>



