<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//수정: 차량관리자 수정,추가
	function update_mgr(idx){
		var fm = document.form1;
		if(fm.mgr_nm.value == ''){ alert("성명을 입력하십시오."); return; }
		fm.mode.value = idx;
		fm.submit();
	}
	
	//등록/수정: 우편번호 조회
	function search_zip(str){
		window.open("./zip_s.jsp?str="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}			
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	//메뉴권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");	//사용자ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");		//소속사ID
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mgr_st 	= request.getParameter("mgr_st")==null?"":request.getParameter("mgr_st");
	
	String firm_nm 	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	int stat = 0;
	boolean flag = true;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	if(!mode.equals("")){
		CarMgrBean mgr_u = a_db.getCarMgr(m_id, l_cd, mgr_st);
		mgr_u.setRent_mng_id(m_id);
		mgr_u.setRent_l_cd	(l_cd);
		mgr_u.setMgr_id		(request.getParameter("mgr_id")==null?"":request.getParameter("mgr_id"));
		mgr_u.setMgr_st		(mgr_st);
		mgr_u.setMgr_nm		(request.getParameter("mgr_nm")==null?"":request.getParameter("mgr_nm"));
		mgr_u.setMgr_tel	(request.getParameter("mgr_tel")==null?"":request.getParameter("mgr_tel"));
		mgr_u.setMgr_m_tel	(request.getParameter("mgr_m_tel")==null?"":request.getParameter("mgr_m_tel"));
		mgr_u.setMgr_email	(request.getParameter("mgr_email")==null?"":request.getParameter("mgr_email").trim());
		mgr_u.setMgr_zip	(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
		mgr_u.setMgr_addr	(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
		
		if(mode.equals("0")){//등록
			flag = a_db.insertCarMgr(mgr_u);
		}else{//수정
			if(!mgr_u.getMgr_id().equals(""))	flag = a_db.updateCarMgr(mgr_u);
		}
	}
	
	
	
	CarMgrBean mgr = a_db.getCarMgr(m_id, l_cd, mgr_st);
	if(!mgr.getMgr_nm().equals("")){
		client_nm = mgr.getMgr_nm();
		stat = 1;
	}
	
	ClientBean client = al_db.getNewClient(client_id);
%>
<form name='form1' method='post' action='mgr_addr.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='mode' value=''>
<input type="hidden" name="mgr_st" value="<%=mgr_st%>">
<input type="hidden" name="mgr_id" value="<%=mgr.getMgr_id()%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan="3">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>거래처 : <span class=style5><%=client.getFirm_nm()%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=mgr_st%></span></td>
        <td align="right">
    	  <%//if(br_id.equals("S1") || br_id.equals(brch_id)){%>
    	  <%	if(stat == 0){
            		if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    		        <a href="javascript:update_mgr('0');"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp; 
          <%		}
    	    	}else{
            		if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>		
    	        	<a href="javascript:update_mgr('1');"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp; 
          <%		}
    	  		}%>		
    	  <%//}%>
        		<a href='javascript:window.close()'><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
 	    </td>
    </tr>
    <tr> 
        <td class=line2 colspan=3></td>
    </tr>
    <tr> 
        <td class='line' colspan="3"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=17% class='title'>성명</td>
                    <td class='title' width=20%>전화번호</td>
                    <td class='title' width=20%>휴대폰</td>
                    <td class='title' width=43%>E-MAIL</td>
                </tr>
                <tr> 
                    <td align='center'>
                      <input type='text' name='mgr_nm' size='12' maxlength='20' class='text' value="<%=mgr.getMgr_nm()%>">
                    </td>
                    <td align="center"> 
                      <input type='text' name='mgr_tel'   size='15' maxlength='15' class='text' value="<%=mgr.getMgr_tel()%>">
                    </td>
                    <td align="center"> 
                      <input type='text' name='mgr_m_tel' size='15' maxlength='15' class='text' value="<%=mgr.getMgr_m_tel()%>">
                    </td>
                    <td align="center"> 
                      <input type='text' name='mgr_email' size='38' class='text' style='IME-MODE: inactive' value="<%=mgr.getMgr_email()%>">
                    </td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>
                <tr> 
                    <td class='title'>실거주지 주소</td>
                    <td colspan="3">&nbsp; 
					<input type="text" name='t_zip' id="t_zip" value="<%= mgr.getMgr_zip() %>" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" value="<%=mgr.getMgr_addr()%>" size="70">

                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
<script language='javascript'>
	<%	if(!mode.equals("") && !flag){%>
			alert('처리 되지 않았습니다');
	<%	}else if(!mode.equals("") && flag){%>
			alert("처리 되었습니다");
	<%	}%>
</script>
</html>
