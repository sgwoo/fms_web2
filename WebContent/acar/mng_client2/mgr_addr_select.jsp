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
//		if(fm.mgr_nm.value == ''){ alert("성명을 입력하십시오."); return; }
		if(confirm('수정하시겠습니까?')){
			if(fm.email_1.value != '' && fm.email_2.value != ''){
				fm.mgr_email.value = fm.email_1.value+'@'+fm.email_2.value;
			}
			fm.target = 'i_no';
			fm.submit();
		}		
	}
	

//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String mgr_st = request.getParameter("mgr_st")==null?"":request.getParameter("mgr_st");	
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
//	System.out.println("vid_size=" + vid_size);
	
	
	

	CarMgrBean mgr = a_db.getCarMgr(m_id, l_cd, mgr_st);
	
	if(vid_size>0){
		for(int i=0;i < 1;i++){
			
			m_id = vid[i].substring(0,6);
			l_cd = vid[i].substring(6,19);
			
			mgr = a_db.getCarMgr(m_id, l_cd, mgr_st);
		}
	}
	
	ClientBean client = al_db.getNewClient(client_id);
%>
<form name='form1' method='post' action='mgr_addr_select_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>

<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type="hidden" name="mgr_st" value="<%=mgr_st%>">
<input type="hidden" name="mgr_id" value="<%=mgr.getMgr_id()%>">
<input type='hidden' name='mode' value=''>
<%for(int i=0;i < vid_size;i++){%>		
<input type='hidden' name='ch_cd' 	value='<%=vid[i]%>'>
<%	}%>
<table border="0" cellspacing="0" cellpadding="0" width=610>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>거래처 > <span class=style5><%=client.getFirm_nm()%> (<%=car_no%>)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=mgr_st%></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=610>
                <tr>
                    <td width='120' class='title'>성명</td>
                    <td width="180">&nbsp;
                        <input type='text' name='mgr_nm' size='15' maxlength='20' class='text' value="<%=mgr.getMgr_nm()%>"></td>
                    <td width="120" class='title'>운전면허번호</td><!-- 운전면허번호추가(20180921) -->
                    <td width="180">&nbsp;
                        <input type='text' name='lic_no' size='26' maxlength='20' class='text' value="<%=mgr.getLic_no()%>"></td>
                </tr>
                <tr>
                    <td class='title'>부서</td>
                    <td width="180">&nbsp;
                        <input type='text' name='mgr_dept'   size='26' maxlength='15' class='text' value="<%=mgr.getMgr_dept()%>"></td>
                    <td width="120" class='title'>직위</td>
                    <td width="180">&nbsp;
                        <input type='text' name='mgr_title' size='26' maxlength='15' class='text' value="<%=mgr.getMgr_title()%>"></td>
                </tr>
                <tr>
                    <td class='title'>전화번호</td>
                    <td>&nbsp;
                        <input type='text' name='mgr_tel'   size='26' maxlength='15' class='text' value="<%=mgr.getMgr_tel()%>"></td>
                    <td class='title'>휴대폰</td>
                    <td>&nbsp;
                        <input type='text' name='mgr_m_tel' size='26' maxlength='15' class='text' value="<%=mgr.getMgr_m_tel()%>"></td>
                </tr>
						<%	String email_1 = "";
							String email_2 = "";
							if(!mgr.getMgr_email().equals("")){
								int mail_len = mgr.getMgr_email().indexOf("@");
								if(mail_len > 0){
									email_1 = mgr.getMgr_email().substring(0,mail_len);
									email_2 = mgr.getMgr_email().substring(mail_len+1);
								}
							}
						%>											
                <tr>
                    <td class='title'>E-MAIL</td>
                    <td colspan="3">&nbsp;
						<input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  			<select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
								  <option value="" selected>선택하세요</option>
								  <option value="hanmail.net">hanmail.net</option>
								  <option value="naver.com">naver.com</option>
								  <option value="nate.com">nate.com</option>
								  <option value="bill36524.com">bill36524.com</option>
								  <option value="gmail.com">gmail.com</option>
								  <option value="paran.com">paran.com</option>
								  <option value="yahoo.com">yahoo.com</option>
								  <option value="korea.com">korea.com</option>
								  <option value="hotmail.com">hotmail.com</option>
								  <option value="chol.com">chol.com</option>
								  <option value="daum.net">daum.net</option>
								  <option value="hanafos.com">hanafos.com</option>
								  <option value="lycos.co.kr">lycos.co.kr</option>
								  <option value="dreamwiz.com">dreamwiz.com</option>
								  <option value="unitel.co.kr">unitel.co.kr</option>
								  <option value="freechal.com">freechal.com</option>
								  <option value="">직접 입력</option>
					  		    </select>
					  		  <input type='hidden' name='mgr_email' value='<%=mgr.getMgr_email()%>'>
                        <!--<input type='text' name='mgr_email' size='47' class='text' style='IME-MODE: inactive' value="<%=mgr.getMgr_email()%>">-->
					</td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address +" ("+ data.buildingName+")";
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>우편물주소</td>
				  <td colspan=3>&nbsp;
					<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=mgr.getMgr_zip()%>">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="67" value="<%=mgr.getMgr_addr()%>">
				  </td>
				</tr>
				
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
	    <a href="javascript:update_mgr();"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>&nbsp; 
        <a href='javascript:window.close()'><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
