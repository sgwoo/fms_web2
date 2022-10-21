<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.* ,acar.car_service.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	CarServDatabase csd = CarServDatabase.getInstance();	
	
	Vector card_kinds = new Vector();
	int ck_size = 0;
	
	if(!t_wd.equals("")){
		//장기계약 리스트 조회
		card_kinds = CardDb.getLongRents(t_wd);
		ck_size = card_kinds.size();
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="rent_search.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	function setCardCode(rent_mng_id, rent_l_cd, client_id, car_no, first_car_no, car_nm, firm_nm, car_mng_id, mgr_nm, mgr_tel, bus_id2, bus_nm2, bus_id, bus_nm, tot_dist, serv_dt){
		var fm = document.form1;
		<%if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
		opener.form1.rent_l_cd.value 		= rent_l_cd;	
		opener.form1.rent_mng_id.value 		= rent_mng_id;		
		opener.form1.client_id.value 		= client_id;		
		opener.form1.car_mng_id.value 		= car_mng_id;				
		opener.form1.p_cont.value 		= car_no+' '+car_nm+' '+firm_nm;
		opener.form1.buy_user_id.value 		= bus_id2;
		opener.form1.user_nm[0].value 		= bus_nm2;
		//차량이용자 디폴트 처리
		//if(opener.form1.acct_code.options[opener.form1.acct_code.selectedIndex].value == '45700' && opener.form1.acct_code_g[7].checked == true){ 	//차량정비비-일반수리
		if(opener.form1.acct_code.options[opener.form1.acct_code.selectedIndex].value == '45700' && opener.form1.acct_code_g[8].checked == true){ 	//차량정비비-일반수리
			opener.form1.call_t_nm.value 		= mgr_nm;		
			opener.form1.call_t_tel.value 		= mgr_tel;		
		}
		//재리스정비시 최초영업자
		//if(opener.form1.acct_code.options[opener.form1.acct_code.selectedIndex].value == '45700' && opener.form1.acct_code_g[8].checked == true){ 	//차량정비비-재리스수리비
		if(opener.form1.acct_code.options[opener.form1.acct_code.selectedIndex].value == '45700' && opener.form1.acct_code_g[9].checked == true){ 	//차량정비비-재리스수리비
		}
			opener.form1.buy_user_id.value 		= bus_id;
			opener.form1.user_nm[0].value 		= bus_nm;	
		}
		//차량주유카드로 주유시
		<%}else if(go_url.equals("cons_doc_reg_i.jsp")){%>  
			opener.form1.rent_l_cd.value = rent_l_cd;	
			opener.form1.item_name.value	= car_no;
			opener.form1.item_code.value	= car_mng_id;
	    	opener.form1.acct_cont.value = firm_nm + " - " + car_no;	
			opener.form1.last_dist.value=tot_dist;
			opener.form1.last_serv_dt.value=serv_dt;
		<%}else{%>
		 	opener.form1.rent_l_cd[0].value = rent_l_cd;	
			opener.form1.item_name[0].value	= car_no;
			opener.form1.item_code[0].value	= car_mng_id;
	    	opener.form1.acct_cont[0].value = firm_nm + " - " + car_no;	
			opener.form1.last_dist.value=tot_dist;
			opener.form1.last_serv_dt.value=serv_dt;
			opener.form1.tot_dist.value="";
			opener.form1.oil_liter.value="";
			
		<%}%>
		window.close();	
	}
	
//-->
</script>


</head>
<body>
<form action="./rent_search.jsp" name="form1" method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>  
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">  
  <input type="hidden" name="go_url" value="<%=go_url%>">    
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td>
        <input name="t_wd" type="text" class="text" value="<%=t_wd%>" size="50" onKeyDown="javasript:enter()" style='IME-MODE: active'>
        &nbsp;<a href="javascript:Search();" ><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class="line" >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='8%' class='title'>연번</td>
            <td width='8%' class='title'>구분</td>			
            <td width='18%' class='title'>계약번호</td>
            <td width='40%' class='title'>상호</td>
            <td width='16%' class='title'>차량번호</td>
            <td width='10%' class='title'>대여방식</td>
          </tr>
          <%	if(ck_size > 0){
					for (int i = 0 ; i < ck_size ; i++){
						Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);
						Hashtable ht9 = csd.getCarInfo(String.valueOf(card_kind.get("CAR_MNG_ID")));
						%>
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><%= card_kind.get("USE_YN") %></td>			
            <td align="center">
			<a href="javascript:setCardCode('<%= card_kind.get("RENT_MNG_ID") %>','<%= card_kind.get("RENT_L_CD") %>','<%= card_kind.get("CLIENT_ID") %>','<%= card_kind.get("CAR_NO") %>','<%= card_kind.get("FIRST_CAR_NO") %>','<%= card_kind.get("CAR_NM") %>','<%= card_kind.get("FIRM_NM") %>','<%= card_kind.get("CAR_MNG_ID") %>','<%= card_kind.get("MGR_NM") %>','<%= card_kind.get("MGR_TEL") %>','<%= card_kind.get("BUS_ID2") %>','<%= card_kind.get("BUS_NM2") %>','<%= card_kind.get("BUS_ID") %>','<%= card_kind.get("BUS_NM") %>','<%= ht9.get("TOT_DIST") %>','<%= ht9.get("SERV_DT") %>')"><%= card_kind.get("RENT_L_CD") %></a>
			</td>
            <td align="center"><%= card_kind.get("FIRM_NM") %></td>
            <td align="center"><%= card_kind.get("CAR_NO") %></td>						
            <td align="center"><%= card_kind.get("RENT_WAY") %></td>						
          </tr>
		  <%	}%>
		  <%}else{%>
          <tr>		  
            <td colspan="6" align="center">등록된 데이타가 없습니다.</td>
          </tr>
		  <%}%>		  
        </table>
	</td>
  </tr>
    <tr>
      <td>&nbsp;<font color="#666666">* 구분 : Y 대여 / N 해지 / '' 미결</font>&nbsp;</td>
    </tr>
    <tr>
      <td align="right"><a href="javascript:window.close();"  ><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
  </table>
</form>
</body>
</html>

