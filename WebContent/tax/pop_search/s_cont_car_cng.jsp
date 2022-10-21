<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, tax.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String memo_st = request.getParameter("memo_st")==null?"":request.getParameter("memo_st");
	
	Vector accids = ClientMngDb.getCarCngRentListSearch(s_br, s_kd, t_wd);
	int accid_size = accids.size();
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
	function Disp(rent_mng_id, rent_l_cd, car_mng_id, client_id, firm_nm, client_nm, car_no, car_nm){
		var fm = document.form1;
		<%if(go_url.equals("/fms2/consignment_new/cons_reg_step1.jsp")){%>
			opener.form1.rent_mng_id[<%=idx%>].value 	= rent_mng_id;
			opener.form1.rent_l_cd[<%=idx%>].value 		= rent_l_cd;
			opener.form1.car_mng_id[<%=idx%>].value 	= car_mng_id;
			opener.form1.client_id[<%=idx%>].value 		= client_id;
			opener.form1.car_no[<%=idx%>].value 		= car_no;
			opener.form1.car_nm[<%=idx%>].value 		= car_nm;			
			self.close();
		<%}else if(go_url.equals("/fms2/con_fee/credit_memo_frame.jsp")){%>
			opener.parent.location.href = "<%=go_url%>?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&memo_st=<%=memo_st%>&m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&c_id="+car_mng_id+"&client_id="+client_id;		
			self.close();
		<%}else{%>
			opener.parent.c_foot.location.href = "<%=go_url%>?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&car_mng_id="+car_mng_id+"&client_id="+client_id;		
			self.close();
		<%}%>
	}
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='s_cont_car_cng.jsp'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
 <input type='hidden' name='memo_st' value='<%=memo_st%>'>  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
              <!-- <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>차량번호</option>
              <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>차대번호</option>		 -->	  
              <option value='4' <%if(s_kd.equals("4"))%>selected<%%>>계약번호</option>			  
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    <a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=5%>연번</td>
                    <td class=title width=5%>구분</td>
                    <td class=title width=12%>계약번호</td>
                    <td class=title width=21%>상호</td>
                    <td class=title width=12%>차량번호</td>
                    <td class=title width=15%>차명</td>			
                    <td class=title width=20%>계약기간</td>
                    <td class=title width=10%>해지일자</td>
                </tr>
          <%for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <%if(accid.get("USE_YN").equals("Y")){%>
                      대여 
                      <%}else if(accid.get("USE_YN").equals("N")){%>
        			  해지
                      <%}else{%>
                      미결
                      <%}%>
                    </td>
                    <td>
						<%if(go_url.equals("/fms2/lc_rent/lc_cng_new_car_c.jsp") && !String.valueOf(accid.get("CAR_MNG_ID")).equals("")){%>
						<%=accid.get("RENT_L_CD")%>
						<%}else{%>
						<a href="javascript:Disp('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>', '<%=accid.get("CLIENT_ID")%>', '<%=accid.get("FIRM_NM")%>', '<%=accid.get("CLIENT_NM")%>', '<%=accid.get("CAR_NO")%>', '<%=accid.get("CAR_NM")%>')" onMouseOver="window.status=''; return true"><%=accid.get("RENT_L_CD")%></a>
						<%}%>
					</td>
                    <td><%=accid.get("FIRM_NM")%></td>
                    <td><%=accid.get("CAR_NO")%></td>
                    <td><%=accid.get("CAR_NM")%></td>			
                    <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_END_DT")))%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("CLS_DT")))%></td>
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td align="center"><a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>