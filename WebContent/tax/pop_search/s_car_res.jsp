<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	if(s_kd.equals("3") && !t_wd.equals("") && !c_db.getNameById(t_wd,"USER").equals(""))	t_wd = c_db.getNameById(t_wd,"USER");
	
	Vector vt = new Vector();
	
	if(!t_wd.equals("")){
		vt = ClientMngDb.getCarResSearch(s_br, s_kd, t_wd);
	}
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//계약선택
	function Disp(rent_mng_id, rent_l_cd, car_mng_id, client_id, firm_nm, car_no, car_nm, car_y_form, color, car_gu, shin_car, car_no2){
		var fm = document.form1;
		<%if(go_url.equals("/fms2/consignment_new/cons_reg_step1.jsp")){%>
			opener.form1.rent_mng_id[<%=idx%>].value 	= rent_mng_id;
			opener.form1.rent_l_cd[<%=idx%>].value 		= rent_l_cd;
			opener.form1.car_mng_id[<%=idx%>].value 	= car_mng_id;
			opener.form1.client_id[<%=idx%>].value 		= client_id;
			opener.form1.firm_nm[<%=idx%>].value 		= firm_nm;			
			opener.form1.car_no[<%=idx%>].value 		= car_no;
			opener.form1.car_nm[<%=idx%>].value 		= car_nm;			
			opener.form1.car_y_form[<%=idx%>].value 	= car_y_form;
			opener.form1.color[<%=idx%>].value 			= color;			
//			opener.form1.car_gu[<%=idx%>].value 			= car_gu;
//			opener.form1.shin_car[<%=idx%>].value 			= shin_car;		
			if('<%=idx%>'=='0' && car_no2 != '')	opener.form1.car_no[<%=idx+1%>].value 		= car_no2;
			self.close();
		<%}else if(go_url.equals("/fms2/tint/tint_reg_step1.jsp")){%>
			opener.form1.rent_mng_id.value 		= rent_mng_id;
			opener.form1.rent_l_cd.value 		= rent_l_cd;
			opener.form1.car_mng_id.value 		= car_mng_id;
			opener.form1.client_id.value 		= client_id;
			opener.form1.firm_nm.value 			= firm_nm;			
			opener.form1.car_no.value 			= car_no;
			opener.form1.car_nm.value 			= car_nm;			
			opener.form1.car_y_form.value 		= car_y_form;
			opener.form1.color.value 			= color;			
			self.close();	
		<%}else if(go_url.equals("/fms2/mis/neom_i.jsp")){%>
			opener.form1.rent_mng_id.value 		= rent_mng_id;
			opener.form1.rent_l_cd.value 		= rent_l_cd;
			opener.form1.car_mng_id.value 		= car_mng_id;
			opener.form1.client_id.value 		= client_id;
			opener.form1.car_no.value 			= car_no;
			self.close();
		<%}else if(go_url.equals("/fms2/mis/neom_u.jsp")){%>
			opener.form1.rent_mng_id.value 		= rent_mng_id;
			opener.form1.rent_l_cd.value 		= rent_l_cd;
			opener.form1.car_mng_id.value 		= car_mng_id;
			opener.form1.client_id.value 		= client_id;
			opener.form1.car_no.value 			= car_no;
			self.close();					
		<%}else{%>
			opener.parent.c_foot.location.href = "<%=go_url%>?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&car_mng_id="+car_mng_id+"&client_id="+client_id;		
			self.close();
		<%}%>
	}
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='s_car_res.jsp'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style5>
						예약시스템 배/반차 차량 조회</span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>  	  
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle></a>&nbsp;		
        <select name='s_kd'>
          <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
          <option value='4' <%if(s_kd.equals("4"))%>selected<%%>>차대번호</option>		  
          <option value='5' <%if(s_kd.equals("5"))%>selected<%%>>담당자</option>		  		  
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		<a href="javascript:window.search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>		
      </td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title width="5%">연번</td>
            <td class=title width="5%">상태</td>			
            <td class=title width="10%">계약구분</td>						
            <td class=title width="10%">차량번호</td>
            <td class=title width="15%">차명</td>
            <td class=title width="15%">상호/성명</td>			
            <td class=title width="10%">대차대상</td>						
            <td class=title width="20%">사용기간</td>
            <td class=title width="10%">담당자</td>
          </tr>
          <%for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
          <tr align="center"> 
            <td><%=i+1%></td>
            <td><%=ht.get("USE_ST_NM")%></td>
            <td><%=ht.get("RENT_ST_NM")%></td>						
            <td><a href="javascript:Disp('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_NO")%>', '<%=ht.get("CAR_NM")%>', '<%=ht.get("CAR_Y_FORM")%>', '<%=ht.get("COLO")%>', '<%=ht.get("CAR_GU")%>', '<%=ht.get("SHIN_CAR")%>', '<%=ht.get("CAR_NO2")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_NO")%></a></td>
            <td><%=ht.get("CAR_NM")%></td>			
            <td><a href="javascript:Disp('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_NO")%>', '<%=ht.get("CAR_NM")%>', '<%=ht.get("CAR_Y_FORM")%>', '<%=ht.get("COLO")%>', '<%=ht.get("CAR_GU")%>', '<%=ht.get("SHIN_CAR")%>', '<%=ht.get("CAR_NO2")%>')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a></td>			
            <td><%=ht.get("CAR_NO2")%></td>									
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DELI_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RET_DT")))%></td>
            <td><%=ht.get("USER_NM")%></td>									
          </tr>
          <%		}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td>* 최근 두달이내 처리분입니다.</td>
    </tr>	
    <tr> 
      <td align="center"><a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		</td>
    </tr>
  </table>
</form>
</body>
</html>