<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String size	= request.getParameter("size")==null?"0":request.getParameter("size");
	
	Vector vt = new Vector();
	if(!t_wd.equals("")){
		vt = ClientMngDb.getCarSearch(s_br, s_kd, t_wd);
	}
	int vt_size = vt.size(); 
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src='/include/common.js'></script>
<script>
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
	function Disp(rent_mng_id, rent_l_cd, car_mng_id, client_id, firm_nm, car_no, car_nm, car_y_form, color, car_gu, shin_car, car_b, opt, car_name, hipass_yn){
		var fm = document.form1;
		
		
		<%if(go_url.equals("/fms2/consignment_new/cons_reg_step1.jsp")){%>
		
					opener.form1.rent_mng_id[<%=idx%>].value 	= rent_mng_id;
					opener.form1.rent_l_cd[<%=idx%>].value 		= rent_l_cd;
					opener.form1.car_mng_id[<%=idx%>].value 	= car_mng_id;
					opener.form1.client_id[<%=idx%>].value 		= client_id;
					opener.form1.firm_nm[<%=idx%>].value 		= firm_nm;			
					opener.form1.car_no[<%=idx%>].value 		= car_no;
					opener.form1.car_nm[<%=idx%>].value 		= car_nm+" "+car_name;			
					opener.form1.car_y_form[<%=idx%>].value 	= car_y_form;
					opener.form1.color[<%=idx%>].value 			= color;			
					opener.form1.car_b[<%=idx%>].value 			= car_b;			
					opener.form1.opt[<%=idx%>].value 			= opt;			
					opener.form1.r_hipass_yn[<%=idx%>].value 	= hipass_yn;
					//opener.form1.car_gu[<%=idx%>].value 		= car_gu;
					//opener.form1.shin_car[<%=idx%>].value 	= shin_car;	
					if(opener.form1.cons_cau[<%=idx%>].value=="7"){	
						opener.form1.sch_ac_c_id.value 	= car_mng_id;		
						opener.form1.sch_ac_car_no.value 	= car_no;
					}
							
			      self.close();
					
				<%} else if(go_url.equals("/off/consignment/cons_reg_step1.jsp")||go_url.equals("/off/consignment/cons_reg_step4.jsp") ||go_url.equals("/fms2/consignment_new/cons_reg_step4.jsp")){%>
				if(fm.size.value >1) {
					opener.form1.rent_mng_id[<%=idx%>].value 	= rent_mng_id;
					opener.form1.rent_l_cd[<%=idx%>].value 		= rent_l_cd;
					opener.form1.car_mng_id[<%=idx%>].value 	= car_mng_id;
					opener.form1.client_id[<%=idx%>].value 		= client_id;
					opener.form1.firm_nm[<%=idx%>].value 		= firm_nm;			
					opener.form1.car_no[<%=idx%>].value 		= car_no;
					opener.form1.car_nm[<%=idx%>].value 		= car_nm+" "+car_name;			
					opener.form1.car_y_form[<%=idx%>].value 	= car_y_form;
					opener.form1.color[<%=idx%>].value 		= color;			
					opener.form1.car_b[<%=idx%>].value 		= car_b;			
					opener.form1.opt[<%=idx%>].value 		= opt;			
					opener.form1.r_hipass_yn[<%=idx%>].value 	= hipass_yn;	
					//opener.form1.car_gu[<%=idx%>].value 		= car_gu;
					//opener.form1.shin_car[<%=idx%>].value 		= shin_car;
				}else {
					opener.form1.rent_mng_id.value 	= rent_mng_id;
					opener.form1.rent_l_cd.value 		= rent_l_cd;
					opener.form1.car_mng_id.value 	= car_mng_id;
					opener.form1.client_id.value 		= client_id;
					opener.form1.firm_nm.value 		= firm_nm;			
					opener.form1.car_no.value 		= car_no;
					opener.form1.car_nm.value 		= car_nm+" "+car_name;			
					opener.form1.car_y_form.value 	= car_y_form;
					opener.form1.color.value 		= color;			
					opener.form1.car_b.value 		= car_b;			
					opener.form1.opt.value 		= opt;			
					opener.form1.r_hipass_yn.value 	= hipass_yn;	
					//opener.form1.car_gu.value 		= car_gu;
					//opener.form1.shin_car.value 		= shin_car;
				}
						
			self.close();
		<%}else if(go_url.equals("/fms2/tint/tint_reg_step1.jsp")||go_url.equals("/off/tint/tint_reg_step1.jsp")){%>
			opener.form1.rent_mng_id.value 			= rent_mng_id;
			opener.form1.rent_l_cd.value 			= rent_l_cd;
			opener.form1.car_mng_id.value 			= car_mng_id;
			opener.form1.client_id.value 			= client_id;
			opener.form1.firm_nm.value 			= firm_nm;			
			opener.form1.car_no.value 			= car_no;
			opener.form1.car_nm.value 			= car_nm;			
			opener.form1.car_y_form.value 			= car_y_form;
			opener.form1.color.value 			= color;			
			self.close();	
		<%}else if(go_url.equals("/fms2/mis/neom_i.jsp")){%>
			opener.form1.rent_mng_id.value 			= rent_mng_id;
			opener.form1.rent_l_cd.value 			= rent_l_cd;
			opener.form1.car_mng_id.value 			= car_mng_id;
			opener.form1.client_id.value 			= client_id;
			opener.form1.car_no.value 			= car_no;
			self.close();
		<%}else if(go_url.equals("/acar/cus_reg/serv_reg.jsp")){%>
			opener.form1.rent_mng_id.value 			= rent_mng_id;
			opener.form1.rent_l_cd.value 			= rent_l_cd;			
			self.close();		
		<%}else if(go_url.equals("/fms2/mis/neom_u.jsp")){%>
			opener.form1.rent_mng_id.value 			= rent_mng_id;
			opener.form1.rent_l_cd.value 			= rent_l_cd;
			opener.form1.car_mng_id.value 			= car_mng_id;
			opener.form1.client_id.value 			= client_id;
			opener.form1.car_no.value 			= car_no;
			self.close();	
		<%}else if(go_url.equals("/fms2/tint/tint_reg_card.jsp")){%>
			opener.form1.rent_mng_id.value 			= rent_mng_id;
			opener.form1.rent_l_cd.value 			= rent_l_cd;
			opener.form1.car_mng_id.value 			= car_mng_id;
			opener.form1.client_id.value 			= client_id;
			opener.form1.firm_nm.value 			= firm_nm;			
			opener.form1.car_no.value 			= car_no;
			opener.form1.car_nm.value 			= car_nm;			
			opener.form1.car_y_form.value 			= car_y_form;
			opener.form1.color.value 			= color;		
			self.close();	
		<%}else{%>
			opener.parent.c_foot.location.href = "<%=go_url%>?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&car_mng_id="+car_mng_id+"&client_id="+client_id;		
			self.close();
		<%}%>
	}
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='s_car.jsp'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type='hidden' name='size' value='<%=size%>'>   
  <input type='hidden' name='go_url' value='<%=go_url%>'>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle></a>&nbsp;		
        <select name='s_kd'>
          <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
          <option value='4' <%if(s_kd.equals("4"))%>selected<%%>>차대번호</option>		  
          <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>계출번호</option>		  
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		<a href="javascript:search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>		
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=100%>
          <tr> 
            <td class=title width="3%">연번</td>
            <td class=title width="9%">차량번호</td>
            <td class=title width="22%">차명</td>
            <td class=title width="8%">최초등록일</td>			
            <td width="26%" class=title>상호</td>
            <td width="8%" class=title>관리구분</td>
            <td class=title width="16%">계약기간</td>
            <td class=title width="8%">해지일자</td>			
          </tr>
          <%for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String opt_1 = ht.get("OPT")+"";
				opt_1 = AddUtil.replace(opt_1,"\""," ");
				
				%>
          <tr align="center"> 
            <td><%=i+1%></td>
            <td><a href="javascript:Disp('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_NO")%>', '<%=ht.get("CAR_NM")%>', '<%=ht.get("CAR_Y_FORM")%>', '<%=ht.get("COLO")%>', '<%=ht.get("CAR_GU")%>', '<%=ht.get("SHIN_CAR")%>', '<%=ht.get("CAR_B")%>', '<%=opt_1%>', '<%=ht.get("CAR_NAME")%>', '<%=ht.get("HIPASS_YN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CAR_NO")%></a></td>
            <td><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>			
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
            <td><a href="javascript:Disp('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_NO")%>', '<%=ht.get("CAR_NM")%>', '<%=ht.get("CAR_Y_FORM")%>', '<%=ht.get("COLO")%>', '<%=ht.get("CAR_GU")%>', '<%=ht.get("SHIN_CAR")%>', '<%=ht.get("CAR_B")%>', '<%=opt_1%>', '<%=ht.get("CAR_NAME")%>', '<%=ht.get("HIPASS_YN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a></td>			
            <td><%=ht.get("RENT_WAY")%></td>		
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>			
          </tr>
          <%		}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>	
    <tr> 
      <td align="center"><a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		</td>
    </tr>
  </table>
</form>
</body>
</html>