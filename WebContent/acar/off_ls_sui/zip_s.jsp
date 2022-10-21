<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>


<%
	//우편번호 조회 페이지

	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String swd 	= request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx 	= request.getParameter("idx")==null?"":request.getParameter("idx");
	String doro 	= request.getParameter("doro")==null?"":request.getParameter("doro");
	String post_st 	= request.getParameter("post_st")==null?"":request.getParameter("post_st");
	String dong_yn 	= request.getParameter("dong_yn")==null?"":request.getParameter("dong_yn");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<html>
<head><title> FMS </title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function linkJusoGoKr(){
		window.open("http://www.juso.go.kr/openSearchPageJibun.do", "JUSO_ZIP", "left=500, top=100, height=720, width=463, scrollbars=yes");
	}
	
	function save()
	{
		var fm = document.form1;
		if(fm.swd.value == ""){ alert("검색어를 입력하십시오."); return;}		
		if(fm.swd.value.length < 2){ alert("검색어는 2자 이상을 입력하십시오."); return;}		
		document.form1.mode.value = 'AFTER';
		document.form1.post_st.value = '';
		document.form1.submit();
	}
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') save();
	}	

	function save_doro()
	{
		var fm = document.form1;
		if(fm.doro.value == ""){ alert("검색어를 입력하십시오."); return;}				
		if(fm.doro.value.length < 2){ alert("검색어는 2자 이상을 입력하십시오."); return;}		
		document.form1.mode.value = 'AFTER';
		document.form1.post_st.value = 'DORO';
		document.form1.submit();
	}
	function enter_doro() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') save_doro();
	}
		
	function set_zip(zip_str, addr_str)
	{
		var fm = document.form1;
		var idx = fm.idx.value
		if(idx == "d")
		{
			window.opener.form1.d_zip.value 	= zip_str;
			window.opener.form1.d_addr.value 	= addr_str;
		}
		else if(idx == "h")
		{
			window.opener.form1.h_zip.value 	= zip_str;
			window.opener.form1.h_addr.value 	= addr_str;
		}
		else if(idx == "car")
		{
			window.opener.form1.car_zip.value 	= zip_str;
			window.opener.form1.car_addr.value 	= addr_str;
		}
		else if(idx == "des")
		{
			window.opener.form1.des_zip.value 	= zip_str;
			window.opener.form1.des_addr.value 	= addr_str;
		}
		window.close();
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>
<p>

<form name='form1' action='zip_s.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='post_st' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>우편번호검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr> 
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width=20%>	동이름 </td>
					<td>
						&nbsp;<input type='text' name='swd' size='10' class='text' value='<%=swd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
						(예:공덕1)
						<a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					</td>
				</tr>

				<tr>
					<td class='title' width=20%>	도로명 </td>
					<td>
						&nbsp;<input type='text' name='doro' size='10' class='text' value='<%=doro%>' onKeyDown='javascript:enter_doro()' style='IME-MODE: active'>
						(예:의사당대로)
						<a href='javascript:save_doro()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
						<input type="checkbox" name="dong_yn" value="Y" <%if(dong_yn.equals("Y"))%>checked<%%>>동검색
					</td>
				</tr>

				
			</table>
		</td>
	</tr>

    <tr> 
        <td>* 도로명은 동일도로명에 다른동도 있으니 주의하세요</td>
    </tr>	

	
	<tr>
		<td></td>
	</tr>
<%
	if(mode.equals("AFTER")){
		Vector rt = new Vector();		
		
		if(post_st.equals("DORO")){
			if(!doro.equals("")){
				rt = c_db.getZipDoro(doro, dong_yn, swd);
				System.out.println("##도로명우편번호검색:"+doro+" "+swd);	
			}
		}else{
			if(!swd.equals("")){
				rt = c_db.getZip(swd);	
			}
		}
		
		int rtSize = rt.size();
%>
<%		if(rtSize > 0){%>
	<tr>
		<td class='line' colspan=2>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='20%'> 우편번호 </td>
					<td class='title'> 주소 </td>
				</tr>
<%			for(int i = 0 ; i < rtSize ; i++){
				Hashtable aRow = (Hashtable)rt.elementAt(i);%>
				<tr>
					<%if(post_st.equals("DORO")){%>
						<td align='center'>
							<a href="javascript:set_zip('<%=aRow.get("ZIP_CD")%>', '<%=aRow.get("SIDO")%> <%=aRow.get("GUGUN")%> <%=aRow.get("EUPMYUN")%> <%=aRow.get("DORO")%> ')"><%=aRow.get("ZIP_CD")%></a>
						</td>
						<td>
							<%=aRow.get("SIDO")%> 
							<%=aRow.get("GUGUN")%>   						
							<%=aRow.get("EUPMYUN")%> 
							<%=aRow.get("DORO")%> 
							<%=aRow.get("DARAYNG")%> 
							<%if(!String.valueOf(aRow.get("DONG")).equals("")){%>
								(<%=aRow.get("DONG")%>)
							<%}%>
						</td>					
					<%}else{%>
						<td align='center'>
							<a href="javascript:set_zip('<%=aRow.get("ZIP_CD")%>', '<%=aRow.get("SIDO")%> <%=aRow.get("GUGUN")%> <%=aRow.get("DONG")%> ')"><%=aRow.get("ZIP_CD")%></a>
						</td>
						<td>
							<%=aRow.get("SIDO")%> 
							<%=aRow.get("GUGUN")%>   
							<%=aRow.get("DONG")%> 
							<%=aRow.get("BUNJI")%> 	
						</td>					
					<%}%>					
				</tr>
<%			}
		}else{%>
				<tr>
					<td colspan='2'> 검색된 결과가 없습니다 </td>
				</tr>
<%		}
	}%>
			</table>
		</td>
	</tr>
	<tr>
		<td><a href="javascript:linkJusoGoKr();"><img src="http://www.minwon.go.kr/images/minwon/road/tab_juso.gif" alt="주소통합검색" align=absmiddle border=0/></a></td>
	</tr>	
</table>
</body>
<script language='javascript'>
<!--
	document.form1.swd.focus();
//-->
</script>
</html>