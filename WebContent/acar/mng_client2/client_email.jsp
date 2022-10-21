<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	ClientBean client = al_db.getNewClient(client_id);
	
	Vector cars = al_db.getClientMgrList(client_id);
	int car_size = cars.size();
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function Search(){
		var fm = document.form1;
		if(fm.t_wd.value==""){	alert("상호명을 입력해 주세요!"); fm.t_wd.focus();	return; }
		fm.action =  'cr_c_visit.jsp';		
		fm.target = 'i_no';	
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}
		
	function modify(idx)
	{
		if(confirm('수정하시겠습니까?'))
		{
			var fm = document.form1;
			if(fm.size.value == '1'){
				fm.m_id.value 		= fm.rent_mng_id.value;
				fm.l_cd.value 		= fm.rent_l_cd.value;
				fm.m_st1.value 		= fm.mgr_st1.value;
				fm.m_st2.value 		= fm.mgr_st2.value;
				fm.m_st3.value 		= fm.mgr_st3.value;
				fm.m_mail1.value 	= fm.mgr_email1.value;
				fm.m_mail2.value 	= fm.mgr_email2.value;
				fm.m_mail3.value 	= fm.mgr_email3.value;			
				if(fm.mail_yn1.checked == true) fm.mm_yn1.value 	= 'N';
				if(fm.mail_yn2.checked == true) fm.mm_yn2.value 	= 'N';
				if(fm.mail_yn3.checked == true) fm.mm_yn3.value 	= 'N';
			}else{
				fm.m_id.value 		= fm.rent_mng_id[idx].value;
				fm.l_cd.value 		= fm.rent_l_cd[idx].value;
				fm.m_st1.value 		= fm.mgr_st1[idx].value;
				fm.m_st2.value 		= fm.mgr_st2[idx].value;
				fm.m_st3.value 		= fm.mgr_st3[idx].value;
				fm.m_mail1.value 	= fm.mgr_email1[idx].value;
				fm.m_mail2.value 	= fm.mgr_email2[idx].value;
				fm.m_mail3.value 	= fm.mgr_email3[idx].value;		
				if(fm.mail_yn1[idx].checked == true) fm.mm_yn1.value 	= 'N';
				if(fm.mail_yn2[idx].checked == true) fm.mm_yn2.value 	= 'N';
				if(fm.mail_yn3[idx].checked == true) fm.mm_yn3.value 	= 'N';
			}
//			fm.target='i_no';
			fm.action = 'client_email_a.jsp';
			fm.submit();
		}
	}
	
	function mgr_modify(m_id, l_cd, mgr_st, car_no){
		var fm = document.form1;
		window.open('mgr_addr.jsp?m_id='+m_id+'&l_cd='+l_cd+'&mgr_st='+mgr_st+'&car_no='+car_no+'&client_id=<%=client_id%>&firm_nm=<%=client.getFirm_nm()%>&client_nm=<%=client.getClient_nm()%>', "MGR_ADDR"+l_cd+mgr_st, "left=100, top=100, width=650, height=275, scrollbars=yes");
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.t_wd.focus()">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='size' value='<%=car_size%>'>
<input type='hidden' name='s_gubun1' value='1'>
<input type='hidden' name='s_kd' value='1'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='m_st1' value=''>
<input type='hidden' name='m_st2' value=''>
<input type='hidden' name='m_st3' value=''>
<input type='hidden' name='m_mail1' value=''>
<input type='hidden' name='m_mail2' value=''>
<input type='hidden' name='m_mail3' value=''>
<input type='hidden' name='mm_yn1' value=''>
<input type='hidden' name='mm_yn2' value=''>
<input type='hidden' name='mm_yn3' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 영업현황 > 사원별 이메일등록현황 > <span class=style5>고객 이메일 주소 관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_sh.gif align=absmiddle>&nbsp;
		  <input name='t_wd' type='text' class='text' value="<%=t_wd%>" size='30' maxlength='20' onKeyDown="javascript:enter()" style='IME-MODE: active'> 
		  <a href="javascript:Search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
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
                    <td width='10%' class='title'>상호</td>
                    <td width="39%">&nbsp;<%=client.getFirm_nm()%></td>
                    <td width="4%" rowspan="2" class='title'>계<br>약<br>자</td>
                    <td width="8%" class='title'>성명</td>
                    <td width="31%">&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr>
                    <td class='title'>이용차량대수</td>
                    <td width="300">&nbsp;<%=car_size%>&nbsp;대</td>
                    <td class='title'>대표전화</td>
                    <td width="307">&nbsp;<%=client.getO_tel()%></td>
                </tr>
		    </table>
        </td>
	</tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
	    <td align='right' class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='8%' rowspan="2" class='title'> 차량번호 </td>
                    <td colspan="3"class='title'>차량이용자</td>
                    <td colspan="3" class='title'>차량관리자</td>
                    <td colspan="3" class='title'>회계관리자</td>
                    <td width="5%" rowspan="2" class='title'>처리</td>
                </tr>
                <tr>
                    <td width="11%"class='title'>성명/전화번호</td>
                    <td width="15%"class='title'>메일주소</td>
                    <td width="3%"class='title'>수신<br>거부</td>
                    <td width="11%" class='title'>성명/전화번호</td>
                    <td width="15%"class='title'>메일주소</td>
                    <td width="3%"class='title'>수신<br>거부</td>
                    <td width="11%" class='title'>성명/전화번호</td>
                    <td width="15%"class='title'>메일주소</td>
                    <td width="3%"class='title'>수신<br>거부</td>
                </tr>
<%	if(car_size > 0){
		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);%>		
                <tr><input type='hidden' name='rent_l_cd' value='<%=car.get("RENT_L_CD")%>'><input type='hidden' name='rent_mng_id' value='<%=car.get("RENT_MNG_ID")%>'>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><%=car.get("CAR_NO")%></td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td <%if(i%2 != 0)%>class=is<%%> align="center" style='height:21'><a href="javascript:mgr_modify('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '차량이용자', '<%=car.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=car.get("MGR_NM1")%></a></td>
                            </tr>
                            <tr>
                                <td <%if(i%2 != 0)%>class=is<%%> align="center" style='height:21'><%=car.get("MGR_TEL1")%></td>
                            </tr>
                        </table>
                    </td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><input type='text' size='21' name='mgr_email1' value='<%=car.get("MGR_EMAIL1")%>' class='text'><input type='hidden' name='mgr_st1' value='차량이용자'></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><input type="checkbox" name="mail_yn1" value="N"></td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td <%if(i%2 != 0)%>class=is<%%> align="center" style='height:21'><a href="javascript:mgr_modify('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '차량관리자', '<%=car.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=car.get("MGR_NM2")%></a></td>
                            </tr>
                            <tr>
                                <td <%if(i%2 != 0)%>class=is<%%> align="center" style='height:21'><%=car.get("MGR_TEL2")%></td>
                            </tr> 
                        </table>
                    </td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><input type='text' size='21' name='mgr_email2' value='<%=car.get("MGR_EMAIL2")%>' class='text'><input type='hidden' name='mgr_st2' value='차량관리자'></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><input type="checkbox" name="mail_yn2" value="N"></td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td <%if(i%2 != 0)%>class=is<%%> align="center" style='height:21'><a href="javascript:mgr_modify('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '회계관리자', '<%=car.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=car.get("MGR_NM3")%></a></td>
                            </tr>
                            <tr>
                                <td <%if(i%2 != 0)%>class=is<%%> align="center" style='height:21'><%=car.get("MGR_TEL3")%></td>
                            </tr>
                        </table>
                    </td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><input type='text' size='21' name='mgr_email3' value='<%=car.get("MGR_EMAIL3")%>' class='text'><input type='hidden' name='mgr_st3' value='회계관리자'></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><input type="checkbox" name="mail_yn3" value="N"></td>
                    <td <%if(i%2 != 0)%>class=is<%%> align="center"><a href="javascript:modify(<%=i%>)" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a></td>
                </tr>
<%		}
	}%>
            </table>
        </td>
    </tr>	
	<tr>
	    <td><span class=style3>* 동일인물은 한건만 입력해도 일괄 자동입력</span></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
